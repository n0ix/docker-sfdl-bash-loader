FROM debian:stable-slim
LABEL maintainer=n0ix

ENV Passwords "$SFDL_PASSWORDS"
ENV PasswordFile "$SFDL_PASSWORDFILE"

# Update base and install dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive; \
    apt-get install --yes --no-install-recommends apt-utils git wget subversion python lftp coreutils vim-common openssl bc unrar-free jq ca-certificates procps && \
    apt-get --yes upgrade && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app/

RUN wget https://raw.githubusercontent.com/raz3r-code/sfdl-bash-loader/master/sfdl_bash_loader/update.sh -v -O update.sh && \
    chmod +x ./update.sh && \
    ./update.sh install; rm -rf update.sh
    
WORKDIR /app/sfdl_bash_loader/

RUN chmod +x SplitPasswordsToFile && \
    ./SplitPasswordsToFile

RUN cat $SFDL_PASSWORDFILE >> sys/passwords.txt

VOLUME ["/app/sfdl_bash_loader/sfdl/"]
VOLUME ["/app/sfdl_bash_loader/downloads/"] 

ENTRYPOINT ["/bin/sh","/app/sfdl_bash_loader/start.sh"]

STOPSIGNAL SIGTERM
