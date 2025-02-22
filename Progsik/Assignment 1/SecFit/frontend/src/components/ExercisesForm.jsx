import { useEffect, useState } from "react";
import { Box } from "@mui/material";
import MyButton from "./forms/MyButton";
import { useNavigate } from "react-router-dom";
import { useForm } from "react-hook-form";
import AxiosInstance from "../services/AxiosInstance";
import { Controller } from "react-hook-form";
import MyTextField from "./forms/MyTextField";
import { SessionService } from "../services/session";

function ExercisesForm({ exerciseId }) {
  const navigate = useNavigate();
  const { control, handleSubmit, reset } = useForm();
  const [errorMessage, setErrorMessage] = useState("");
  const [exercise, setExercise] = useState(null);

  const accessToken = SessionService.getLocalAccessToken();

  useEffect(() => {
    if (exerciseId) {
      AxiosInstance.get(`/api/exercises/${exerciseId}`, {
        headers: {
          Authorization: `Bearer ${accessToken}`,
        },
      })
        .then((response) => {
          setExercise(response.data);
          reset(response.data);
        })
        .catch((error) => {
          setErrorMessage("Error loading exercise");
          console.error(error);
        });
    }
  }, [accessToken, exerciseId, reset]);
  const onSubmit = (data) => {
    if (exerciseId) {
      // Update existing exercise
      AxiosInstance.put(`/api/exercises/${exerciseId}/`, data, {
        headers: {
          Authorization: `Bearer ${accessToken}`,
        },
      })
        .then(() => {
          navigate(`/exercises`);
        })
        .catch((error) => {
          setErrorMessage("Error updating exercise. Invalid data.");
        });
    } else {
      // Create a new exercise
      AxiosInstance.post("/api/exercises/", data, {
        headers: {
          Authorization: `Bearer ${accessToken}`,
        },
      })
        .then(() => {
          navigate(`/exercises`);
        })
        .catch((error) => {
          setErrorMessage("Error creating exercise. Invalid data:" + error);
        });
    }
  };

  return (
    <div className={"myBackground"}>
      <form onSubmit={handleSubmit(onSubmit)}>
        <Box className={"whiteBox"}>
          <Box className={"itemBox"}>
            <Box className={"title"}>
              <h2>View/Edit Exercise</h2>
            </Box>
          </Box>
          <Box className={"itemBox"}>
            <Controller
              name={"name"}
              control={control}
              defaultValue={exercise?.name || ""}
              render={({ field }) => (
                <MyTextField label={"Name"} {...field} control={control} />
              )}
            />
          </Box>
          <Box className={"itemBox"}>
            <Controller
              name={"description"}
              control={control}
              defaultValue={exercise?.description || ""}
              render={({ field }) => (
                <MyTextField
                  label={"Description"}
                  {...field}
                  control={control}
                />
              )}
            />
          </Box>
          <Box className={"itemBox"}>
            <Controller
              name={"unit"}
              control={control}
              defaultValue={exercise?.unit || ""}
              render={({ field }) => (
                <MyTextField label={"Unit"} {...field} control={control} />
              )}
            />
          </Box>
          <Box className={"itemBox"}>
            <MyButton label={"Edit"} type={"submit"} />
          </Box>
        </Box>
        {errorMessage && (
          <Box sx={{ color: "red", textAlign: "center" }}>{errorMessage}</Box>
        )}
      </form>
    </div>
  );
}

export default ExercisesForm;
