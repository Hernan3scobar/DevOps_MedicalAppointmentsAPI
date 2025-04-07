from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class Schedule(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    date = db.Column(db.Date, nullable=False)       # Date of the appointment
    hour = db.Column(db.Time, nullable=False)         # Time of the appointment (between 09:00 and 19:00)
    shared = db.Column(db.Boolean, default=False)     # Indicates if the schedule is shared with clients
    reserved = db.Column(db.Boolean, default=False)   # Reservation status
    reserved_by = db.Column(db.String(100), nullable=True)  # Name of the person who reserved
    reserved_note = db.Column(db.String(255), nullable=True)  # Reservation note

    def to_dict(self):
        return {
            'id': self.id,
            'date': self.date.strftime('%Y-%m-%d'),
            'hour': self.hour.strftime('%H:%M'),
            'shared': self.shared,
            'reserved': self.reserved,
            'reserved_by': self.reserved_by,
            'reserved_note': self.reserved_note
        }
