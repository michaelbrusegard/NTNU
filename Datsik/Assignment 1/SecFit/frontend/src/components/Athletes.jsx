import { useEffect, useState } from "react";
import ButtonGroup from "@mui/material/ButtonGroup";
import IconButton from "@mui/material/IconButton";
import VisibilityIcon from "@mui/icons-material/Visibility";
import { Link } from "react-router-dom";
import AxiosInstance from "../services/AxiosInstance";
import Button from "@mui/material/Button";
import * as React from "react";
import { Container, Stack, Box } from "@mui/material";
import Paper from "@mui/material/Paper";
import Typography from "@mui/material/Typography";
import { SessionService } from "../services/session";

function Athletes() {
  const [myOffers, setMyOffers] = useState([]);
  const [errorMessage, setErrorMessage] = useState("");
  const [successMessage, setSuccessMessage] = useState("");
  const [myAthletes, setMyAthletes] = useState([]);

  const userId = SessionService.getUserId();
  const accessToken = SessionService.getLocalAccessToken();

  useEffect(() => {
    AxiosInstance.get("/api/offers/", {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    })
      .then((response) => {
        setMyOffers(response.data);
      })
      .catch((error) => {
        setErrorMessage("Error loading offers");
        console.error(error);
      });
  }, [accessToken]);

  useEffect(() => {
    AxiosInstance.get(`/api/users/${userId}/`, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    })
      .then((response) => {
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

  const handleRespond = (data, status) => {
    data.status = status;
    AxiosInstance.put(`/api/offers/${data.id}/`, data, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    })
      .then(() => {
        if (status === "a") {
          setSuccessMessage("Offer accepted");
        } else {
          setSuccessMessage("Offer declined");
        }
        window.location.reload();
      })
      .catch((error) => {
        setErrorMessage("Error responding to offer");
      });
  };

  return (
    <Container>
      <Stack>
        <h2 className="">Athletes & Offers</h2>
        <p>On this page you can view/change your roster of athletes.</p>
        <h3>Your athletes</h3>
        <Container>
          {myAthletes.map((athlete) => (
            <div key={athlete.id}>
              <Paper
                sx={{
                  alignItems: "flex-start",
                  display: "flex",
                  justifyContent: "space-between",
                  margin: 2,
                }}
              >
                <Typography sx={{ margin: 1 }}>{athlete.username}</Typography>
                <Link
                  to={`/athletes/${athlete.id}`}
                  sx={{ alignSelf: "flex-end", textDecoration: "none" }}
                >
                  <IconButton aria-label="delete">
                    <VisibilityIcon />
                  </IconButton>
                </Link>
              </Paper>
            </div>
          ))}
        </Container>
      </Stack>
      <h3>Offers</h3>
      <Container>
        {myOffers.map(
          (offer) =>
            offer.status === "p" && (
              <Paper key={offer.id} sx={{ margin: 2 }}>
                {offer.owner} wants you as a coach
                <ButtonGroup
                  disableElevation
                  variant="contained"
                  aria-label="Disabled button group"
                  sx={{ marginLeft: 1 }}
                >
                  <Button
                    onClick={() => handleRespond(offer, "a")}
                    sx={{ backgroundColor: "green" }}
                  >
                    Accept
                  </Button>
                  <Button
                    onClick={() => handleRespond(offer, "d")}
                    sx={{ backgroundColor: "red" }}
                  >
                    Decline
                  </Button>
                </ButtonGroup>
              </Paper>
            )
        )}
      </Container>
      {errorMessage && (
        <Box sx={{ color: "red", textAlign: "center" }}>{errorMessage}</Box>
      )}
      {successMessage && (
        <Box sx={{ color: "green", textAlign: "center" }}>{successMessage}</Box>
      )}
    </Container>
  );
}

export default Athletes;
