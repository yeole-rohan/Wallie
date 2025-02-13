from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from . import models
class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    email = serializers.EmailField(source='user.email')
    full_name = serializers.CharField(source='user.get_full_name', read_only=True)

    def validate(self, attrs):
        data = super().validate(attrs)
        refresh = self.get_token(self.user)
        data['refresh'] = str(refresh)
        data['access'] = str(refresh.access_token)
        data['email'] = self.user.email
        data['full_name'] = self.user.get_full_name()
        data['mobile_number'] = self.user.mobile_number
        return data

    class Meta:
        model = models.User
        fields = ('email', 'full_name')

# Serializer for User model
class UserAccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.User
        # Fields to include in the serialized representation
        fields = ['email', 'password', 'first_name', 'last_name', 'mobile_number']
        # Extra keyword arguments for customization, e.g., write-only password field
        extra_kwargs = {'password': {'write_only': True}}
        

    def create(self, validated_data):
        # Custom create method to create a user using the custom manager
        user = models.User.objects.create_user(**validated_data)
        return user