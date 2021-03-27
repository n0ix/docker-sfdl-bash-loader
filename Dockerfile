FROM debian:stable-slim
LABEL maintainer=n0ix

ENV Passwords
ENV PasswordFile
ENV ExtractArchives=true
ENV DeleteArchivesAfterExtract=false
ENV Debug=false
ENV UseProxy=false
ENV ProxyUser
ENV ProxyPassword
ENV ProxyServer
ENV ProxyServerPort
ENV EnableWebInterface=false
ENV WebInterfacePort=8282
ENV WebInterfaceStartPassword=gogogo
ENV WebInterfaceStopPassword=bye
ENV WebInterfaceKillPassword=byebye

# Update base and install dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive; \
    apt-get install --yes --no-install-recommends apt-utils git wget subversion python lftp coreutils vim-common openssl bc unrar-free jq ca-certificates procps && \
    apt-get --yes upgrade && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app/

COPY SplitPasswordsToFile /app/SplitPasswordsToFile
RUN chmod +x SplitPasswordsToFile

RUN wget https://raw.githubusercontent.com/raz3r-code/sfdl-bash-loader/master/sfdl_bash_loader/update.sh -v -O update.sh && \
    chmod +x ./update.sh && \
    ./update.sh install; rm -rf update.sh

RUN echo "sfdl_rar_auspacken=${ExtractArchives}" >> /app/sfdl_bash_loader/sys/force.cfg && \
    echo "sfdl_rar_entfernen=${DeleteArchivesAfterExtract}" >> /app/sfdl_bash_loader/sys/force.cfg && \
    cp /app/sfdl_bash_loader/sys/loader.cfg /app/sfdl_bash_loader/sys/loader.cfg.bak && \
    mv /app/sfdl_bash_loader/sys/loader.cfg /app/sfdl_bash_loader/sys/loader.cfg.new && \
    ./app/sfdl_bash_loader/sys/updatecfg.sh /app/sfdl_bash_loader/sys/loader.cfg.new /app/sfdl_bash_loader/sys/loader.cfg.bak /app/sfdl_bash_loader/sys/force.cfg /app/sfdl_bash_loader/sys/loader.cfg

WORKDIR /app/sfdl_bash_loader/

VOLUME ["/app/sfdl_bash_loader/sfdl/"]
VOLUME ["/app/sfdl_bash_loader/downloads/"] 

CMD /app/SplitPasswordsToFile && \
    cat $SFDL_PASSWORDFILE >> /app/sfdl_bash_loader/sys/passwords.txt && \
    ./start.sh

STOPSIGNAL SIGTERM
