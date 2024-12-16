FROM python:3.11-slim

# Install system dependencies, including distutils for Python 3.10+
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    python3-distutils \
    && rm -rf /var/lib/apt/lists/*

# Install Django
RUN pip install --no-cache-dir django==3.2

# Copy application files
COPY . .

# Install any other dependencies (like requirements.txt, if needed)
# RUN pip install -r requirements.txt  # Uncomment if you have a requirements.txt

# Run migrations
RUN python manage.py migrate

# Expose port
EXPOSE 8000

# Start the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
