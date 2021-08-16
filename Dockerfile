FROM python:3.8 as base

ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONUNBUFFERED=1

EXPOSE 80

WORKDIR /app

FROM base as builder

ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VERSION=1.1.6

RUN apt-get update -y && \
    apt-get install -y python3-pip python3-dev python3-venv && \
    pip install --upgrade pip

RUN pip install "poetry==$POETRY_VERSION"
RUN python3 -m venv /venv

COPY pyproject.toml poetry.lock ./
RUN poetry install
RUN poetry export --without-hashes -f requirements.txt | /venv/bin/pip install -r /dev/stdin  
COPY . .

FROM base as final

RUN apt-get update -y && \
    apt-get install -y python3-pip python3-dev python3-venv && \
    pip install --upgrade pip

RUN apt-get clean autoclean
RUN apt-get autoremove --yes
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/  

COPY --from=builder /venv /venv
COPY --from=builder /app /app
COPY docker-entrypoint.sh wsgi.py ./
RUN ["chmod", "+x", "./docker-entrypoint.sh"]
CMD ["./docker-entrypoint.sh"]
