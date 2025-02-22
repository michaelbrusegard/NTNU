import { useEffect, useState } from "react";
import { Box } from "@mui/material";
import { Link } from "react-router-dom";
import AxiosInstance from "../services/AxiosInstance";
import Button from "@mui/material/Button";
import * as React from "react";
import { Container, Stack } from "@mui/material";
import Paper from "@mui/material/Paper";
import { SessionService } from "../services/session";

function Exercises() {
  const [exercises, setExercises] = useState([]);
  const [errorMessage, setErrorMessage] = useState("");

  const accessToken = SessionService.getLocalAccessToken();

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
        setErrorMessage("Error loading exercises");
        console.error(error);
      });
  }, [accessToken]);

  return (
    <Container>
      <Stack>
        <h2 className="">View Exercises</h2>
        <p>
          Here you can view, create, and edit exercise types defined by you and
          other athletes.
        </p>
        <Box sx={{ flexGrow: 0, display: { xs: "none", md: "flex" } }}>
          <Link to="/exercisesForm" style={{ textDecoration: "none" }}>
            <Button variant="contained" sx={{ mr: 1 }}>
              Create new exercise
            </Button>
          </Link>
        </Box>
      </Stack>
      <Container>
        {exercises.map((exercise) => (
          <Link
            to={`/exercisesForm/${exercise.id}`}
            style={{ textDecoration: "none" }}
            key={exercise.id}
          >
            <Paper sx={{ textAlign: "start" }}>
              <h3>{exercise.name}</h3>
              <p>{exercise.description}</p>
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

export default Exercises;
