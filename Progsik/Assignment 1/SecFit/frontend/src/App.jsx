import { BrowserRouter as Router } from "react-router-dom";
import "./App.css";
import { Routes, Route, Navigate } from "react-router-dom";
import Home from "./components/Home";
import LoginForm from "./components/LoginForm";
import SignupForm from "./components/SignupForm";
import Exercises from "./components/Exercises";

import Navbar from "./components/Navbar";
import { AuthProvider } from "./components/AuthContext";
import ExercisesForm from "./components/ExercisesForm";
import Workouts from "./components/Workouts";
import Coach from "./components/Coach";
import WorkoutForm from "./components/WorkoutForm";
import Athletes from "./components/Athletes";
import AthletesFiles from "./components/AthletesFiles";

import { useParams } from "react-router-dom";
import { ProtectedRoute } from "./components/ProtectedRoute";

function ExercisesFormRoute() {
  const { id } = useParams();
  return <ExercisesForm exerciseId={id} />;
}
function WorkoutFormRoute() {
  const { id } = useParams();
  return <WorkoutForm workoutId={id} />;
}

function AthletesFilesRoute() {
  const { id } = useParams();
  return <AthletesFiles athleteId={id} />;
}
function App() {
  return (
    <AuthProvider>
      <Router>
        <Navbar />
        <div className="App">
          <Routes>
            <Route path="/" element={<Navigate to="/home" replace />} />
            <Route path="/home" element={<Home />} />
            <Route element={<ProtectedRoute />}>
              <Route path="/exercises" element={<Exercises />} />
              <Route path="/exercisesForm" element={<ExercisesForm />} />
              <Route
                path="/exercisesForm/:id"
                element={<ExercisesFormRoute />}
              />
              <Route path="/workouts" element={<Workouts />} />
              <Route path="/workoutForm" element={<WorkoutForm />} />
              <Route path="/workoutForm/:id" element={<WorkoutFormRoute />} />
              <Route path="/coach" element={<Coach />} />
              <Route path="/coach" element={<Coach />} />
            </Route>
            <Route path="/athletes" element={<Athletes />} />
            <Route path="/athletes/:id" element={<AthletesFilesRoute />} />
            <Route path="/login" element={<LoginForm />} />
            <Route path="/signup" element={<SignupForm />} />
          </Routes>
        </div>
      </Router>
    </AuthProvider>
  );
}

export default App;
