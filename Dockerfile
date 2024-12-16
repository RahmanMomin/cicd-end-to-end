FROM python:3

# Install system dependencies including distutils
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Django
RUN pip install django==3.2

# Copy application files
COPY . .

# Run migrations
RUN python manage.py migrate

# Expose port
EXPOSE 8000

# Start the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
