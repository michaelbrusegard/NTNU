import { useContext } from "react";
import { Navigate, Outlet } from "react-router-dom";
import { AuthContext } from "./AuthContext";

export const ProtectedRoute = ({ redirectPath = "/home" }) => {
  const authContext = useContext(AuthContext);

  const { isAuthenticated, loading } = authContext;

  if (loading) {
    return <p>Loading...</p>;
  }

  if (!isAuthenticated) {
    return <Navigate to={redirectPath} replace />;
  }
  return <Outlet />;
};
