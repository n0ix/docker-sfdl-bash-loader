FROM debian:stable-slim
LABEL maintainer=n0ix

# Update base and install dependencies
RUN apt-get update && \
    apt-get install --yes --no-install-recommends apt-utils git wget subversion python lftp coreutils vim-common openssl bc unrar-free jq ca-certificates && \
    apt-get --yes upgrade && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app

RUN wget https://raw.githubusercontent.com/raz3r-code/sfdl-bash-loader/master/sfdl_bash_loader/update.sh -v -O update.sh && \
    chmod +x ./update.sh && \
    ./update.sh install; rm -rf update.sh
    

VOLUME ["/app/sfdl-bash-loader/sfdl/"]
VOLUME ["/app/sfdl-bash-loader/downloads/"] 

ENTRYPOINT ["sh" "/app/sfdl-bash-loader/start.sh"]

STOPSIGNAL SIGTERM
