from rest_framework import permissions
from django.contrib.auth import get_user_model


class IsCurrentUser(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        return obj == request.user


class IsAthlete(permissions.BasePermission):
    def has_permission(self, request, view):
        if request.method == "POST":
            if request.data.get("athlete"):
                athlete_id = request.data["athlete"].split("/")[-2]
                return athlete_id == request.user.id
            return False

        return True

    def has_object_permission(self, request, view, obj):
        return request.user == obj.athlete


class IsCoach(permissions.BasePermission):
    def has_permission(self, request, view):
        if request.method == "POST":
            if request.data.get("athlete"):
                athlete_id = request.data["athlete"].split("/")[-2]
                athlete = get_user_model().objects.get(pk=athlete_id)
                return athlete.coach == request.user
            return False

        return True

    def has_object_permission(self, request, view, obj):
        return request.user == obj.athlete.coach


class IsRecipientOfOffer(permissions.BasePermission):
    """Checks whether the user is the recipient of the offer"""

    def has_permission(self, request, view):
        if request.method == "PUT":
            if request.data.get("recipient"):
                recipient_id = request.data["recipient"].split("/")[-2]
                recipient = get_user_model().objects.get(pk=recipient_id)
                if recipient:
                    return recipient == request.user
            return False

        return True
