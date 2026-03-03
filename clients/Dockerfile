FROM rockylinux:8

# Install basic tools
RUN dnf install -y curl && \
    dnf clean all

# Copy the script that configures the yum repo on this client
COPY configure-repo.sh /configure-repo.sh
RUN chmod +x /configure-repo.sh

# Keep container running so you can exec into it
CMD ["/bin/bash", "-c", "/configure-repo.sh && tail -f /dev/null"]
