FROM ich777/steamcmd:latest

RUN apt-get update && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y wine32 wine64 winbind xvfb zip && \
    apt-get clean

WORKDIR /serverdata/serverfiles

RUN echo '#!/bin/bash\n\
Xvfb :0 -screen 0 1024x768x16 &\n\
export DISPLAY=:0\n\
steamcmd +login $STEAM_USERNAME $STEAM_PASSWORD +force_install_dir /serverdata/serverfiles +app_update $GAME_ID -beta $BETABRANCH -betapassword $BETAPASS validate +quit\n\
wine /serverdata/serverfiles/MotorTownServer.exe' > /start.sh && \
chmod +x /start.sh

CMD ["/start.sh"]