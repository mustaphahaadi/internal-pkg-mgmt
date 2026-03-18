FROM rockylinux:8

# Install Ansible, Docker CLI, and SSH client
RUN dnf install -y epel-release && \
    dnf install -y ansible openssh-clients docker && \
    dnf clean all

# Set working directory
WORKDIR /ansible

# Copy Ansible config and inventory
COPY ansible.cfg /etc/ansible/ansible.cfg
COPY inventory.ini /ansible/inventory.ini
COPY playbooks/ /ansible/playbooks/
