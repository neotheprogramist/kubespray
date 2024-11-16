# README: Ansible Cluster Setup and Volume Management

This repository provides Ansible playbooks and Linux commands for setting up and managing a cluster using the Ansible automation tool. Additionally, instructions for configuring logical volume management (LVM) are included.

## Prerequisites

Before running the playbooks or executing any commands, ensure that you have the following:

- Ansible installed on your system.
- Root or sudo privileges for volume management commands.
- A properly configured Ansible inventory (`inventory/visoft/hosts.yaml`).
- Necessary secrets available in `inventory/visoft/secrets.yaml`.

### Ansible Playbooks

#### 1. Cluster Setup

To configure and deploy the cluster, run the following playbook. This playbook applies configuration changes to all hosts listed in the inventory file:

```bash
ansible-playbook -i inventory/visoft/hosts.yaml --become cluster.yml
```

- `-i inventory/visoft/hosts.yaml`: Specifies the inventory file containing the host details.
- `--become`: Runs the playbook with elevated privileges (root).
- `cluster.yml`: The playbook for setting up the cluster.

#### 2. Provisioning with Secrets

To provision resources with sensitive data, such as credentials or tokens, use the secrets file (`secrets.yaml`). This playbook provisions additional resources by loading variables from the secrets file.

```bash
ansible-playbook -e @inventory/visoft/secrets.yaml -i inventory/visoft/hosts.yaml --become inventory/visoft/provision.yaml
```

- `-e @inventory/visoft/secrets.yaml`: Loads the secrets from the encrypted file `secrets.yaml`.
- `inventory/visoft/provision.yaml`: The playbook for provisioning infrastructure with secrets.

#### 3. Resetting the Cluster

To reset the cluster (e.g., for reconfiguration or cleanup), execute the reset playbook:

```bash
ansible-playbook -i inventory/visoft/hosts.yaml --become reset.yml
```

- `reset.yml`: The playbook for resetting the cluster.

### Logical Volume Management (LVM)

LVM allows for flexible disk management by creating logical volumes from physical storage devices. Below are the steps for creating a volume group (`vg0`) and managing it.

#### 1. Create a Volume Group

The following command creates a volume group (`vg0`) by combining the devices `/dev/vdb`, `/dev/vdc`, and `/dev/vdd`:

```bash
sudo vgcreate vg0 /dev/vdb /dev/vdc /dev/vdd
```

- `vg0`: The name of the new volume group.
- `/dev/vdb /dev/vdc /dev/vdd`: The physical devices being added to the volume group.

#### 2. Display Volume Group Information

To display detailed information about the volume group (`vg0`), use the following command:

```bash
sudo vgdisplay
```

This will output information about the volume group, including its size, physical volumes, and free space.

---

## Conclusion

This repository provides the basic steps to set up, provision, and reset a cluster using Ansible. Additionally, it includes commands for managing logical volumes with LVM on Linux.

For any issues or further details, please refer to the respective Ansible and LVM documentation.
