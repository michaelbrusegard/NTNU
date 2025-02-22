import React from "react";
import { styled } from "@mui/material/styles";
import { DemoContainer, DemoItem } from "@mui/x-date-pickers/internals/demo";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { LocalizationProvider } from "@mui/x-date-pickers/LocalizationProvider";
import { DateTimePicker } from "@mui/x-date-pickers/DateTimePicker";
import { Controller } from "react-hook-form";
import dayjs from "dayjs";

const StyledSpan = styled("span")({
  display: "flex",
  flexDirection: "column",
  alignItems: "flex-start",
});

function Label({ componentName }) {
  const content = (
    <StyledSpan>
      <strong>{componentName}</strong>
    </StyledSpan>
  );

  return content;
}

function MyDateTimeField(props) {
  const { label, name, control, isDisabled } = props;

  return (
    <LocalizationProvider dateAdapter={AdapterDayjs}>
      <DemoContainer
        components={[
          "DatePicker",
          "TimePicker",
          "DateTimePicker",
          "DateRangePicker",
          "DateTimeRangePicker",
        ]}
      >
        <DemoItem label={<Label componentName={label} />}>
          <Controller
            name={name}
            control={control}
            render={({ field: { onChange, value } }) => (
              <DateTimePicker
                value={value ? dayjs(value) : null}
                disabled={isDisabled}
                onChange={(newValue) => {
                  const formattedDate = newValue.format("YYYY-MM-DD HH:mm:ss");
                  onChange(formattedDate);
                }}
              />
            )}
          />
        </DemoItem>
      </DemoContainer>
    </LocalizationProvider>
  );
}

export default MyDateTimeField;
