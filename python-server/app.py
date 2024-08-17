from flask import Flask, request, send_file
from dotenv import load_dotenv
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


@app.route("/send-email-code", methods=["POST"])
def sendEmailCode():
    data = request.json
    name = data.get('name')
    code = data.get('code')
    emailReceiver = data.get('receiver')
    
    if not name or not code or not emailReceiver:
        return "Missing required fields", 400

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
            <p>Verifying your email address improves the security of your UniLodge account. Please enter the following code when prompted:</p>
            <h1 style="letter-spacing: 5px;">{code}</h1>
            <p>Please note: This code will expire in 20 minutes.</p>
            <p>Thank you,<br>The UniLodge Team</p>
        </div>
    </body>
    </html>
    """
    
    em['Subject'] = "Email Verification"
    em['From'] = _emailSender
    em['To'] = emailReceiver
    em.set_content(body, subtype='html')

    try:
        smtp_connection.sendmail(_emailSender, emailReceiver, em.as_string())
        return "Email Sent"
    except smtplib.SMTPException as e:
        smtp_connection.quit()
        smtp_connection.connect('smtp.gmail.com', 465)
        smtp_connection.login(_emailSender, _emailPassword)
        smtp_connection.sendmail(_emailSender, em['To'], em.as_string())
        return "Email Sent"


@app.route('/image-logo')
def display_logo():
    image_path = 'logo.png'
    return send_file(image_path, mimetype='image/png')

if __name__ == "__main__":
    app.run(debug=True)
