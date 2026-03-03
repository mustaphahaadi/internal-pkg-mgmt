FROM rockylinux:8

# Install tools needed to host a yum repo
RUN dnf install -y createrepo nginx && \
    dnf clean all

# Create the directory that will hold our RPMs
RUN mkdir -p /usr/share/nginx/html/repos/yum_local

# Copy nginx config that serves the repo directory
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the repo initialization script
COPY setup-repo.sh /setup-repo.sh
RUN chmod +x /setup-repo.sh

# Expose HTTP port
EXPOSE 80

# On start: init the repo then start nginx
CMD ["/bin/bash", "-c", "/setup-repo.sh && nginx -g 'daemon off;'"]
