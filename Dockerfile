FROM debian:stable-slim
LABEL maintainer=n0ix

# Update base and install dependencies
RUN apt update && \
    apt --yes upgrade && \
    apt install --yes --no-install-recommends git wget subversion python lftp md5sum vim-common openssl grep cut cat sed awk tail bc unrar-free jq php5-cgi source base64 && \
    apt clean && \
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
