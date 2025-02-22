import React, { createContext, useState, useEffect } from "react";
import AxiosInstance from "../services/AxiosInstance";
import { SessionService } from "../services/session";

export const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const accessToken = SessionService.getLocalAccessToken();
    const refreshToken = SessionService.getLocalRefreshToken();

    if (accessToken) {
      AxiosInstance.post("/api/token/verify/", { token: accessToken })
        .then(setIsAuthenticated(true))
        .catch((error) => {
          if (refreshToken) {
            AxiosInstance.post("api/token/refresh/", { refresh: refreshToken })
              .then((res) => {
                const newAccessToken = res.data.access;
                SessionService.setLocalRefreshToken(newAccessToken);
                setIsAuthenticated(true);
              })
              .catch((err) => {
                console.error("Refresh token invalid", err);
                logout();
              });
          } else {
            console.error("Bad access token", error);
          }
        });
    } else {
      logout();
    }
    setLoading(false);
  }, []);

  const login = (accessToken, refreshToken, username) => {
    SessionService.setLocalAccessToken(accessToken);
    SessionService.setLocalRefreshToken(refreshToken);
    AxiosInstance.get(`/api/users/${username}/`, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    })
      .then((response) => {
        SessionService.setUserId(response.data.id);
        SessionService.setUserName(username);
        SessionService.setIsCoach(response.data.isCoach);
        setIsAuthenticated(true);
      })
      .catch((error) => {
        console.error("Error retrieving user ID", error);
      });
  };

  const logout = () => {
    SessionService.removeLocalAccessToken();
    SessionService.removeLocalRefreshToken();
    SessionService.removeUserId();
    SessionService.removeUserName();
    SessionService.removeIsCoach();

    setIsAuthenticated(false);
  };

  return (
    <AuthContext.Provider value={{ isAuthenticated, login, logout, loading }}>
      {children}
    </AuthContext.Provider>
  );
};
