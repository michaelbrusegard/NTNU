import { useEffect, useState } from "react";
import { Box } from "@mui/material";
import { Link } from "react-router-dom";
import AxiosInstance from "../services/AxiosInstance";
import Button from "@mui/material/Button";
import * as React from "react";
import { Container, Stack } from "@mui/material";
import Paper from "@mui/material/Paper";
import ToggleButton from "@mui/material/ToggleButton";
import ToggleButtonGroup from "@mui/material/ToggleButtonGroup";
import dayjs from "dayjs";
import utc from "dayjs/plugin/utc";
import { SessionService } from "../services/session";

dayjs.extend(utc);

function Workouts() {
  const [workouts, setWorkouts] = useState([]);
  const [alignment, setAlignment] = useState("allWorkouts");
  const [errorMessage, setErrorMessage] = useState("");
  const [user, setUser] = useState(null);
  const [myAthletes, setMyAthletes] = useState([]);
  const [sortOption, setSortOption] = useState({
    option: "date",
    order: "desc",
  });

  const accessToken = SessionService.getLocalAccessToken();
  const userId = SessionService.getUserId();

  const handleChange = (event, newAlignment) => {
    setAlignment(newAlignment);
  };

  useEffect(() => {
    const fetchWorkouts = async () => {
      const workoutsSet = new Set();
      try {
        const response = await AxiosInstance.get("api/workouts/", {
          headers: {
            Authorization: `Bearer ${accessToken}`,
          },
        });
        response.data.forEach((workout) =>
          workoutsSet.add(JSON.stringify(workout))
        );
      } catch (error) {
        setErrorMessage("Error loading workouts");
        console.error(error);
      }
      const uniqueWorkouts = Array.from(workoutsSet).map((workout) =>
        JSON.parse(workout)
      );
      let workouts = [];
      if (alignment === "myWorkouts") {
        workouts = uniqueWorkouts.filter(
          (workout) => workout.owner_username === SessionService.getUserName()
        );
      } else if (alignment === "athleteWorkouts") {
        const athleteUsernames = myAthletes.map((athlete) => athlete.username);

        workouts = uniqueWorkouts.filter(
          (workout) =>
            athleteUsernames.includes(workout.owner_username) &&
            (workout.visibility === "CO" || workout.visibility === "PU")
        );
      } else {
        workouts = uniqueWorkouts;
      }

      setWorkouts(workouts);
    };
    fetchWorkouts();
  }, [accessToken, alignment, myAthletes]);

  useEffect(() => {
    AxiosInstance.get(`/api/users/${userId}/`, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    })
      .then((response) => {
        setUser(response.data);
        if (response.data.athletes) {
          const myAthletesInstancesPromises = response.data.athletes.map(
            (athleteInstanceData) =>
              AxiosInstance.get(athleteInstanceData, {
                headers: {
                  Authorization: `Bearer ${accessToken}`,
                },
              })
          );
          Promise.all(myAthletesInstancesPromises)
            .then((responses) => {
              setMyAthletes(responses.map((response) => response.data));
            })
            .catch((error) => {
              setErrorMessage("Error loading athletes");
              console.error(error);
            });
        }
      })
      .catch((error) => {
        setErrorMessage("Error loading user data");
        console.error(error);
      });
  }, [accessToken, userId]);

  let sortedWorkouts = [...workouts];

  if (sortOption.option === "date") {
    sortedWorkouts.sort((a, b) => {
      if (sortOption.order === "desc") {
        return new Date(b.date) - new Date(a.date);
      } else {
        return new Date(a.date) - new Date(b.date);
      }
    });
  } else if (sortOption.option === "owner") {
    sortedWorkouts.sort((a, b) => {
      if (sortOption.order === "desc") {
        return b.owner_username.localeCompare(a.owner_username);
      } else {
        return a.owner_username.localeCompare(b.owner_username);
      }
    });
  } else if (sortOption.option === "name") {
    sortedWorkouts.sort((a, b) => {
      if (sortOption.order === "desc") {
        return b.name.localeCompare(a.name);
      } else {
        return a.name.localeCompare(b.name);
      }
    });
  }

  return (
    <Container>
      <Stack>
        <h2 className="">View Workouts</h2>
        <p>
          Here you can view workouts completed by you, your athletes, or the
          public. Click on a workout to view its details.
        </p>
        <Box>
          <Link to="/workoutForm" style={{ textDecoration: "none" }}>
            <Button
              variant="contained"
              sx={{ mr: 1, backgroundColor: "green" }}
            >
              Log new workout
            </Button>
          </Link>
        </Box>
        <Box style={{ margin: "0.5vw" }}>
          <ToggleButtonGroup
            color="primary"
            value={alignment}
            exclusive
            onChange={handleChange}
            aria-label="Platform"
          >
            <ToggleButton value="allWorkouts">All workouts</ToggleButton>
            <ToggleButton value="myWorkouts">My workouts</ToggleButton>
            {user && user.isCoach && (
              <ToggleButton value="athleteWorkouts">
                Athlete workouts
              </ToggleButton>
            )}
          </ToggleButtonGroup>
        </Box>
        <Box>
          <p>
            Sort by:
            <Button
              onClick={() =>
                setSortOption({
                  option: "date",
                  order: sortOption.order === "desc" ? "asc" : "desc",
                })
              }
            >
              Date
            </Button>
            <Button
              onClick={() =>
                setSortOption({
                  option: "owner",
                  order: sortOption.order === "desc" ? "asc" : "desc",
                })
              }
            >
              Owner
            </Button>
            <Button
              onClick={() =>
                setSortOption({
                  option: "name",
                  order: sortOption.order === "desc" ? "asc" : "desc",
                })
              }
            >
              Name
            </Button>
          </p>
          <p>
            Currently sorting by: {sortOption.option} (
            {sortOption.order === "desc" ? "Descending" : "Ascending"})
          </p>
        </Box>
      </Stack>
      <Container>
        {sortedWorkouts.map((workout) => (
          <Link
            to={`/workoutForm/${workout.id}`}
            style={{ textDecoration: "none" }}
            key={workout.id}
          >
            <Paper sx={{ textAlign: "start" }}>
              <h3>{workout.name}</h3>
              <ul>
                <li>Date: {dayjs(workout.date).utc().format("YYYY-MM-DD")}</li>
                <li>Time: {dayjs(workout.date).utc().format("HH:mm:ss")}</li>
                <li>Owner: {workout.owner_username}</li>
                <li>Exercises: {workout.exercise_instances.length}</li>
              </ul>
            </Paper>
          </Link>
        ))}
      </Container>
      {errorMessage && (
        <Box sx={{ color: "red", textAlign: "center" }}>{errorMessage}</Box>
      )}
    </Container>
  );
}

export default Workouts;
