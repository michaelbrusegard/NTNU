import React, { useState, useEffect } from "react";
import "../assets/style/Forms.css";
import { Box } from "@mui/material";
import AccountCircle from "@mui/icons-material/AccountCircle";
import EmailIcon from "@mui/icons-material/Email";
import BadgeIcon from "@mui/icons-material/Badge";
import GradeIcon from "@mui/icons-material/Grade";
import MyPassField from "./forms/MyPassField";
import MyButton from "./forms/MyButton";
import { useForm } from "react-hook-form";
import AxiosInstance from "../services/AxiosInstance";
import { useNavigate } from "react-router-dom";
import MySelectField from "./forms/MySelectField";
import MyTextField from "./forms/MyTextField";
import LockIcon from "@mui/icons-material/Lock";

function SignupForm() {
  const navigate = useNavigate();
  const { control, handleSubmit, watch } = useForm();
  const [errorMessage, setErrorMessage] = useState("");
  const [isCoach, setIsCoach] = useState(false);

  const selectedStatus = watch("isCoach");
  useEffect(() => {
    setIsCoach(selectedStatus === "True");
  }, [selectedStatus]);
  const onSubmit = (data) => {
    const requestData = {
      ...data,
      athletes: [],
      workouts: [],
      coach_files: [],
      athlete_files: [],
    };

    AxiosInstance.post("/api/users/", requestData)
      .then((response) => {
        navigate(`/login`);
      })
      .catch((error) => {
        setErrorMessage("Error registering user. Invalid data.");
      });
  };

  return (
    <div className={"myBackground"}>
      <form onSubmit={handleSubmit(onSubmit)}>
        <Box className={"whiteBox"}>
          <Box className={"itemBox"}>
            <Box className={"title"}>
              <h2>Register as a new user</h2>
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
            <EmailIcon sx={{ color: "action.active", mr: 1, mt: 3 }} />
            <MyTextField label={"Email"} name={"email"} control={control} />
          </Box>
          <Box
            className={"itemBox"}
            sx={{ display: "flex", alignItems: "center" }}
          >
            <BadgeIcon sx={{ color: "action.active", mr: 1, mt: 3 }} />

            <MySelectField
              label={"Status"}
              name={"isCoach"}
              control={control}
              items={[
                { value: "False", label: "Athlete" },
                { value: "True", label: "Coach" },
              ]}
            />
          </Box>
          {isCoach && (
            <Box
              className={"itemBox"}
              sx={{ display: "flex", alignItems: "center" }}
            >
              <GradeIcon sx={{ color: "action.active", mr: 1, mt: 3 }} />
              <MyTextField
                label={"Specialism"}
                name={"specialism"}
                control={control}
              />
            </Box>
          )}
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
          <Box
            className={"itemBox"}
            sx={{ display: "flex", alignItems: "center" }}
          >
            <LockIcon sx={{ color: "action.active", mr: 1, mt: 3 }} />
            <MyPassField
              label={"Confirm password"}
              name={"password1"}
              control={control}
            />
          </Box>

          <Box className={"itemBox"}>
            <MyButton label={"Register"} type={"submit"} />
          </Box>
        </Box>
        {errorMessage && (
          <Box sx={{ color: "red", textAlign: "center" }}>{errorMessage}</Box>
        )}
      </form>
    </div>
  );
}

export default SignupForm;
