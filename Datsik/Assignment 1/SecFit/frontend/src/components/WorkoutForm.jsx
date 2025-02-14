import { useEffect, useState } from "react";
import { Box } from "@mui/material";
import MyTextField from "./forms/MyTextField";
import MyDateTimeField from "./forms/MyDateTimeField";
import MyButton from "./forms/MyButton";
import { useNavigate } from "react-router-dom";
import { useForm } from "react-hook-form";
import AxiosInstance from "../services/AxiosInstance";
import { IconButton } from "@mui/material";
import DeleteIcon from "@mui/icons-material/Delete";
import MySelectField from "./forms/MySelectField";
import Paper from "@mui/material/Paper";
import { SessionService } from "../services/session";
import CommentSection from "./CommentSectionForm";

function WorkoutForm({ workoutId }) {
  const navigate = useNavigate();

  const {
    control: workoutControl,
    handleSubmit: handleWorkoutSubmit,
    reset: resetWorkout,
  } = useForm();
  const { control: exerciseControl, handleSubmit: handleExerciseSubmit } =
    useForm();

  const [exercises, setExercises] = useState([]);
  const [user, setUser] = useState("");
  const [exerciseInstances, setExerciseInstances] = useState([]);
  const [workout, setWorkout] = useState({});
  const [isOwner, setIsOwner] = useState(true);
  const [errorMessage, setErrorMessage] = useState("");

  const accessToken = SessionService.getLocalAccessToken();
  const userId = SessionService.getUserId();

  useEffect(() => {
    AxiosInstance.get(`/api/users/${userId}/`, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    })
      .then((userResponse) => {
        setUser(userResponse.data);
        if (workoutId) {
          AxiosInstance.get(`/api/workouts/${workoutId}/`, {
            headers: {
              Authorization: `Bearer ${accessToken}`,
            },
          })
            .then((workoutResponse) => {
              setWorkout(workoutResponse.data);
              setIsOwner(workoutResponse.data.owner === userResponse.data.url);
              if (workoutResponse.data.exercise_instances) {
                const exercisesInstancesPromises =
                  workoutResponse.data.exercise_instances.map(
                    (exerciseInstanceData) =>
                      AxiosInstance.get(exerciseInstanceData.url, {
                        headers: {
                          Authorization: `Bearer ${accessToken}`,
                        },
                      })
                  );
                Promise.all(exercisesInstancesPromises)
                  .then((responses) => {
                    setExerciseInstances(
                      responses.map((response) => response.data)
                    );
                  })
                  .catch((error) => {
                    console.error(error);
                  });
              }
              resetWorkout(workoutResponse.data);
            })
            .catch((error) => {
              console.error(error);
            });
        }
      })
      .catch((error) => {
        console.error(error);
      });
  }, [userId, accessToken, workoutId, resetWorkout]);

  useEffect(() => {
    AxiosInstance.get("api/exercises/", {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    })
      .then((response) => {
        setExercises(response.data);
      })
      .catch((error) => {
        console.error(error);
      });
  }, [accessToken]);

  const onSubmit = (data) => {
    const workoutData = { ...data, owner: userId, exercise_instances: [] }; // set the owner field to the user id
    if (!isOwner) return;
    if (workoutId) {
      AxiosInstance.put(`/api/workouts/${workoutId}/`, workoutData, {
        headers: {
          Authorization: `Bearer ${accessToken}`,
        },
      })
        .then((response) => {
          const workoutUrl = response.data.url; // URL of the created workout
          // Create the exercise instances
          const exerciseInstancesData = exerciseInstances.map(
            (exerciseInstance) => ({
              ...exerciseInstance,
              workout: workoutUrl, // URL of the associated workout
            })
          );
          const exerciseInstancePromises = exerciseInstancesData.map(
            (exerciseInstanceData) =>
              AxiosInstance.post(
                "/api/exercise-instances/",
                exerciseInstanceData,
                {
                  headers: {
                    Authorization: `Bearer ${accessToken}`,
                  },
                }
              )
          );
          Promise.all(exerciseInstancePromises)
            .then((responses) => {
              navigate(`/workouts`);
            })
            .catch((error) => {
            });
        })
        .catch((error) => {
          setErrorMessage("Error saving workout");
        });
    } else {
      AxiosInstance.post("/api/workouts/", workoutData, {
        headers: {
          Authorization: `Bearer ${accessToken}`,
        },
      })
        .then((response) => {
          const workoutUrl = response.data.url; // URL of the created workout
          // Create the exercise instances
          const exerciseInstancesData = exerciseInstances.map(
            (exerciseInstance) => ({
              ...exerciseInstance,
              workout: workoutUrl, // URL of the associated workout
            })
          );
          const exerciseInstancePromises = exerciseInstancesData.map(
            (exerciseInstanceData) =>
              AxiosInstance.post(
                "/api/exercise-instances/",
                exerciseInstanceData,
                {
                  headers: {
                    Authorization: `Bearer ${accessToken}`,
                  },
                }
              )
          );
          Promise.all(exerciseInstancePromises)
            .then((responses) => {
              navigate(`/workouts`);
            })
            .catch((error) => {});
        })
        .catch((error) => {
          setErrorMessage("Error saving workout");
        });
    }
  };

  const addExercise = (data) => {
    const exerciseUrl = `/api/exercises/${data.exercise}/`;
    const exercise = {
      ...data,
      exercise: exerciseUrl,
      sets: parseInt(data.sets),
      number: parseInt(data.number),
    };
    AxiosInstance.get(exerciseUrl, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    })
      .then((response) => {
        setExerciseInstances((prevExerciseInstances) => [
          ...prevExerciseInstances,
          { ...exercise, exerciseDetail: response.data },
        ]);
      })
      .catch((error) => {
        console.error(error);
      });
  };

  const handleRemoveExercise = (index) => {
    if (!isOwner) {
      return;
    }
    const newExerciseInstances = [...exerciseInstances];
    newExerciseInstances.splice(index, 1);
    setExerciseInstances(newExerciseInstances);
  };

  const getIdFromExerciseUrl = (url) => {
    return url.split('/').at(-2)
  }

  const getNameFromExerciseUrl = (url) => {
    for (let i = 0; i < exercises.length; i++) {
      const id = Number(getIdFromExerciseUrl(url));
      const exercise = exercises[i];
      if (exercise.id === id) {
        return exercise.name;
      }
    }
  };

  const getUnitFromExerciseUrl = (url) => {
    for (let i = 0; i < exercises.length; i++) {
      const id = Number(getIdFromExerciseUrl(url));
      const exercise = exercises[i];
      if (exercise.id === id) {
        return exercise.unit;
      }
    }
  };

  return (
    <div style={{ display: "flex", flexDirection: "column" }}>
      <div className={"myBackground"}>
        <form onSubmit={handleWorkoutSubmit(onSubmit)}>
          <Box className={"whiteBox"}>
            <Box className={"itemBox"}>
              <Box className={"title"}>
                <h2>View/Edit Workout</h2>
              </Box>
            </Box>
            <Box className={"itemBox"}>
              <MyTextField
                label={"Name"}
                name={"name"}
                isDisabled={!isOwner}
                control={workoutControl}
              />
            </Box>
            <Box className={"itemBox"}>
              <MyDateTimeField
                label={"Date/Time"}
                name={"date"}
                isDisabled={!isOwner}
                control={workoutControl}
              />
            </Box>
            <Box className={"itemBox"}>
              <MyTextField
                isDisabled={true}
                label={"Owner"}
                name={"owner"}
                value={workout?.owner_username ?? user.username}
                control={workoutControl}
              />
              <MySelectField
                label={"Visibility"}
                name={"visibility"}
                isDisabled={!isOwner}
                control={workoutControl}
                items={[
                  { value: "PU", label: "Public" },
                  { value: "CO", label: "Coach" },
                  { value: "PR", label: "Private" },
                ]}
              />
            </Box>
            <Box className={"itemBox"}>
              <MyTextField
                label={"Notes"}
                name={"notes"}
                multiline
                isDisabled={!isOwner}
                control={workoutControl}
              />
            </Box>
            <Box className={"itemBox"}>
              {isOwner ? (
                <>
                  <MyButton label={"Ok"} type={"submit"} />
                  <MyButton label={"Cancel"} type={"reset"} />
                </>
              ) : (
                <p>You do not have permission to edit this workout.</p>
              )}
            </Box>
            {errorMessage && (
                <Box sx={{ color: "red", textAlign: "center" }}>
                  {errorMessage}
                </Box>
              )}
          </Box>
        </form>
        <form onSubmit={handleExerciseSubmit(addExercise)}>
          <Box className={"itemBox"}>
            <Box className={"title"}>
              <h2>Exercises</h2>
            </Box>
          </Box>
          {isOwner &&
            (exercises.length > 0 ? (
              <div>
                <Box className={"itemBox"}>
                  <MySelectField
                    label="Exercises"
                    name="exercise"
                    control={exerciseControl}
                    items={exercises.map((exercise) => ({
                      value: exercise.id,
                      label: exercise.name,
                    }))}
                  />
                </Box>
                <Box className={"itemBox"}>
                  <MyTextField
                    label="Sets"
                    name="sets"
                    type="number"
                    control={exerciseControl}
                  />
                  <MyTextField
                    label="Number"
                    name="number"
                    type="number"
                    control={exerciseControl}
                  />
                </Box>
                <Box className={"itemBox"}>
                  <MyButton label="Add exercise" type="submit" />
                </Box>
              </div>
            ) : (
              <p>No exercises available</p>
            ))}
          <Box className={"itemBox"}>
            <ul>
              {exerciseInstances.map((exerciseInstance, index) => (
                <Paper key={index}>
                  {getNameFromExerciseUrl(exerciseInstance.exercise)} -{" "}
                  {exerciseInstance.sets} sets of {exerciseInstance.number}{" "}
                  {getUnitFromExerciseUrl(exerciseInstance.exercise)}
                  <IconButton
                    type="button"
                    onClick={() => handleRemoveExercise(index)}
                    aria-label="delete"
                  >
                    <DeleteIcon />
                  </IconButton>
                </Paper>
              ))}
            </ul>
          </Box>
        </form>
      </div>
      <CommentSection {...{ workout, accessToken, user }} />
    </div>
  );
}

export default WorkoutForm;
