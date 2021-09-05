FROM squidfunk/mkdocs-material:7.2.6
LABEL maintainer="aschenmaker, aschen@cug.edu.cn"

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install --upgrade --no-cache-dir coscmd

COPY ac.sh /ac.sh

RUN apk add --no-cache bash && chmod +x /ac.sh

ENTRYPOINT ["/ac.sh"]