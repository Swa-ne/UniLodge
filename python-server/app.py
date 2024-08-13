from flask import Flask, request, send_file
from dotenv import load_dotenv, dotenv_values

from email.message import EmailMessage
import os
import ssl
import smtplib
import base64

load_dotenv()

app = Flask(__name__)

_emailSender = os.getenv("EMAIL_SENDER")
_emailPassword = os.getenv("EMAIL_PASSWORD")
context = ssl.create_default_context()
smtp_connection = smtplib.SMTP_SSL('smtp.gmail.com', 465, context=context)
smtp_connection.login(_emailSender, _emailPassword)


@app.route("/send-email", methods=["POST"])
def sendEmail():
    name = request.form['name']
    code = request.form['code']
    emailReceiver = request.form['receiver']

    em = EmailMessage()

    image_url = request.url_root + 'image-logo'
    body = f"""
    <html>
    <head></head>
    <body>
        <div style="font-family: Arial, sans-serif; text-align: center;">
            <img src="{image_url}" alt="UniLodge Logo" style="width: 100px; margin-bottom: 20px;">
            <h2>Your Security Code</h2>
            <p>Hello, {name}</p>
            <p>Verifying your email address improves the security of your UniLodge account, please enter the following code when prompted:</p>
            <h1 style="letter-spacing: 5px;">{code}</h1>
            <p>Thank you,<br>The UniLodge Team</p>
        </div>
    </body>
    </html>
    """
    
    em['Subject'] = "Email Verification"
    em['From'] = _emailSender
    em['To'] = emailReceiver
    em.set_content(body, subtype='html') 

    smtp_connection.sendmail(_emailSender, emailReceiver, em.as_string())

    return "Email Sent"


def close_connection(exception):
    smtp_connection.quit()

@app.route('/image-logo')
def display_logo():
    image_path = 'logo.png'
    return send_file(image_path, mimetype='image/png')