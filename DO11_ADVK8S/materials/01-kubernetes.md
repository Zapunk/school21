# Kubernetes

## Kubernetes distributions

There are two options when setting up a Kubernetes environment: Vanilla Kubernetes and Managed Kubernetes. With Vanilla Kubernetes, the software team must download the Kubernetes source code and compile the environment on the machine. Managed Kubernetes, on the other hand, comes pre-compiled and pre-configured with additional tools that improve or add new features to the Kubernetes environment. These features include storage, security, deployment, and monitoring. Managed Kubernetes is also known as a Kubernetes distribution.

Some Kubernetes distributions are designed to use fewer resources, such as **Minikube** and **k3s**.

Lightweight Kubernetes distributions are a great choice for people who are unfamiliar with Kubernetes and want to set up an environment on their own computer where they can experiment, thanks to two factors: low resource requirements and ease of use.

### Minikube

Minikube is a simplified Kubernetes distribution developed as part of the main Kubernetes project. It runs on Linux, Windows, and macOS. If you run it outside of a Linux environment, it uses virtualization to set up your clusters. On Linux, however, you can use virtualization or run clusters directly on bare hardware.

By default Minikube creates a one-node cluster by default, but you can set up more nodes by using the `--nodes` flag when running Minikube.

Minikube's main advantages are that it is extremely lightweight and easy to install and use.

However, it is intended only for testing. It is not a practical solution for running production-level clusters.

### k3s

K3s is a simplified Kubernetes distribution developed by Rancher. It can run on any operating system, including Linux, Windows, and macOS.

Setting up a single-node cluster is relatively easy. Simply download a binary from GitHub and run the single-node cluster with the command:

`sudo server k3s`

However, if you want to add nodes to your cluster, you must configure k3s on each node separately and join it to your cluster. K3s is more difficult to use than Minikube, which has a simpler process for adding nodes.

K3s, on the other hand, is designed as a complete, production-ready Kubernetes distribution that is lightweight. Rancher designed k3s specifically for use cases involving infrastructures such as the Internet of Things (IoT) and peripherals.

## Creating your own k3s cluster

The proposed cluster will consist of three nodes: two workers and one master node. When installing k3s on system worker nodes, it is important to remember that the master node address and a special token confirming the worker's access to the system must also be provided.

### Ingress Controller

The k3s system comes pre-installed with an ingress controller for accessing the system from outside the cluster. However, it is not necessary to use it. An alternative solution is Nginx, which has all the necessary tools to make the cluster accessible.

The Nginx ingress controller already exists in a ready-made form because, when using standard Nginx, there is no logic to rebuild the controller, and you would have to "manually" change parameters to access new services externally.

Note that the standard Ingress controller and the Nginx controller are functionally equivalent, i.e., it is not necessary to change the configuration of the system components.

### PV, PVC data storage

Persistent volumes are an important part of the Kubernetes infrastructure. They allow for flexible storage management for services and comfortable management with the PersistentVolume (PV) controller. This includes managing the amount of resources spent, access rights, and the expansion and contraction of used volumes. It also includes configuring backups with solutions developed by the Kubernetes community.

### Security

First, tools were developed to create internal data networks that can be isolated from each other to ensure security. The main goal is to protect the system from third-party intruders and support the software development process to avoid using "workarounds" to access core services directly.

Network restrictions are usually set at the namespace level. This means that, for each namespace, an isolated network should be allocated, and then some system components should be made available in other networks as well.

In addition to the networking problem, there is the problem of administering access data, such as tokens, certificates, and passwords. In addition to protecting against the risk of intruders obtaining sensitive data, there is also the risk of interference from within. Many well-known companies have recently experienced theft of access to third-party services and misuse of obtained data.

Kubernetes offers Secrets Management to centralize access to such data. This tool is similar to how PV and PVC work in that it provides access to secrets and collects information about how they are used. It also integrates the process of obtaining secrets into deployment. Therefore, when deploying a service that requires a secret, the service will not start without the necessary information.

### Cert-Manager

Cert-Manager is an automated certificate management utility for Kubernetes. It simplifies and automates the process of generating, issuing, and updating Transport Layer Security (TLS) certificates in a Kubernetes cluster. Cert-Manager supports various certificate providers, including Let's Encrypt, Venafi, and HashiCorp Vault. You can configure it to automatically generate certificates for Kubernetes applications based on Kubernetes resources, such as Ingress. It can also automatically update certificates when they expire. Cert-Manager also integrates with the Kubernetes orchestrator and its API, facilitating certificate management.

### Operators

The Operator's purpose is to provide users with an API that allows them to manage multiple entities of a stateful application in a Kubernetes cluster without having to think about what's under the hood, such as what data is needed and how to use it or what commands still need to be executed to maintain the cluster. In fact, the Operator is designed to simplify working with applications within clusters by automating operational tasks that were previously done manually.

For example, the Prometheus Operator provides Kubernetes deployment and management of Prometheus and related monitoring components. This project aims to simplify and automate the configuration of the Prometheus-based monitoring stack for Kubernetes clusters.

Therefore, if an automated deployment of a multi-component service or stack is needed, operators should be used to independently monitor the deployment and operation of such systems.