from django.urls import path, include
from . import views
from rest_framework.urlpatterns import format_suffix_patterns

urlpatterns = format_suffix_patterns(
    [
        path("", views.api_root),
        path("api/workouts/", views.WorkoutList.as_view(), name="workout-list"),
        path(
            "api/workouts/<int:pk>/",
            views.WorkoutDetail.as_view(),
            name="workout-detail",
        ),
        path("api/exercises/", views.ExerciseList.as_view(), name="exercise-list"),
        path(
            "api/exercises/<int:pk>/",
            views.ExerciseDetail.as_view(),
            name="exercise-detail",
        ),
        path(
            "api/exercise-instances/",
            views.ExerciseInstanceList.as_view(),
            name="exercise-instance-list",
        ),
        path(
            "api/exercise-instances/<int:pk>/",
            views.ExerciseInstanceDetail.as_view(),
            name="exerciseinstance-detail",
        ),
        path(
            "api/workout-files/",
            views.WorkoutFileList.as_view(),
            name="workout-file-list",
        ),
        path(
            "api/workout-files/<int:pk>/",
            views.WorkoutFileDetail.as_view(),
            name="workoutfile-detail",
        ),
        path("", include("users.urls")),
        path("", include("comments.urls")),
    ]
)
