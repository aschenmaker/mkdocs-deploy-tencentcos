FROM python:3.7-slim
LABEL maintainer="aschenmaker, aschen@cug.edu.cn"

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install --upgrade --no-cache-dir coscmd mkdocs mkdocs-material

COPY ac.sh /ac.sh

RUN chmod +x /ac.sh

ENTRYPOINT ["/ac.sh"]