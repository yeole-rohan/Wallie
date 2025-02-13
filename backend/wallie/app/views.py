from django.shortcuts import render
from rest_framework_simplejwt.views import TokenObtainPairView
from . import serializers, models
from rest_framework import generics
class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = serializers.CustomTokenObtainPairSerializer


# View for creating a user account
class CreateUserAccountView(generics.CreateAPIView):
    queryset = models.User.objects.all()
    serializer_class = serializers.UserAccountSerializer