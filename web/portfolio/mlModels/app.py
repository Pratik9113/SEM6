from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_mail import Mail, Message
from dotenv import load_dotenv
import os 

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "http://localhost:3000"}})

app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = '2022.pratik.patil@ves.ac.in' 
app.config['MAIL_PASSWORD'] =  os.getenv('gmailpswd')
app.config['MAIL_DEFAULT_SENDER'] = '2022.pratik.patil@ves.ac.in' 

mail = Mail(app)

def send_email(to, subject, text):
    try:
        msg = Message(
            subject=f"User Name: {subject}",
            sender=app.config['MAIL_DEFAULT_SENDER'],
            recipients=[to],
            body=f"This is a reminder that a new user posted on your contact form  '{subject}'.\n\nDescription: {text}"
        )
        mail.send(msg)
        print(f"Email sent to {to}")
    except Exception as e:
        print(f"Error sending email: {e}")

@app.route('/submit', methods=['POST'])
def submit_task():
    """ Route that receives task details and sends an email """
    data = request.get_json()
    email = data.get('email') 
    name = data.get('name')
    msg = data.get('msg')
    print(f"User Prompt Received: {msg}, {name}, Recipient: {email}")
    send_email(email, name, msg)
    return jsonify({"status": "success", "message": "Email sent!"})

if __name__ == '__main__':
    app.run(debug=True)
