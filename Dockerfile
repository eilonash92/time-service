FROM python:3.7-alpine

WORKDIR /app
ENV FLASK_APP main.py
ENV FLASK_RUN_HOST 0.0.0.0
ENV FLASK_RUN_PORT 4000
EXPOSE 4000
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY . .
CMD ["flask", "run", "-h", "0.0.0.0", "-p", "4000"]