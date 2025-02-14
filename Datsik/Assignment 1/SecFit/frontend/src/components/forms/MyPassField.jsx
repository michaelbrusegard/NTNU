import React, { useState } from "react";
import {
  FormLabel,
  FormControl,
  IconButton,
  InputAdornment,
  TextField,
} from "@mui/material";
import VisibilityOff from "@mui/icons-material/VisibilityOff";
import Visibility from "@mui/icons-material/Visibility";
import "../../assets/style/Forms.css";
import { Controller } from "react-hook-form";
import { FormHelperText } from "@mui/material";

function MyPassField(props) {
  const { label, name, control } = props;
  const [showPassword, setShowPassword] = useState(false);

  const handleClickShowPassword = () => setShowPassword((show) => !show);

  const handleMouseDownPassword = (event) => {
    event.preventDefault();
  };
  return (
    <Controller
      name={name}
      control={control}
      render={({ field: { onChange, value }, fieldState: { error } }) => (
        <FormControl fullWidth variant="standard">
          <FormLabel
            htmlFor={name}
            sx={{
              display: "flex",
              flexDirection: "column",
              alignItems: "flex-start",
            }}
          >
            {label}
          </FormLabel>
          <TextField
            fullWidth
            id="input-with-sx"
            variant="outlined"
            margin="dense"
            type={showPassword ? "text" : "password"}
            InputProps={{
              endAdornment: (
                <InputAdornment position="end">
                  <IconButton
                    aria-label="toggle password visibility"
                    onClick={handleClickShowPassword}
                    onMouseDown={handleMouseDownPassword}
                    edge="end"
                  >
                    {showPassword ? <VisibilityOff /> : <Visibility />}
                  </IconButton>
                </InputAdornment>
              ),
            }}
            onChange={onChange}
            value={value ?? ""}
            error={!!error}
          />
          <FormHelperText sx={{ color: "#d32f2f" }}>
            {error?.message}
          </FormHelperText>
        </FormControl>
      )}
    />
  );
}
export default MyPassField;
