from flask import Blueprint, render_template

bp_landing = Blueprint('landing', __name__, template_folder='templates')

@bp_landing.route('/api')
def home():
    return render_template('index.html')
