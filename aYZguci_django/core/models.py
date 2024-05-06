from email.policy import default
from django.db import models

# Create your models here.
class Question_Answer_DataBase(models.Model):
    data = models.JSONField(default=dict)
class Q_A(models.Model):
    data = models.JSONField(default=dict)

class S_M( models.Model):
    data = models.JSONField(default=dict)
