# S2I image for Spring Boot in Alpine Linux, works in OpenShift 3.9

FROM openjdk:8-alpine

LABEL io.k8s.description="S2I image for Spring Boot in Alpine Linux" \
      io.k8s.display-name="Open jdk 1.8" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,jdk,openjdk,alpine,spring,springboot,s2i" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

# install packages
# RUN apk add --no-cache ...

# Copy the S2I scripts to /usr/libexec/s2i which is the location set for scripts
# as io.openshift.s2i.scripts-url label
COPY ./s2i/bin/ /usr/libexec/s2i

# Copy customized config files
# COPY nginx.conf /etc/nginx/nginx.conf
# COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

# support running as arbitrary user which belogs to the root group
RUN mkdir -p /var/cache/nginx && \
    adduser -u 1001 -G root -h /tmp -D -H -S -s/sbin/nologin 1001 && \
    chown -R 1001:root /usr/libexec/s2i && \
    chmod -R 775 /usr/libexec/s2i

# RUN chgrp -R root /var/cache/nginx
# RUN addgroup nginx root

EXPOSE 8080

USER 1001

CMD [ "/usr/libexec/s2i/usage" ]
