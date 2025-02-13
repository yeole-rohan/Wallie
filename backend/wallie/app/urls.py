from django.urls import path, include
from rest_framework import routers
from rest_framework_simplejwt.views import (
    TokenRefreshView,
    TokenVerifyView
)
from django.conf.urls.static import static
router = routers.DefaultRouter()
from . import views
urlpatterns = [
   path('rest/', include(router.urls)),
   # Auth APIs
   path('api-auth/', include('rest_framework.urls', namespace='rest_framework')),
   path('api/token/', views.CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),
   path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
   path('api/token/verify/', TokenVerifyView.as_view(), name='token_verify'),

   # Company Doc URLs
   # path('terms-of-use/', views.TermsOfView.as_view(), name="terms_of_use"),
   # path('policy/', views.PolicyView.as_view(), name='policy'),

   # User APIs
   path('create-account/', views.CreateUserAccountView.as_view(), name='create_account'),
]