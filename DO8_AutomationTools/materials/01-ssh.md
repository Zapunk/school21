# SSH

**SSH (Secure Shell)** is a secure application-layer protocol used to connect to a remote machine. It is the primary method of connecting remotely to Unix-like computers.

There are two approaches to connecting to a machine via SSH:

1. Direct connection via password.
2. Private key connection.

To connect via password, enter the command `ssh <ip address of remote machine>`, then enter the password in the dialog box. The connection is now established. When the connection is first established, the connecting host receives a unique fingerprint for identification purposes. Once connected, the user has access to the shell console on the remote machine in their terminal.

*Note: virtual machines may disable password connections by default. Check the `/etc/ssh/sshd_config` file for the `PasswordAuthentication yes` line. If necessary, run the `service sshd restart` command to make changes to the configuration. The default password is usually "vagrant"*.

To connect by key, first create a private and public key pair `ssh-keygen -C <comment>` specifying the path to the file with the private key and a possible passphrase. The private key is secret, and the public key (.pub extension) must be sent to the connecting machine with the command: `ssh-copy-id -i <path to the file with the public key> <ip address of the remote host>`. The system will then prompt you for a connection password, which you will only need to enter once. From that point on, the private key will be used for the default connection via the command `ssh <ip address of the remote machine>`.