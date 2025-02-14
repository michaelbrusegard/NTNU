# SecFit Developer Guide

This document explains the general structure of the application, both the frontend and the backend, and explains how to run it for development.

## Technology

- **database** - sqlite3
- **backend** - Django 4 with Django REST framework
- **frontend** - React.js
- **authentication** - JSON Web Token (JWT)

---

## Code and structure

### Backend (Django)

The structure of the Django backend is as follows:

- **backend/**
  - **comments/** - Application handling user comments and reactions
  - **users/** - Application handling users and requests
  - **workouts/** - Application handling exercises and workouts
  - **secfit/** - The projects main module containing project-level settings.
  - **media/** - Directory for file uploads
  - **manage.py** - Entry point for running the project.
  - **requirements.txt** - Python requirements

### Frontend (React)

The structure of the React frontend is as follows:

- **frontend/**
  - **node_modules/** - Contains all the npm packages and dependencies.
  - **public/** - Contains static files
  - **src/**
    - **assets/**
      - **img/** - directory for image assets
      - **style/** - directory for CSS styles
    - **components/**
      - **Navbar.jsx** - Component for the header of the application
      - **Athletes.jsx** - Component for displaying information about athletes
      - **Home.jsx** - Component for the home page of the application
      - **Workouts.jsx** - Component for the workouts page
      - **Exercises.jsx** - Component for the exercises page
      - **LoginForm.jsx** - Component for the login form page
      - **SignupForm.jsx** - Component for the signup form page
      - **ExerciseForm.jsx** - Component for creating and editing exercises
      - **WorkoutForm.jsx** - Component for creating and editing workouts
      - **Coach.jsx** - Component for the Coach page to exchange file with coach
      - **AthletesFiles.jsx** - Component for coaches to exchange files with athletes
      - **AuthContext.jsx** - Context for managing authentication state
      - **AxiosInstance.jsx** - Axios instance configuration for making HTTP requests
      - **forms/** - Custom components
        - **MyButton.jsx** - Custom button component
        - **MyDateTimeField.jsx** - Custom datetime field component
        - **MyPassField.jsx** - Custom password field component
        - **MySelectField.jsx** - Custom select field component
        - **MyTextField.jsx** - Custom text field component
    - **App.jsx** - The main component of the React application
    - **index.js** - The entry point for the React application
    - **App.css** - Global styles for the application
    - **index.css** - Styles for the main HTML file
    - **package.json** - Contains the project's dependencies and scripts
    - **package-lock.json** - Lock file for the project's dependencies
    - **README.md** - Documentation for the frontend project

---

## Installing and running the project

Before you begin, ensure you have the following prerequisites installed:

- **Python and pip**: Make sure you have Python and pip installed. You can download Python from the [official website](https://www.python.org/).
- **Node.js and npm**: Make sure you have Node.js and npm installed. You can download Node.js from the [official website](https://nodejs.org/).

It's recommended to have a look at: [https://www.djangoproject.com/start/](https://www.djangoproject.com/start/)
Just as important is the Django REST guide: [https://www.django-rest-framework.org/](https://www.django-rest-framework.org/)

### Backend Setup

#### Creating a virtual environment

A virtual environment isolates project dependencies, preventing conflicts with system-wide packages and ensuring a consistent development environment.

Navigate into the backend folder `secfit/backend`, and create a virtual environment by running the following command:

```bash
python -m venv venv
```

#### Activate your virtual environment

To activate the virtual environment, run the following command:

```bash
source venv/bin/activate # On Windows, use `venv\Scripts\activate`
```

#### Install python requirements

```bash
pip install -r requirements.txt
```

#### Migrate database

Apply the database migrations:

```bash
python manage.py migrate
```

#### Create superuser

Create a local admin user:

```bash
python manage.py createsuperuser
```

Input the admin credentials as prompted. Only username and password is required

### Running the backend

To run the backend, use the following command:

```bash
python manage.py runserver
```

The instance will be running at [http://localhost:8000/](http://localhost:8000/) and code changes should update the running code automatically when saving.

#### Add initial data

You can add initial data by navigating to the admin interface at [http://localhost:8000/admin](http://localhost:8000/admin) and adding some categories.

### Set up the frontend app

#### Install dependencies

Navigate into the frontend folder `secfit/frontend` and run

```bash
npm install
```

### Running the frontend

In the same folder, run the following command to start the development server for the frontend

```bash
npm start
```

The frontend will now be running at [http://localhost:3000/](http://localhost:3000/) and code changes should update the running code automatically when saving.
