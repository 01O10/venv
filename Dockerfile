# Use the official Python image from the Docker Hub
FROM python:3.10-slim

# Set environment variables
ENV POETRY_VERSION=1.2.0 \
  PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  # Poetry's configuration:
  POETRY_NO_INTERACTION=1 \
  POETRY_VIRTUALENVS_CREATE=false \
  POETRY_CACHE_DIR='/var/cache/pypoetry' \
  POETRY_HOME='/usr/local'

# Install dependencies and tools
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    build-essential \
    gdebi-core \
    r-base \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Ensure Poetry is in the PATH
ENV PATH="/root/.local/bin:$PATH"

# Install Quarto
RUN curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb \
    && gdebi --non-interactive quarto-linux-amd64.deb \
    && rm quarto-linux-amd64.deb

# Create the .scripts directory
RUN mkdir -p /root/.scripts


# Create the add_repositories.sh script
RUN echo "#!/bin/bash" > /root/.scripts/add_repositories.sh && \
    echo "mkdir -p docs/docs/site" >> /root/.scripts/add_repositories.sh && \
    echo "mkdir -p registry/registry/data" >> /root/.scripts/add_repositories.sh && \
    echo "mkdir -p notebooks" >> /root/.scripts/add_repositories.sh && \
    chmod +x /root/.scripts/add_repositories.sh

# Set working directory
WORKDIR /app

# Install Python packages
# RUN pip install numpy matplotlib scikit-learn jupyter commitizen pytest pytest-cov ruff python-semantic-release

# Install R packages
# RUN R -e "install.packages(c('tidyverse', 'httpgd'), repos='https://cran.rstudio.com/')"

# Run bash by default
CMD ["bash"]
