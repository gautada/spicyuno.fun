# Docker/Podman/OCI container build specfication file.
#
# References:
# - [Gist](https://gist.github.com/gautada/bd71914073b8e3a89ad13f0320b33010)
# - [Buildah Containerfile](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/building_running_and_managing_containers/assembly_building-container-images-with-buildah_building-running-and-managing-containers#proc_building-an-image-from-a-containerfile-with-buildah_assembly_building-container-images-with-buildah)
# - [Dockerfile](https://docs.docker.com/engine/reference/builder/)

ARG ALPINE_VERSION=latest

# ╭――――――――――――――――-------------------------------------------------------――╮
# │                                                                         │
# │ STAGE: container                                                      │
# │                                                                         │
# ╰―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――╯
FROM gautada/alpine:$ALPINE_VERSION

# ╭――――――――――――――――――――╮
# │ METADATA           │
# ╰――――――――――――――――――――╯
LABEL source="https://github.com/gautada/spicyuno.fun.git"
LABEL maintainer="Adam Gautier <adam@gautier.org>"
LABEL description="Website for spicyuno.fun"

# ╭――――――――――――――――――――╮
# │ STANDARD CONFIG    │
# ╰――――――――――――――――――――╯

# USER:
ARG USER=spicyuno

ARG UID=1001
ARG GID=1001
RUN /usr/sbin/addgroup -g $GID $USER \
 && /usr/sbin/adduser -D -G $USER -s /bin/ash -u $UID $USER \
 && /usr/sbin/usermod -aG wheel $USER \
 && /bin/echo "$USER:$USER" | chpasswd

# PRIVILEGE:
COPY wheel  /etc/container/wheel

# BACKUP:
# COPY backup /etc/container/backup

# ENTRYPOINT:
RUN rm -v /etc/container/entrypoint
COPY entrypoint /etc/container/entrypoint

# FOLDERS
RUN /bin/chown -R $USER:$USER /mnt/volumes/container \
 && /bin/chown -R $USER:$USER /mnt/volumes/backup \
 && /bin/chown -R $USER:$USER /var/backup \
 && /bin/chown -R $USER:$USER /tmp/backup


# ╭――――――――――――――――――――╮
# │ APPLICATION        │
# ╰――――――――――――――――――――╯
RUN /sbin/apk add --no-cache nginx openssl curl wget git bash libressl
COPY http-default.conf /etc/nginx/http.d/default.conf
COPY *.html /home/$USER/www/
COPY *.js /home/$USER/www/
COPY *.css /home/$USER/www/
COPY *.md /home/$USER/www/
COPY *.png /home/$USER/www/
COPY *.pdf /home/$USER/www/
RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log
# RUN echo "sudo /usr/sbin/nginx -g 'daemon off;'" > /home/nginx/go \
#  && chmod +x /home/nginx/go

# ╭――――――――――――――――――――╮
# │ CONTAINER          │
# ╰――――――――――――――――――――╯
USER $USER
VOLUME /mnt/volumes/backup
VOLUME /mnt/volumes/configmaps
VOLUME /mnt/volumes/container
EXPOSE 8080/tcp
WORKDIR /home/$USER
