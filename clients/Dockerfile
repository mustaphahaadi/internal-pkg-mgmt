FROM rockylinux:8

# Install basic tools + SSH server for Ansible connectivity
RUN dnf install -y curl openssh-server && \
    dnf clean all

# Prepare SSH server and enable root login for lab automation
RUN ssh-keygen -A && \
    sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo 'root:ansible' | chpasswd

# Copy the script that configures the yum repo on this client
COPY configure-repo.sh /configure-repo.sh
RUN chmod +x /configure-repo.sh

# Start SSH for Ansible, configure repo at startup, then keep running
CMD ["/bin/bash", "-c", "/usr/sbin/sshd && /configure-repo.sh && tail -f /dev/null"]
