import axios from "axios";

// Changes baseURL for API requests based on the environment, uses localhost/api for prod, and localhost:8000/api for dev
const baseURL = process.env.NODE_ENV === "development" ? "http://localhost:8000/" : "/"

const AxiosInstance = axios.create({
  baseURL: baseURL,
  timeout: 5000,
  headers: {
    "Content-Type": "application/json",
    accept: "application/json",
  },
});

export default AxiosInstance;
