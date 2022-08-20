from flask import Flask, render_template
from datetime import datetime

app = Flask(__name__)


@app.route('/')
def showCurrentTime():
    now = datetime.now()
    current_time = now.strftime("%H:%M:%S")
    return render_template('index.html', current_time = current_time)