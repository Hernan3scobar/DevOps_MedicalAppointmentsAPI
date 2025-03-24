import os

class Config:
    # Database configuration: uses DATABASE_URL environment variable if set, otherwise defaults to SQLite
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL', 'sqlite:///schedule.db')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
