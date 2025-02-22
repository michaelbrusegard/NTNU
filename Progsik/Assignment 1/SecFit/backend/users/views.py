from rest_framework import mixins, generics
from workouts.mixins import CreateListModelMixin
from rest_framework import permissions
from users.serializers import (
    UserSerializer,
    OfferSerializer,
    AthleteFileSerializer,
    UserPutSerializer,
    UserGetSerializer,
)
from rest_framework.permissions import (
    IsAuthenticatedOrReadOnly,
)

from .models import Offer, AthleteFile, User
from django.contrib.auth import get_user_model
from django.db import connection
from django.db.models import Q
from rest_framework.parsers import MultiPartParser, FormParser
from .permissions import IsCurrentUser, IsAthlete, IsCoach
from workouts.permissions import IsOwner, IsReadOnly
from rest_framework.response import Response
from rest_framework import status

class UserList(mixins.ListModelMixin, mixins.CreateModelMixin, generics.GenericAPIView):
    serializer_class = UserSerializer

    def get(self, request, *args, **kwargs):
        self.serializer_class = UserGetSerializer
        return self.list(request, *args, **kwargs)

    def post(self, request, *args, **kwargs):
        return self.create(request, *args, **kwargs)

    def get_queryset(self):
        qs = get_user_model().objects.all()

        if self.request.user:
            # Return the currently logged in user
            status = self.request.query_params.get("user", None)
            if status and status == "current":
                qs = get_user_model().objects.filter(pk=self.request.user.pk)

        return qs


class UserDetail(
    mixins.RetrieveModelMixin,
    mixins.UpdateModelMixin,
    mixins.DestroyModelMixin,
    generics.GenericAPIView,
):
    lookup_field_options = ["pk", "username"]
    serializer_class = UserSerializer
    queryset = get_user_model().objects.all()
    permission_classes = [permissions.IsAuthenticated &
                          (IsCurrentUser | IsReadOnly)]

    def get_object(self):
        for field in self.lookup_field_options:
            if field in self.kwargs:
                self.lookup_field = field
                break

        return super().get_object()

    def get(self, request, *args, **kwargs):
        pk = kwargs.get('pk')
        username = kwargs.get('username')

        if not pk and not username:
            return Response({'error': 'User ID or username not provided'}, status=400)

        if pk:
            instance = self.get_object()
            serializer = self.get_serializer(instance)
            return Response(serializer.data)


        query = f"SELECT * FROM users_user WHERE username = '{username}'"
        with connection.cursor() as cursor:
            cursor.execute(query)  # Executing the raw SQL query
            columns = [col[0] for col in cursor.description]
            rows = cursor.fetchall()

        if not rows:
            return Response({'error': 'User not found'}, status=404)

        instances = []
        for row in rows:
            if row:
                data = dict(zip(columns, row))
                instance = User(**data)
                instances.append(instance)

        if len(instances) == 1:
            serializer = self.get_serializer(
                instances[0], context={'request': request})
        else:
            serializer = self.get_serializer(
                instances, many=True, context={'request': request})

        return Response(serializer.data)

    def delete(self, request, *args, **kwargs):
        return self.destroy(request, *args, **kwargs)

    def put(self, request, *args, **kwargs):
        self.serializer_class = UserPutSerializer
        return self.update(request, *args, **kwargs)

    def patch(self, request, *args, **kwargs):
        return self.partial_update(request, *args, **kwargs)


class OfferList(
    mixins.ListModelMixin, mixins.CreateModelMixin, generics.GenericAPIView
):
    permission_classes = [IsAuthenticatedOrReadOnly]
    serializer_class = OfferSerializer

    def get(self, request, *args, **kwargs):
        return self.list(request, *args, **kwargs)

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)

    def get_queryset(self):
        qs = Offer.objects.none()

        if self.request.user:
            qs = Offer.objects.filter(
                Q(owner=self.request.user) | Q(recipient=self.request.user)
            ).distinct()

            # filtering by status (if provided)
            status = self.request.query_params.get("status", None)
            if status is not None:
                qs = qs.filter(status=status)
        return qs


class OfferDetail(
    mixins.RetrieveModelMixin,
    mixins.DestroyModelMixin,
    generics.GenericAPIView,
):
    permission_classes = [IsAuthenticatedOrReadOnly]
    queryset = Offer.objects.all()
    serializer_class = OfferSerializer

    def get(self, request, *args, **kwargs):
        return self.retrieve(request, *args, **kwargs)

    def put(self, request, *args, **kwargs):
        id = kwargs.get('pk')
        offer = Offer.objects.get(pk=id)

        try:
            offer.status = request.data.get('status')

            # Add the sender of the offer to the recipients list of athletes, and add the recipient to the senders coach list
            if offer.status == 'a':
                if not offer.recipient.isCoach:
                    return Response({'error': 'Recipient is not a coach'}, status=400)

                offer.recipient.athletes.add(offer.owner)
                offer.recipient.save()

                # Delete other pending offers from the same sender to the same recipient
                Offer.objects.filter(owner=offer.owner, recipient=offer.recipient, status='p').delete()

        except Exception as e:
            return Response({f'error: {e}'}, status=400)

        partial = kwargs.pop('partial', False)
        serializer = self.get_serializer(offer, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(serializer.data)

    def patch(self, request, *args, **kwargs):
        return self.partial_update(request, *args, **kwargs)

    def delete(self, request, *args, **kwargs):
        return self.destroy(request, *args, **kwargs)


class AthleteFileList(
    mixins.ListModelMixin,
    mixins.CreateModelMixin,
    CreateListModelMixin,
    generics.GenericAPIView,
):
    queryset = AthleteFile.objects.all()
    serializer_class = AthleteFileSerializer
    permission_classes = [permissions.IsAuthenticated & (IsAthlete | IsCoach)]
    parser_classes = [MultiPartParser, FormParser]

    def get(self, request, *args, **kwargs):
        return self.list(request, *args, **kwargs)

    def post(self, request, *args, **kwargs):
        return self.create(request, *args, **kwargs)

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)

    def get_queryset(self):
        user = self.request.user
        if user.isCoach:
            # Return files for athletes coached by this user
            return AthleteFile.objects.filter(athlete__coach=user)
        else:
            # Return files for the current athlete
            return AthleteFile.objects.filter(athlete=user)


class AthleteFileDetail(
    mixins.RetrieveModelMixin,
    mixins.UpdateModelMixin,
    mixins.DestroyModelMixin,
    generics.GenericAPIView,
):
    queryset = AthleteFile.objects.all()
    serializer_class = AthleteFileSerializer
    permission_classes = [permissions.IsAuthenticated & (IsAthlete | IsOwner)]

    def get(self, request, *args, **kwargs):
        return self.retrieve(request, *args, **kwargs)

    def delete(self, request, *args, **kwargs):
        return self.destroy(request, *args, **kwargs)
