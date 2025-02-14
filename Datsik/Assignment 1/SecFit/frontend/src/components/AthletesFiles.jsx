import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import AxiosInstance from "../services/AxiosInstance";
import Button from "@mui/material/Button";
import { Box, Container, Stack } from "@mui/material";
import Paper from "@mui/material/Paper";
import CloudUploadIcon from "@mui/icons-material/CloudUpload";
import GetAppIcon from "@mui/icons-material/GetApp";
import * as React from "react";
import dayjs from "dayjs";
import { SessionService } from "../services/session";

function AthletesFiles({ athleteId }) {
  const [athlete, setAthlete] = useState([]);
  const [athleteWorkouts, setAthleteWorkouts] = useState([]);
  const [athleteFiles, setAthleteFiles] = useState([]);
  const [uploadMonitor, setUploadMonitor] = useState([true]);
  const [errorMessage, setErrorMessage] = useState("");
  const [successMessage, setSuccessMessage] = useState("");

  const userId = SessionService.getUserId();
  const accessToken = SessionService.getLocalAccessToken();

  useEffect(() => {
    AxiosInstance.get(`api/users/${athleteId}`, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    })
      .then(async (response) => {
        const athlete = response.data;
        setAthlete(athlete);
        if (response.data.workouts) {
          const myWorkoutsInstances = await Promise.all(
            response.data.workouts.map(async (workoutInstanceData) => {
              try {
                const res = await AxiosInstance.get(workoutInstanceData, {
                  headers: {
                    Authorization: `Bearer ${accessToken}`,
                  },
                });
                return res;
              } catch (error) {
                // If workout is set to private, don't log error
                if (!error.response.status === 403) {
                  console.error(error);
                }
                return null; // Return null if the request fails
              }
            })
          );

          // Filter out null values
          const validWorkoutsInstances = myWorkoutsInstances.filter(
            (instance) => instance !== null
          );

          setAthleteWorkouts(validWorkoutsInstances.map((res) => res.data));
        }
      })
      .catch((error) => {
        setErrorMessage("Error loading user data");
        console.error(error);
      });
  }, [accessToken, athleteId]);

  useEffect(() => {
    AxiosInstance.get(`api/athlete-files/`, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    })
      .then((response) => {
        const files = response.data;
        if (athlete) {
          const athleteFiles = files.filter(
            (file) => file.athlete === athlete.url
          );
          setAthleteFiles(athleteFiles);
        }
      })
      .catch((error) => {
        setErrorMessage("Error fetching athlete files");
        console.error("Error fetching data:", error);
      });
  }, [athlete, accessToken, uploadMonitor]);

  const handleFileUpload = (event) => {
    const file = event.target.files[0];
    const formData = new FormData();
    formData.append("file", file);
    formData.append("athlete", `/api/users/${athleteId}/`);
    formData.append("owner", userId);

    AxiosInstance.post("/api/athlete-files/", formData, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
        "Content-Type": "multipart/form-data",
      },
    })
      .then((response) => {
        setErrorMessage("");
        setSuccessMessage("File uploaded successfully");
        setUploadMonitor(!uploadMonitor);
      })
      .catch((error) => {
        setErrorMessage("Error uploading file");
      });
  };
  const handleFileDownload = (fileUrl) => {
    fetch(fileUrl)
      .then((response) => response.blob())
      .then((blob) => {
        const url = window.URL.createObjectURL(blob);
        const link = document.createElement("a");
        link.href = url;
        link.setAttribute("download", fileUrl.split("/").pop());
        document.body.appendChild(link);
        link.click();
        link.parentNode.removeChild(link);
      });
  };

  return (
    <Container>
      <Stack>
        <h2 className="" style={{ textAlign: "left" }}>
          {athlete.username} profile
        </h2>
        <p>On this page you can view/upload files for your athletes.</p>
        <h3>Workouts</h3>
        {athleteWorkouts && athleteWorkouts.length > 0 ? (
          athleteWorkouts.map((workout) => (
            <Link
              key={workout.id}
              to={`/workoutForm/${workout.id}`}
              style={{ textDecoration: "none" }}
            >
              <Paper sx={{ textAlign: "start" }}>
                <h3>{workout.name}</h3>
                <ul>
                  <li>
                    Date: {dayjs(workout.date).utc().format("YYYY-MM-DD")}
                  </li>
                  <li>Time: {dayjs(workout.date).utc().format("HH:mm:ss")}</li>
                  <li>Owner: {workout.owner_username}</li>
                  <li>Exercises: {workout.exercise_instances.length}</li>
                </ul>
              </Paper>
            </Link>
          ))
        ) : (
          <p>No workouts found.</p>
        )}
        <h3>Files</h3>
        {athleteFiles.map((file) => (
          <Paper
            key={file.id}
            sx={{
              alignItems: "flex-start",
              display: "flex",
              justifyContent: "space-between",
            }}
          >
            <Box sx={{ textAlign: "start" }}>
              <h3>{file.file.split("/").pop()}</h3>
              <p>Owner : {file.owner}</p>
            </Box>
            <Button
              variant="contained"
              startIcon={<GetAppIcon />}
              sx={{ alignSelf: "flex-end", margin: 1 }}
              onClick={() => handleFileDownload(file.file)}
            >
              Download
            </Button>
          </Paper>
        ))}
        <Button
          component="label"
          variant="contained"
          tabIndex={-1}
          startIcon={<CloudUploadIcon />}
        >
          Upload file (PDF, image file)
          <input
            type="file"
            style={{ display: "none" }}
            onChange={handleFileUpload}
          />
        </Button>
        {errorMessage && (
          <Box sx={{ color: "red", textAlign: "center" }}>{errorMessage}</Box>
        )}
        {successMessage && (
          <Box sx={{ color: "green", textAlign: "center" }}>
            {successMessage}
          </Box>
        )}
      </Stack>
    </Container>
  );
}

export default AthletesFiles;
