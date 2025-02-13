from django.db import models
from django.contrib.auth.hashers import make_password
from django.utils.translation import gettext_lazy as _
from django.contrib.auth.models import AbstractUser
from typing import Any
from .common_models import Timestamp
from django.conf import settings
# Local Imports
from .managers import UserManager

class User(AbstractUser):
   username = None
   email = models.EmailField(unique=True, null=True, db_index=True)
   mobile_number = models.CharField(_("User Mobile Number"), max_length=15, default="1234567890")
   REQUIRED_FIELDS = []
   USERNAME_FIELD = 'email'

   objects = UserManager()
   class Meta:
      verbose_name = _("User")
      verbose_name_plural = _("Users")

   def __str__(self):
      return self.email

   def save(self, *args: Any, **kwargs: Any) -> None:
    """Hash user password if not already."""
    if self.password is not None and not self.password.startswith(
        ("pbkdf2_sha256$", "bcrypt$", "argon2")
    ):
        # If the password is plaintext, identify_hasher returns None
        self.password = make_password(self.password)
    super().save(*args, **kwargs)
