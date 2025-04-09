from flask import Blueprint, request, jsonify
from models import db, Schedule
from utils import get_message, validate_hour
from datetime import datetime

bp = Blueprint('api', __name__)

def get_lang():
    # Get the language from the Accept-Language header; default is Spanish ('es')
    lang = request.headers.get('Accept-Language', 'es')
    return lang.lower() if lang.lower() in ['es', 'en'] else 'es'

@bp.route('/schedules', methods=['POST'])
def create_schedule():
    lang = get_lang()
    data = request.get_json()
    date_str = data.get('date')
    hour_str = data.get('hour')
    shared = data.get('shared', False)

    try:
        date_obj = datetime.strptime(date_str, '%Y-%m-%d').date()
    except (ValueError, TypeError):
        return jsonify({'error': get_message('invalid_date_format', lang)}), 400

    is_valid, hour_obj, error_key = validate_hour(hour_str, lang)
    if not is_valid:
        return jsonify({'error': get_message(error_key, lang)}), 400

    new_schedule = Schedule(date=date_obj, hour=hour_obj, shared=shared)
    db.session.add(new_schedule)
    db.session.commit()
    return jsonify(new_schedule.to_dict()), 201

@bp.route('/schedules', methods=['GET'])
def get_schedules():
    schedules = Schedule.query.all()
    return jsonify([schedule.to_dict() for schedule in schedules]), 200

@bp.route('/schedules/<int:schedule_id>', methods=['GET'])
def get_schedule(schedule_id):
    lang = get_lang()
    schedule = Schedule.query.get(schedule_id)
    if schedule is None:
        return jsonify({'error': get_message('schedule_not_found', lang)}), 404
    return jsonify(schedule.to_dict()), 200

@bp.route('/schedules/<int:schedule_id>', methods=['PUT'])
def update_schedule(schedule_id):
    lang = get_lang()
    schedule = Schedule.query.get(schedule_id)
    if schedule is None:
        return jsonify({'error': get_message('schedule_not_found', lang)}), 404

    data = request.get_json()
    date_str = data.get('date')
    hour_str = data.get('hour')
    shared = data.get('shared')
    reserved = data.get('reserved')
    reserved_by = data.get('reserved_by')
    reserved_note = data.get('reserved_note')

    if date_str:
        try:
            schedule.date = datetime.strptime(date_str, '%Y-%m-%d').date()
        except ValueError:
            return jsonify({'error': get_message('invalid_date_format', lang)}), 400

    if hour_str:
        is_valid, hour_obj, error_key = validate_hour(hour_str, lang)
        if not is_valid:
            return jsonify({'error': get_message(error_key, lang)}), 400
        schedule.hour = hour_obj

    if shared is not None:
        schedule.shared = shared

    if reserved is not None:
        schedule.reserved = reserved
        if reserved:
            # When reserved, reservation details must be provided
            schedule.reserved_by = reserved_by
            schedule.reserved_note = reserved_note
        else:
            # When reservation is canceled
            schedule.reserved_by = None
            schedule.reserved_note = None

    db.session.commit()
    return jsonify(schedule.to_dict()), 200

@bp.route('/schedules/<int:schedule_id>', methods=['DELETE'])
def delete_schedule(schedule_id):
    lang = get_lang()
    schedule = Schedule.query.get(schedule_id)
    if schedule is None:
        return jsonify({'error': get_message('schedule_not_found', lang)}), 404
    db.session.delete(schedule)
    db.session.commit()
    return jsonify({'message': get_message('deleted_successfully', lang)}), 200

@bp.route('/schedules/<int:schedule_id>/cancel', methods=['PUT'])
def cancel_reservation(schedule_id):
    lang = get_lang()
    schedule = Schedule.query.get(schedule_id)
    if schedule is None:
        return jsonify({'error': get_message('schedule_not_found', lang)}), 404
    schedule.reserved = False
    schedule.reserved_by = None
    schedule.reserved_note = None
    db.session.commit()
    return jsonify(schedule.to_dict()), 200

def format_error_response(error_key, lang):
    """
    Returns a standardized JSON response for errors.
    """
    return jsonify({
        "error": {
            "code": 400,
            "message": get_message(error_key, lang),
            "expected_format": {
                "date": "YYYY-MM-DD",
                "hour": "HH:MM (between 09:00 and 19:00)",
                "shared": "Boolean (true/false)"
            }
        }
    }), 400
