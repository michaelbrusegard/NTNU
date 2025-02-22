import * as React from "react";
import { useContext } from "react";
import { Link } from "react-router-dom";
import { AuthContext } from "./AuthContext";
import AppBar from "@mui/material/AppBar";
import Box from "@mui/material/Box";
import Toolbar from "@mui/material/Toolbar";
import IconButton from "@mui/material/IconButton";
import Typography from "@mui/material/Typography";
import Menu from "@mui/material/Menu";
import MenuIcon from "@mui/icons-material/Menu";
import Container from "@mui/material/Container";
import Button from "@mui/material/Button";
import { SessionService } from "../services/session";

function Navbar() {
  const [anchorElNav, setAnchorElNav] = React.useState(null);
  const handleOpenNavMenu = (event) => {
    setAnchorElNav(event.currentTarget);
  };

  const handleCloseNavMenu = () => {
    setAnchorElNav(null);
  };
  const { isAuthenticated, logout } = useContext(AuthContext);
  const isCoach = SessionService.getIsCoach();

  const pages =
    isAuthenticated && isCoach
      ? ["Home", "Workouts", "Exercises", "Athletes"]
      : isAuthenticated && !isCoach
      ? ["Home", "Workouts", "Exercises", "Coach"]
      : ["Home"];

  const handleLogout = () => {
    logout();
  };

  return (
    <AppBar position="sticky" sx={{ backgroundColor: "white" }}>
      <Container maxWidth="xl">
        <Toolbar disableGutters>
          <Typography
            variant="h6"
            noWrap
            component="a"
            href="/home"
            sx={{
              mr: 2,
              display: { xs: "none", md: "flex" },
              fontFamily: "monospace",
              fontWeight: 700,
              letterSpacing: ".3rem",
              color: "black",
              textDecoration: "none",
            }}
          >
            Secfit
          </Typography>

          <Box sx={{ flexGrow: 1, display: { xs: "flex", md: "none" } }}>
            <IconButton
              size="large"
              aria-label="account of current user"
              aria-controls="menu-appbar"
              aria-haspopup="true"
              onClick={handleOpenNavMenu}
              color="black"
            >
              <MenuIcon />
            </IconButton>
            <Menu
              id="menu-appbar"
              anchorEl={anchorElNav}
              anchorOrigin={{
                vertical: "bottom",
                horizontal: "left",
              }}
              keepMounted
              transformOrigin={{
                vertical: "top",
                horizontal: "left",
              }}
              open={Boolean(anchorElNav)}
              onClose={handleCloseNavMenu}
              sx={{
                display: { xs: "block", md: "none" },
              }}
            >
              {pages.map((page) => (
                <Link
                  to={`/${page.toLowerCase()}`}
                  key={page}
                  style={{ textDecoration: "none" }}
                >
                  <Button
                    onClick={handleCloseNavMenu}
                    sx={{ my: 2, color: "black", display: "block" }}
                  >
                    {page}
                  </Button>
                </Link>
              ))}
            </Menu>
          </Box>

          <Box sx={{ flexGrow: 1, display: { xs: "none", md: "flex" } }}>
            {pages.map((page) => (
              <Link
                to={`/${page.toLowerCase()}`}
                key={page}
                style={{ textDecoration: "none" }}
              >
                <Button
                  onClick={handleCloseNavMenu}
                  sx={{ my: 2, color: "black", display: "block" }}
                >
                  {page}
                </Button>
              </Link>
            ))}
          </Box>

          <Box
            sx={{
              flexGrow: 0,
              display: { xs: "none", md: "flex" },
              justifyContent: "center",
              alignItems: "center",
            }}
          >
            {isAuthenticated ? (
              <>
                <Typography variant="body1" sx={{ mr: 1, color: "black" }}>
                  Welcome, {SessionService.getUserName()}
                </Typography>
                <Link to="/home" style={{ textDecoration: "none" }}>
                  <Button variant="contained" onClick={handleLogout}>
                    Log out
                  </Button>
                </Link>
              </>
            ) : (
              <>
                <Link to="/signup" style={{ textDecoration: "none" }}>
                  <Button variant="contained" sx={{ mr: 1 }}>
                    Sign Up
                  </Button>
                </Link>
                <Link to="/login" style={{ textDecoration: "none" }}>
                  <Button variant="contained" sx={{ backgroundColor: "grey" }}>
                    Log in
                  </Button>
                </Link>
              </>
            )}
          </Box>
        </Toolbar>
      </Container>
    </AppBar>
  );
}
export default Navbar;
