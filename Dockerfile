FROM debian:stable-slim
LABEL maintainer=n0ix

ENV Passwords=
ENV PasswordFile=
ENV ExtractArchives=true
ENV DeleteArchivesAfterExtract=false
ENV Debug=false
ENV TERM=xterm

# Update base and install dependencies
RUN sed -i -e's/ main/ main contrib non-free non-free-firmware/g' /etc/apt/sources.list.d/debian.sources && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive; \
    apt-get install --yes --no-install-recommends apt-utils git curl wget subversion python-is-python3 lftp coreutils vim-common xxd openssl bc unrar jq ca-certificates procps tini && \
    apt-get --yes upgrade && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app/

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod  +x /app/entrypoint.sh

RUN curl -L https://raw.githubusercontent.com/raz3r-code/sfdl-bash-loader/master/sfdl_bash_loader/update.sh -O update.sh && \
    chmod +x ./update.sh && \
    ./update.sh install; rm -rf update.sh

RUN echo "sfdl_rar_auspacken=${ExtractArchives}" >> /app/sfdl_bash_loader/sys/force.cfg && \
    echo "sfdl_rar_entfernen=${DeleteArchivesAfterExtract}" >> /app/sfdl_bash_loader/sys/force.cfg && \
    cp /app/sfdl_bash_loader/sys/loader.cfg /app/sfdl_bash_loader/sys/loader.cfg.bak && \
    mv /app/sfdl_bash_loader/sys/loader.cfg /app/sfdl_bash_loader/sys/loader.cfg.new && \
    /app/sfdl_bash_loader/sys/updatecfg.sh /app/sfdl_bash_loader/sys/loader.cfg.new /app/sfdl_bash_loader/sys/loader.cfg.bak /app/sfdl_bash_loader/sys/force.cfg /app/sfdl_bash_loader/sys/loader.cfg

WORKDIR /app/sfdl_bash_loader/

VOLUME ["/app/sfdl_bash_loader/sfdl/"]
VOLUME ["/app/sfdl_bash_loader/downloads/"] 

ENTRYPOINT ["tini", "--", "/app/entrypoint.sh"]
