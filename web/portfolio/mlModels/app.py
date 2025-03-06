from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_mail import Mail, Message

app = Flask(__name__)
CORS(app)

app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = '2022.pratik.patil@ves.ac.in' 
app.config['MAIL_PASSWORD'] = 'qmybzwnnvfnsaeii' 
app.config['MAIL_DEFAULT_SENDER'] = '2022.pratik.patil@ves.ac.in' 

mail = Mail(app)

def send_email(to, subject, text, deadline):
    """ Function to send an email automatically """
    try:
        msg = Message(
            subject=f"Task Reminder: {subject}",
            sender=app.config['MAIL_DEFAULT_SENDER'],
            recipients=[to],
            body=f"This is a reminder that a new user  '{subject}' is due at {deadline}.\n\nDescription: {text}"
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
    task_name = data.get('task_name')
    task_desc = data.get('task_desc')
    deadline = data.get('deadline')
    print(f"Task Received: {task_name}, Deadline: {deadline}, Recipient: {email}")
    send_email(email, task_name, task_desc, deadline)
    return jsonify({"status": "success", "message": "Task received, email sent!"})

if __name__ == '__main__':
    app.run(debug=True)
