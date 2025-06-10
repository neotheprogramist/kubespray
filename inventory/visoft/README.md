# Visoft Kubernetes Setup Guide

This guide will walk you through generating SSL certificates and setting up a Kubernetes configuration for the `visoft` cluster. The process involves using OpenSSL to create certificates for a Kubernetes user named `neo` and configuring `kubectl` to use these credentials.

## Prerequisites

Ensure you have the following tools installed on your system:

- [OpenSSL](https://www.openssl.org)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Steps

### 1. Generate Private Key for Neo

Run the following command to generate a 2048-bit RSA private key for the `neo` user:

```bash
openssl genrsa -out inventory/visoft/artifacts/neo/neo.pem 2048
```

This creates the private key file `neo.pem` in the `inventory/visoft/artifacts/neo` directory.

### 2. Create Certificate Signing Request (CSR)

Use the generated private key to create a CSR for the `neo` user. You can specify the user’s details like `CN=neo` in the subject:

```bash
openssl req -new -key inventory/visoft/artifacts/neo/neo.pem -out inventory/visoft/artifacts/neo/neo.csr -subj "/CN=neo"
```

The CSR (`neo.csr`) is stored in the `inventory/visoft/artifacts/neo` directory.

### 3. Sign CSR with CA to Create Neo's Certificate

Sign the `neo.csr` using the Certificate Authority (CA) certificate and key. This will generate the `neo.crt` certificate:

```bash
openssl x509 -req -in inventory/visoft/artifacts/neo/neo.csr -CA inventory/visoft/artifacts/ca.crt -CAkey inventory/visoft/artifacts/ca.key -CAcreateserial -out inventory/visoft/artifacts/neo/neo.crt
```

The signed certificate (`neo.crt`) is stored in the `inventory/visoft/artifacts/neo` directory.

### 4. Configure Kubernetes Cluster

Set the Kubernetes cluster details using `kubectl`. Replace the server IP (`10.4.4.125`) and port (`6443`) as per your cluster's configuration:

```bash
kubectl config set-cluster visoft-cluster --server=https://10.4.4.125:6443 --certificate-authority=inventory/visoft/artifacts/ca.crt --embed-certs=true
```

This command configures the `visoft-cluster` to communicate securely using the CA certificate.

### 5. Set Credentials for Neo

Configure the credentials for the `neo` user, using the `neo.crt` and `neo.pem` files:

```bash
kubectl config set-credentials neo --client-certificate=inventory/visoft/artifacts/neo/neo.crt --client-key=inventory/visoft/artifacts/neo/neo.pem --embed-certs=true
```

This command sets the credentials for the `neo` user.

### 6. Set Context for Visoft

Set the context to use the `visoft-cluster` with the `neo` user, and configure the namespace to `neo`:

```bash
kubectl config set-context visoft --cluster=visoft-cluster --user=neo --namespace=neo
```

### 7. Switch to Visoft Context

Finally, switch to the `visoft` context to use the configured settings:

```bash
kubectl config use-context visoft
```

This completes the setup process. You can now interact with your Kubernetes cluster using the `neo` user and the `visoft` context.

---

By following these steps, you have successfully generated SSL certificates and configured Kubernetes with the appropriate credentials for the `neo` user in the `visoft` cluster.

For further details, refer to the official Kubernetes [documentation](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/).
