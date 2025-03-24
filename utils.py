from datetime import datetime, time

def get_message(key, lang='es'):
    # Dictionary for messages in both Spanish and English
    messages = {
        'invalid_date_format': {
            'es': 'Formato de fecha incorrecto. Use YYYY-MM-DD.',
            'en': 'Invalid date format. Use YYYY-MM-DD.'
        },
        'invalid_hour_format': {
            'es': 'Formato de hora incorrecto. Use HH:MM.',
            'en': 'Invalid time format. Use HH:MM.'
        },
        'hour_out_of_range': {
            'es': 'La hora debe estar entre 09:00 y 19:00.',
            'en': 'The time must be between 09:00 and 19:00.'
        },
        'schedule_not_found': {
            'es': 'No se encontró la hora programada.',
            'en': 'Schedule not found.'
        },
        'deleted_successfully': {
            'es': 'Hora eliminada correctamente.',
            'en': 'Schedule deleted successfully.'
        }
    }
    return messages.get(key, {}).get(lang, '')

def validate_hour(hour_str, lang='es'):
    try:
        hour_time = datetime.strptime(hour_str, '%H:%M').time()
    except ValueError:
        return False, None, 'invalid_hour_format'
    
    if not (time(9, 0) <= hour_time <= time(19, 0)):
        return False, None, 'hour_out_of_range'
    return True, hour_time, None
