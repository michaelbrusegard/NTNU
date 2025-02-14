import React from "react";
import { FormControl, FormLabel, Select, MenuItem } from "@mui/material";
import "../../assets/style/Forms.css";
import { Controller } from "react-hook-form";

function MySelectField(props) {
  const { label, name, control, isDisabled, items } = props;
  return (
    <Controller
      name={name}
      control={control}
      defaultValue={items[0].value}
      render={({ field: { onChange, value } }) => (
        <FormControl fullWidth variant="outlined">
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
          <Select
            labelId={`${name}-label`}
            id={name}
            value={value}
            disabled={isDisabled}
            onChange={onChange}
          >
            {items.map((item) => (
              <MenuItem key={item.value} value={item.value}>
                {item.label}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
      )}
    />
  );
}

export default MySelectField;
