# Generated by Django 4.1.2 on 2022-10-13 14:55

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ("core", "0002_q_a_type"),
    ]

    operations = [
        migrations.RenameModel(old_name="Q_A_type", new_name="Q_A",),
    ]