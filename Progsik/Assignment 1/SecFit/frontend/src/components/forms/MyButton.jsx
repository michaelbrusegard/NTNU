import * as React from "react";
import Button from "@mui/material/Button";
import "../../assets/style/Forms.css";

function MyButton(props) {
  const { label, type, endIcon, onClick } = props;
  return (
    <Button
      type={type}
      variant="contained"
      className={"myButton"}
      endIcon={endIcon}
      onClick={onClick}
    >
      {label}
    </Button>
  );
}

export default MyButton;
