import React from "react";
import { TextField, FormControl, FormLabel } from "@mui/material";
import "../../assets/style/Forms.css";
import { Controller } from "react-hook-form";

function MyTextField(props) {
  const {
    label,
    name,
    control,
    value,
    defaultValue,
    isDisabled,
    type,
    placeholder = null,
  } = props;
  return (
    <Controller
      name={name}
      control={control}
      defaultValue={defaultValue}
      render={({ field, fieldState: { error } }) => (
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
            disabled={isDisabled}
            placeholder={placeholder}
            id={name}
            variant="outlined"
            {...field}
            value={value ?? field.value ?? ""}
            type={type}
            error={!!error}
            helperText={error?.message}
          />
        </FormControl>
      )}
    />
  );
}

export default MyTextField;
