FROM ubuntu:20.04

# Enable 32-bit architecture and install Wine + tools
RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y wine64 wine32 xvfb winbind jq

WORKDIR /motortown

# Copy entrypoint script
COPY entrypoint.sh /motortown/entrypoint.sh
RUN chmod +x /motortown/entrypoint.sh

ENTRYPOINT ["/motortown/entrypoint.sh"]
