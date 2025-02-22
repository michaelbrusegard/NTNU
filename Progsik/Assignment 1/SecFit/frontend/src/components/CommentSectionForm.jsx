import { Box } from "@mui/material";
import { useState, useEffect } from "react";
import MyTextField from "./forms/MyTextField";
import MyButton from "./forms/MyButton";
import { useForm } from "react-hook-form";
import { IconButton } from "@mui/material";
import DeleteIcon from "@mui/icons-material/Delete";
import Paper from "@mui/material/Paper";
import AxiosInstance from "../services/AxiosInstance";

function CommentSectionForm({ workout, accessToken, user }) {
  const [comments, setComments] = useState([]);
  const [errorMessage, setErrorMessage] = useState("");

  useEffect(() => {
    AxiosInstance.get("api/comments/", {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    }).then((res) => {
      const workoutComments = res.data.filter(
        (comment) => comment.workout === workout.url
      );
      setComments(workoutComments);
    });
  }, [accessToken, workout]);

  const {
    control: commentControl,
    handleSubmit: handleCommentSubmit,
    reset: resetComment,
  } = useForm();

  const addComment = (data) => {
    if (!data.comment) {
      setErrorMessage("Comment cannot be empty");
      return;
    }

    AxiosInstance.post(
      "api/comments/",
      {
        content: data.comment,
        workout: workout.url,
      },
      {
        headers: {
          Authorization: `Bearer ${accessToken}`,
        },
      }
    ).then((res) => {
      resetComment({ comment: "" });
      setErrorMessage("");
      const newComments = [...comments, res.data];
      setComments(newComments);
    });
  };

  const handleDeleteComment = (commentId) => {
    AxiosInstance.delete(`api/comments/${commentId}/`, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    }).then(() => {
      const newComments = comments.filter(
        (comment) => comment.id !== commentId
      );
      setComments(newComments);
    });
  };

  function getTimeSincePosted(postDate) {
    const now = new Date();
    const posted = new Date(postDate);
    const diffInSeconds = Math.floor((now - posted) / 1000);

    if (diffInSeconds < 60) {
      const unit = diffInSeconds === 1 ? "second" : "seconds";
      return `${diffInSeconds} ${unit} ago`;
    }

    const diffInMinutes = Math.floor(diffInSeconds / 60);
    if (diffInMinutes < 60) {
      const unit = diffInMinutes === 1 ? "minute" : "minutes";
      return `${diffInMinutes} ${unit} ago`;
    }

    const diffInHours = Math.floor(diffInMinutes / 60);
    if (diffInHours < 24) {
      const unit = diffInHours === 1 ? "hour" : "hours";
      return `${diffInHours} ${unit} ago`;
    }

    const diffInDays = Math.floor(diffInHours / 24);
    if (diffInDays < 7) {
      const unit = diffInDays === 1 ? "day" : "days";
      return `${diffInDays} ${unit} ago`;
    }

    const diffInWeeks = Math.floor(diffInDays / 7);
    if (diffInWeeks < 4) {
      const unit = diffInWeeks === 1 ? "week" : "weeks";
      return `${diffInWeeks} ${unit} ago`;
    }

    const diffInMonths = Math.floor(diffInDays / 30);
    if (diffInMonths < 12) {
      const unit = diffInMonths === 1 ? "month" : "months";
      return `${diffInMonths} ${unit} ago`;
    }

    const diffInYears = Math.floor(diffInDays / 365);
    const unit = diffInYears === 1 ? "year" : "years";
    return `${diffInYears} ${unit} ago`;
  }

  return (
    <form onSubmit={handleCommentSubmit(addComment)}>
      <Box>
        <h2>Comments</h2>
        {comments.length > 0 ? (
          comments.map((comment) => (
            <Paper sx={{ textAlign: "start" }} key={comment.id}>
              <div style={{ display: "flex" }}>
                <h3>{comment.owner}</h3>
                {comment.owner === user.username && (
                  <IconButton
                    sx={{ marginLeft: "auto" }}
                    type="button"
                    onClick={() => handleDeleteComment(comment.id)}
                    aria-label="delete"
                  >
                    <DeleteIcon />
                  </IconButton>
                )}
              </div>
              <p dangerouslySetInnerHTML={{ __html: comment.content }}></p>
              <p>{getTimeSincePosted(comment.timestamp)}</p>
            </Paper>
          ))
        ) : (
          <p>This workout doesn't have any comments yet</p>
        )}
      </Box>
      <Box>
        <MyTextField
          label="Comment"
          name="comment"
          placeholder="Write a comment"
          type="string"
          control={commentControl}
        ></MyTextField>
        {errorMessage && (
          <Box sx={{ color: "red", textAlign: "center" }}>{errorMessage}</Box>
        )}
        <MyButton label="Reply" type="submit" />
      </Box>
    </form>
  );
}

export default CommentSectionForm;
