import os

class Config:
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL', 'sqlite:///schedule.db')
    print(f"Database URI: {SQLALCHEMY_DATABASE_URI}")  # Debug print
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    DEBUG = os.environ.get('DEBUG', 'False') == 'True'