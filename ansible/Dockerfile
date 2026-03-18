FROM rockylinux:8

# Install Ansible + SSH client tools
RUN dnf install -y epel-release && \
    dnf install -y ansible openssh-clients sshpass && \
    dnf clean all

# Set working directory
WORKDIR /ansible

# Copy Ansible config and inventory
COPY ansible.cfg /etc/ansible/ansible.cfg
COPY inventory.ini /ansible/inventory.ini
COPY playbooks/ /ansible/playbooks/
