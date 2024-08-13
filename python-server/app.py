from flask import Flask, request
from dotenv import load_dotenv, dotenv_values

from email.message import EmailMessage
import os
import ssl
import smtplib

load_dotenv()

app = Flask(__name__)

_emailSender = os.getenv("EMAIL_SENDER")
_emailPassword = os.getenv("EMAIL_PASSWORD")
context = ssl.create_default_context()
smtp_connection = smtplib.SMTP_SSL('smtp.gmail.com', 465, context=context)
smtp_connection.login(_emailSender, _emailPassword)

@app.route("/send-email", methods=["POST"])
def sendEmail():
    code = request.form['code']
    emailReceiver = request.form['receiver']

    em = EmailMessage()
    body = f"""Hi,

Your verification code is: {code}
"""
    em['Subject'] = "Email Verification"
    em['From'] = _emailSender
    em['To'] = emailReceiver
    em.set_content(body)

    smtp_connection.sendmail(_emailSender, emailReceiver, em.as_string())

    return "Email Sent"


def close_connection(exception):
    smtp_connection.quit()