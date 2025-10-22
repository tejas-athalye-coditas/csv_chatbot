FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

# Injecting them using Jenkins
ARG GROQ_API_KEY
ENV GROQ_API_KEY=$(GROQ_API_KEY)

EXPOSE 8005

CMD [ "python", "app.py" ]