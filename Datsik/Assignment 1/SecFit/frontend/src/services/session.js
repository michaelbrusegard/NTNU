const getLocalAccessToken = () => {
  return localStorage.getItem("accessToken");
};

const setLocalAccessToken = (token) => {
  localStorage.setItem("accessToken", token);
};

const removeLocalAccessToken = () => {
  localStorage.removeItem("accessToken");
};

const getLocalRefreshToken = () => {
  return localStorage.getItem("refreshToken");
};

const setLocalRefreshToken = (token) => {
  localStorage.setItem("refreshToken", token);
};

const removeLocalRefreshToken = () => {
  localStorage.removeItem("refreshToken");
};

const getUserId = () => {
  return localStorage.getItem("userId");
};

const setUserId = (id) => {
  localStorage.setItem("userId", id);
};

const removeUserId = () => {
  localStorage.removeItem("userId");
};

const getUserName = () => {
  return localStorage.getItem("userName");
};

const setUserName = (name) => {
  localStorage.setItem("userName", name);
};

const removeUserName = () => {
  localStorage.removeItem("userName");
};

const getIsCoach = () => {
  const localIsCoach = localStorage.getItem("isCoach");
  return localIsCoach === "true";
};

const setIsCoach = (isCoach) => {
  localStorage.setItem("isCoach", isCoach);
};

const removeIsCoach = () => {
  localStorage.removeItem("isCoach");
};

export const SessionService = {
  getUserId,
  setUserId,
  removeUserId,
  getUserName,
  setUserName,
  removeUserName,
  getIsCoach,
  setIsCoach,
  removeIsCoach,
  getLocalAccessToken,
  setLocalAccessToken,
  removeLocalAccessToken,
  getLocalRefreshToken,
  setLocalRefreshToken,
  removeLocalRefreshToken,
};
