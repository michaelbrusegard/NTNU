from django.urls import path, include
from . import views
from rest_framework_simplejwt.views import TokenRefreshView, TokenVerifyView, TokenObtainPairView, TokenBlacklistView

urlpatterns = [
    path("api/users/", views.UserList.as_view(), name="user-list"),
    path("api/users/<int:pk>/", views.UserDetail.as_view(), name="user-detail"),
    path("api/users/<str:username>/", views.UserDetail.as_view(), name="user-detail"),
    path("api/offers/", views.OfferList.as_view(), name="offer-list"),
    path("api/offers/<int:pk>/", views.OfferDetail.as_view(), name="offer-detail"),
    path(
        "api/athlete-files/", views.AthleteFileList.as_view(), name="athlete-file-list"
    ),
    path(
        "api/athlete-files/<int:pk>/",
        views.AthleteFileDetail.as_view(),
        name="athletefile-detail",
    ),
    path("api/auth/", include("rest_framework.urls")),
    path('api/token/verify/', TokenVerifyView.as_view(), name='token_verify'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path("api/token/", TokenObtainPairView.as_view(), name="token_obtain_pair"),
    path("api/logout/", TokenBlacklistView.as_view(), name="token_blacklist")
]
