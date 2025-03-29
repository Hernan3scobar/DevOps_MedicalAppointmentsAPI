# Medical Appointment Scheduling API

This is a RESTful API built with Flask for scheduling medical appointments. It allows users to create, manage, and share available time slots.

## Features
- Full CRUD for managing schedules (days and hours from 09:00 to 19:00)
- Hourly slots with continuous scheduling
- Ability to mark shared schedules for clients to view
- Reservation status with user details and notes
- Cancelation of reservations
- Multi-language support (English & Spanish)
- CORS enabled
- Modular and scalable structure

## Installation

### 1. Clone the Repository
```bash
git clone https://github.com/CodeSSRockMan/DevOps_MedicalAppointmentsAPI.git
cd DevOps_MedicalAppointmentsAPI
```

### 2. Create a Virtual Environment
#### Windows
```bash
python -m venv .venv
.venv\Scripts\activate
```

#### macOS/Linux
```bash
python3 -m venv .venv
source .venv/bin/activate
```

### 3. Install Dependencies
```bash
pip install -r requirements.txt
pip install --upgrade flask werkzeug
```

### 4. Set Up Environment Variables
Create a `.env` file and configure necessary settings.

### 5. Run the Application
```bash
python app.py
```

The API will be available at `http://127.0.0.1:5000/`
