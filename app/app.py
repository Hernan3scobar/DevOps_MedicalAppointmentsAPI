from flask import Flask
from flask_cors import CORS
from config import Config
from models import db
from routes import bp as api_bp
from landing import bp_landing
from dotenv import load_dotenv

def create_app():
    # Create a Flask instance and load configuration
    app = Flask(__name__)
    app.config.from_object(Config)

    # Initialize the database
    db.init_app(app)
    # Enable CORS for cross-origin requests
    CORS(app)

    app.url_map.strict_slashes = False

    load_dotenv() # Load environment

    # Register the API blueprint with the prefix /api
    app.register_blueprint(api_bp, url_prefix='/api')
    app.register_blueprint(bp_landing)

    with app.app_context():
        db.create_all()
    return app

if __name__ == '__main__':
    app = create_app()
    app.run(debug=True)
