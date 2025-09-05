FROM ubuntu:20.04

RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y wine64 wine32 xvfb winbind

WORKDIR /motortown

COPY entrypoint.sh /motortown/entrypoint.sh
RUN chmod +x /motortown/entrypoint.sh

ENTRYPOINT ["/motortown/entrypoint.sh"]
