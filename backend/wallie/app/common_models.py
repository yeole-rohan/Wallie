from django.db import models
from django.utils.translation import gettext_lazy as _

# Mixin to add timestamps to models
class Timestamp(models.Model):
    created = models.DateTimeField(auto_now_add=True)
    last_updated = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True  # This is an abstract base class