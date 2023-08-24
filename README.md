# docker-sfdl-bash-loader
Docker Build for sfdl-bash-loader | https://sfdl.net

## How to Use

Create a folder called `sfdl` and put yout SFDL File there. Then run the Docker Container:

```
docker run --rm -it --init \
-v=sfdl:/app/sfdl_bash_loader/sfdl/ \
-v=downloads:/app/sfdl_bash_loader/downloads/ \
n0ix/docker-sfdl-bash-loader
```

If you using docker-compose:

```
version: '3.3'
services:
    docker-sfdl-bash-loader:
        volumes:
            - 'sfdl:/app/sfdl_bash_loader/sfdl/'
            - 'downloads:/app/sfdl_bash_loader/downloads/'
        image: ghcr.io/n0ix/docker-sfdl-bash-loader
```

If your SFDL File is password protected you want to specify a Password or a Password File. This can be done via environment variables:

```
# Passwords as String seperated by ','
docker run --rm -it --init \
-v=sfdl:/app/sfdl_bash_loader/sfdl/ \
-v=downloads:/app/sfdl_bash_loader/downloads/ \
-e Passwords=password01,password02 \
ghcr.io/n0ix/docker-sfdl-bash-loader
```

```
docker run --rm -it --init \
-v=sfdl:/app/sfdl_bash_loader/sfdl/ \
-v=downloads:/app/sfdl_bash_loader/downloads/ \
-e PasswordFile=my_passwords.txt
ghcr.io/n0ix/docker-sfdl-bash-loader
```
