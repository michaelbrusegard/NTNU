import { useEffect, useState } from "react";
import { Box } from "@mui/material";
import MyButton from "./forms/MyButton";
import { useForm } from "react-hook-form";
import AxiosInstance from "../services/AxiosInstance";
import Button from "@mui/material/Button";
import * as React from "react";
import { Container, Stack } from "@mui/material";
import Paper from "@mui/material/Paper";
import MyTextField from "./forms/MyTextField";
import GetAppIcon from "@mui/icons-material/GetApp";
import { SessionService } from "../services/session";

function Coach() {
  const { control, handleSubmit } = useForm();
  const [coaches, setCoaches] = useState([]);
  const [errorMessage, setErrorMessage] = useState("");
  const [successMessage, setSuccessMessage] = useState("");
  const [myCoach, setMyCoach] = useState([]);
  const [athleteFiles, setAthleteFiles] = useState([]);

  const userId = SessionService.getUserId();
  const accessToken = SessionService.getLocalAccessToken();

  useEffect(() => {
    AxiosInstance.get(`/api/users/${userId}/`, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    })
      .then((response) => {
        if (response.data.coach) {
          AxiosInstance.get(response.data.coach, {
            headers: {
              Authorization: `Bearer ${accessToken}`,
            },
          }).then((response) => {
            setMyCoach(response.data.username);
          });
          if (response.data.coach_files) {
            const myCoachFilesInstancesPromises = response.data.coach_files.map(
              (coachFileInstanceData) =>
                AxiosInstance.get(coachFileInstanceData, {
                  headers: {
                    Authorization: `Bearer ${accessToken}`,
                  },
                })
            );

            Promise.all(myCoachFilesInstancesPromises)
              .then((responses) => {
                setAthleteFiles(responses.map((response) => response.data));
              })
              .catch((error) => {
                console.error(error);
              });
          }
        }
      })
      .catch((error) => {
        setErrorMessage("Error loading user data");
        console.error(error);
      });
  }, [accessToken, userId]);

  //get coaches
  useEffect(() => {
    const fetchUsers = async () => {
      const usersSet = new Set();
      try {
        const response = await AxiosInstance.get(`api/users/`, {
          headers: {
            Authorization: `Bearer ${accessToken}`,
          },
        });
        response.data.forEach((user) => usersSet.add(JSON.stringify(user)));
      } catch (error) {
        console.error(error);
      }
      const uniqueUser = Array.from(usersSet).map((user) => JSON.parse(user));
      const coaches = uniqueUser.filter((user) => user.isCoach);
      setCoaches(coaches);
    };
    fetchUsers();
  }, [accessToken]);

  const onSubmit = (data) => {
    data.status = "p";
    AxiosInstance.get(`/api/users/${data.recipient}/`, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    })
      .then((response) => {
        data.recipient = response.data.url;

        if (!response.data.isCoach) {
          setErrorMessage("This user is not a coach");
          return;
        }
        AxiosInstance.post("/api/offers/", data, {
          headers: {
            Authorization: `Bearer ${accessToken}`,
          },
        })
          .then((response) => {
            setErrorMessage("");
            setSuccessMessage("Offer sent");
          })
          .catch((error) => {
            setErrorMessage("Error sending offer");
            console.error(error);
          });
      })
      .catch((error) => {
        setErrorMessage("A user with that username does not exist");
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
        <h2 className="">Coach & Files</h2>
        <p>
          On this page you can view/change your current coach as well as view
          the files your coaches (present and previous) have uploaded.
        </p>
        <h3>My coach</h3>
        {myCoach && <p>{myCoach}</p>}
        <h3>Files</h3>
        {athleteFiles && athleteFiles.length > 0 ? (
          athleteFiles.map((file) => (
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
                <p>Uploaded by : {file.owner}</p>
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
          ))
        ) : (
          <p>Your coach hasn't uploaded any files for you yet</p>
        )}
        <form onSubmit={handleSubmit(onSubmit)}>
          <Box className={"itemBox"}>
            <MyTextField
              label={"Send a coach offer"}
              name={"recipient"}
              control={control}
              placeholder={"Enter the username of the coach"}
            />
          </Box>
          <Box className={"itemBox"}>
            <MyButton label={"Send"} type={"submit"} />
          </Box>
        </form>
        {errorMessage && (
          <Box sx={{ color: "red", textAlign: "center" }}>{errorMessage}</Box>
        )}
        {successMessage && (
          <Box sx={{ color: "green", textAlign: "center" }}>
            {successMessage}
          </Box>
        )}
      </Stack>
      {coaches.map((user) => {
        return (
          <Paper key={user.id}>
            <Box>
              <h3>{user.username}</h3>
              <p>{user.specialism}</p>
            </Box>
          </Paper>
        );
      })}
    </Container>
  );
}

export default Coach;
