FROM alpine:latest

RUN apk add --no-cache --virtual .run-deps rsync openssh tzdata curl ca-certificates sudo && rm -rf /var/cache/apk/*

ENV _USER=rsyncuser

RUN mkdir -p "/home/$_USER/.ssh"

RUN sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config

# this command enables login on root account, I believe
#sed -i 's/root:!/root:*/' /etc/shadow

# Generate host SSH keys
RUN ssh-keygen -A


COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sh"]