FROM python:3.7-alpine

WORKDIR /app
ENV FLASK_APP main.py
EXPOSE 4000
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY . .
CMD ["flask", "run", "-p", "4000"]