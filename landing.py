from flask import Blueprint, render_template

bp_landing = Blueprint('landing', __name__, template_folder='templates')

@bp_landing.route('/')
def landing():
    return "✅ API is running. Visit /api for the web view or /api/schedules for data."

@bp_landing.route('/api')
def home():
    return render_template('index.html')
