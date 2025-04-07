from datetime import datetime, time

def get_message(key, lang):
    messages = {
        'es': {
            'invalid_date_format': 'Formato de fecha inválido. Debe ser YYYY-MM-DD.',
            'schedule_not_found': 'Horario no encontrado.',
            'deleted_successfully': 'El horario ha sido eliminado con éxito.',
            'invalid_hour_format': 'Formato de hora inválido. Debe ser HH:MM (entre 09:00 y 19:00).',
            'invalid_hour_range': 'La hora debe estar entre 09:00 y 19:00.',
        },
        'en': {
            'invalid_date_format': 'Invalid date format. It should be YYYY-MM-DD.',
            'schedule_not_found': 'Schedule not found.',
            'deleted_successfully': 'The schedule has been successfully deleted.',
            'invalid_hour_format': 'Invalid hour format. It should be HH:MM (between 09:00 and 19:00).',
            'invalid_hour_range': 'The hour must be between 09:00 and 19:00.',
        }
    }
    
    return messages.get(lang, messages['es']).get(key, 'Unknown error')

def validate_hour(hour_str, lang='es'):
    try:
        hour_time = datetime.strptime(hour_str, '%H:%M').time()
    except ValueError:
        return False, None, 'invalid_hour_format'
    
    if not (time(9, 0) <= hour_time <= time(19, 0)):
        return False, None, 'hour_out_of_range'
    return True, hour_time, None
