import { useState } from "react";
import "../assets/style/Forms.css";
import { Box } from "@mui/material";
import AccountCircle from "@mui/icons-material/AccountCircle";
import MyPassField from "./forms/MyPassField";
import MyButton from "./forms/MyButton";
import { useForm } from "react-hook-form";
import AxiosInstance from "../services/AxiosInstance";
import { useNavigate } from "react-router-dom";
import React, { useContext } from "react";
import { AuthContext } from "./AuthContext";
import MyTextField from "./forms/MyTextField";
import LockIcon from "@mui/icons-material/Lock";
function LoginForm() {
  const navigate = useNavigate();
  const { handleSubmit, control } = useForm();
  const [errorMessage, setErrorMessage] = useState("");
  const { login } = useContext(AuthContext);

  const onSubmit = (data) => {
    let invalid = false;
    if (data.username === "") {
      control.setError("username", {
        type: "manual",
        message: "This field is required",
      });
      invalid = true;
    }
    if (data.password === "") {
      control.setError("password", {
        type: "manual",
        message: "This field is required",
      });
      invalid = true;
    }

    if (invalid) {
      return;
    }

    AxiosInstance.post(`/api/token/`, {
      username: data.username,
      password: data.password,
    })
      .then((response) => {
        navigate(`/home`);
        login(response.data.access, response.data.refresh, data.username);
      })
      .catch((error) => {
        setErrorMessage("The username or password you entered is incorrect");
      });
  };

  return (
    <div className={"myBackground"}>
      <form onSubmit={handleSubmit(onSubmit)}>
        <Box className={"whiteBox"}>
          <Box className={"itemBox"}>
            <Box className={"title"}>
              <h2>Log in to your account</h2>
            </Box>
          </Box>

          <Box
            className={"itemBox"}
            sx={{ display: "flex", alignItems: "center" }}
          >
            <AccountCircle sx={{ color: "action.active", mr: 1, mt: 3 }} />
            <MyTextField
              label={"Username"}
              name={"username"}
              control={control}
            />
          </Box>
          <Box
            className={"itemBox"}
            sx={{ display: "flex", alignItems: "center" }}
          >
            <LockIcon sx={{ color: "action.active", mr: 1, mt: 3 }} />
            <MyPassField
              label={"Password"}
              name={"password"}
              control={control}
            />
          </Box>

          <Box className={"itemBox"}>
            <MyButton label={"Login"} type={"submit"} />
          </Box>
        </Box>
        {errorMessage && (
          <Box sx={{ color: "red", textAlign: "center" }}>{errorMessage}</Box>
        )}
      </form>
    </div>
  );
}

export default LoginForm;
