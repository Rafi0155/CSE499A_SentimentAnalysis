import os
import pathlib

import requests
from flask import Flask, session, abort, redirect, request, render_template, url_for
from google.oauth2 import id_token
from google_auth_oauthlib.flow import Flow
from pip._vendor import cachecontrol
import google.auth.transport.requests

from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import ForeignKey, text, or_, func
from sqlalchemy.orm import relationship
from datetime import datetime, timedelta

from functools import wraps

app = Flask("Sentiment Analysis")
app.config["SQLALCHEMY_DATABASE_URI"] = 'mysql://root:@localhost/sentiment_analysis'
db = SQLAlchemy(app)
app.secret_key = "Sentiment_Analysis"

os.environ["OAUTHLIB_INSECURE_TRANSPORT"] = "1"

GOOGLE_CLIENT_ID = "202397772549-3qvh9953m74h4pvcl9vnsjkkontnl8kc.apps.googleusercontent.com"
client_secrets_file = os.path.join(pathlib.Path(__file__).parent, "client_secret.json")

flow = Flow.from_client_secrets_file(
    client_secrets_file=client_secrets_file,
    scopes=["https://www.googleapis.com/auth/userinfo.profile", "https://www.googleapis.com/auth/userinfo.email", "openid"],
    redirect_uri="http://127.0.0.1:5000/callback"
)

#db models
class User(db.Model):
    UserID = db.Column(db.Integer, primary_key=True)
    Username = db.Column(db.String(255), nullable=False)
    Email = db.Column(db.String(255), nullable=False)

class Message(db.Model):
    MessageID = db.Column(db.Integer, primary_key=True)
    SenderID = db.Column(db.Integer, nullable=False)
    ReceiverID = db.Column(db.Integer, nullable=False)
    SenderContent = db.Column(db.Text, nullable=False)
    ReceiverContent = db.Column(db.Text, nullable=False)
    Timestamp = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)


# def login_is_required(function):
#     def wrapper(*args, **kwargs):
#         if "google_id" not in session:
#             return abort(401)  # Authorization required
#         else:
#             return function()

#     return wrapper

def login_is_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if "google_id" not in session:
            #return abort(401)  # Authorization required
            return redirect("/login")
        return f(*args, **kwargs)
    return decorated_function


@app.route("/login")
def login():
    authorization_url, state = flow.authorization_url()
    session["state"] = state
    return redirect(authorization_url)


@app.route("/callback")
def callback():
    flow.fetch_token(authorization_response=request.url)

    if not session["state"] == request.args["state"]:
        abort(500)  # State does not match!

    credentials = flow.credentials
    request_session = requests.session()
    cached_session = cachecontrol.CacheControl(request_session)
    token_request = google.auth.transport.requests.Request(session=cached_session)

    id_info = id_token.verify_oauth2_token(
        id_token=credentials._id_token,
        request=token_request,
        audience=GOOGLE_CLIENT_ID
    )

    session["google_id"] = id_info.get("sub")
    session["name"] = id_info.get("name")
    session["email"] = id_info.get("email") 
    session["picture"] = id_info.get("picture")


    first_name = session["name"].split()[0]
    session["first_name"] = first_name

    # # Check if a user with a specific email exists
    # email_exists = db.session.query(User).filter(User.Email == session["email"]).count() > 0

    # if email_exists == 0:
    #     # Create a new user and add it to the database
    #     new_user = User(Username=session["name"], Email=session["email"])
    #     db.session.add(new_user)
    #     db.session.commit()
    #     user = new_user

    # # Store the user_id in the session
    # session["user_id"] = user.UserID

    # Check if a user with a specific email exists
    user = User.query.filter(func.lower(User.Email) == func.lower(session["email"])).first()
    if not user:
        # Create a new user and add it to the database
        new_user = User(Username=session["name"], Email=session["email"])
        db.session.add(new_user)
        db.session.commit()
        user = new_user  # Assign the newly created user to the user variable

    # Store the user_id in the session
    session["user_id"] = user.UserID

    return redirect("/protected_area")


@app.route("/logout")
def logout():
    session.clear()
    return redirect("/")


@app.route("/")
def index():
    session.clear()
    return render_template('index.html')


@app.route("/protected_area")
@login_is_required
def protected_area():
    # Fetch user ID from the database based on the email address stored in the session
    user_email = session.get("email")
    if user_email is None:
        return redirect("/login")  # Redirect to login if email is not found in session

    user = User.query.filter(func.lower(User.Email) == func.lower(user_email)).first()
    if user is None:
        return redirect("/login")  # Redirect to login if user is not found in the database

    # Fetch messages involving the user
    user_messages = Message.query.filter(
        (Message.SenderID == user.UserID) | (Message.ReceiverID == user.UserID)
    ).order_by(Message.Timestamp).all()

    return render_template('index.html', name = session["name"], picture = session["picture"], user_messages=user_messages) 


@app.route("/send_message", methods=["POST"])
@login_is_required
def send_message():
    user_id = session.get("user_id")  # Assuming you have a user_id stored in the session
    if user_id is None:
        return redirect("/login")  # Redirect to login if user is not logged in

    message_content = request.form.get("message_content")

    if message_content:
        # Assuming the bot has a fixed ID in the database
        bot_id = 1  # Adjust this based on your bot's ID in the database

        # Simulate bot's response
        bot_response_content = "This is a bot's response."  # You can replace this with actual bot logic

        # Save the user's message to the database
        new_user_message = Message(SenderID=user_id, ReceiverID=bot_id, SenderContent=message_content, ReceiverContent=bot_response_content, Timestamp=datetime.utcnow())
        db.session.add(new_user_message)
        db.session.commit()


    return redirect(url_for('protected_area', _anchor='bottom'))  # Redirect to the protected area after sending the message


if __name__ == "__main__":
    app.run(debug=True)