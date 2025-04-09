from flask import Flask
from flask_cors import CORS
from config import Config
from models import db
from routes import bp as api_bp
from landing import bp_landing
from dotenv import load_dotenv
from mysql.connector.errors import DatabaseError as MySQLDatabaseError
from sqlalchemy.exc import OperationalError, SQLAlchemyError

def create_app():
    # Create a Flask instance and load configuration
    app = Flask(__name__)
    app.config.from_object(Config)

    # Enable CORS for cross-origin requests
    CORS(app)

    # Load environment variables from .env file
    load_dotenv()

    # Initialize db with current configuration
    db.init_app(app)

    # Test the database connection
    try:
        with app.app_context():
            db.engine.connect()  # Attempt connection to MySQL
            print("Database connection successful!")
    except (OperationalError, MySQLDatabaseError, SQLAlchemyError) as e:
        # If connection fails, fall back to SQLite
        print(f"Error connecting to MySQL: {e}")
        print("Falling back to default SQLite database.")
        app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///schedule.db'
        # Reinitialize db with the new SQLite URI
        db.init_app(app)

    app.url_map.strict_slashes = False

    # Register blueprints
    app.register_blueprint(api_bp, url_prefix='/api')
    app.register_blueprint(bp_landing)

    # Create tables within app context
    with app.app_context():
        db.create_all()

    return app

if __name__ == '__main__':
    app = create_app()
    app.run(debug=True)
