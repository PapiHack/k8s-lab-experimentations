# Steps for NFS Server Setup (Ubuntu Server 22.04.05 LTS)

## Package installation

- Install NFS Server

```bash
sudo apt install -y nfs-kernel-server
```

- Start NFS Server

```bash
sudo systemctl start nfs-kernel-server.server
```

- Look at NFS Server Status

```bash
sudo systemctl status nfs-kernel-server.server
```

## Configuration

- Edit `/etc/exports` file like this (replace the ip range or the directory as you wish)

```bash
/acme-data   192.169.1.25(rw,sync,no_subtree_check,no_root_squash)
```

- Create the directory mentioned in `/etc/exports` and adjust its permissions

```bash
sudo mkdir /acme-data
sudo chown nobody:nogroup /acme-data
sudo chmod -R 777 /acme-data
```

- Apply the config via:

```bash
sudo exportfs -a (ou -rav)
```

- Check the status of the NFS Server if everything is ok

- If you have a firewall enabled, you need to allow NFS traffic:

```bash
sudo ufw allow from <client_ip> to any port nfs
sudo ufw enable
sudo ufw status
```