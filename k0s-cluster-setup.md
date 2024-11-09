# Kubernetes cluster setup with k0s

## SSH Keygen

🚨 À faire depuis notre host afin de pouvoir accéder aux noeuds du cluster

- Génération d'une nouvelle paire de clé dédiée

```bash
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa_k0s
```

- Puis copier la clé publique (dans notre cas ce sera `id_rsa_k0s.pub`) au niveau des noeuds du cluster () afin de pouvoir y accéder via `ssh`.

```bash
ssh-copy-id -i ~/.ssh/id_rsa_k0s <root-user>@IP
```
[Faire `yes` pour la question du fingeprint puis renseigner le mdp à la prochaine question]

- Pour se connecter à un des noeuds du cluster via ssh faire ceci:
```bash
ssh -i ~/.ssh/id_rsa_k0s <root-user>@IP
```

### 🚨🚨🚨 Si vous n'avez pas les accès root

- Au niveau de chaque noeud, changer le mot de passe du user root avec:

```bash
sudo passwd root
```
Saisissez le nouveau de mdp et confirmer puis vérifier avec la commande suivante afin de vous connecter en tant que root avec le nouveau mdp créé :
```bash
sudo -
```

- Activer l'accès root via ssh sur tous les noeuds:
```bash
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart sshd
systemctl reload sshd
systemctl status sshd
```


## Install k0sctl cli

🚨 À installer sur notre host pour bootstraper le cluster kube

- Récupérer le binary de la dernière version au niveau des [releases](https://github.com/k0sproject/k0sctl/releases) (dans notre cas `v0.19.2`)
```bash
wget https://github.com/k0sproject/k0sctl/releases/download/v0.19.2/k0sctl-linux-amd64 -O k0sctl
```

- Rendre le script executable

```bash
sudo chmod u+x k0sctl
```

- Déplacer le script vers le répértoire des binaires exécutables

```bash
sudo mv k0sctl /usr/local/bin
```

- Vérifier que tout est Ok avec

```bash
k0sctl version
```

## Cluster bootstraping & configuration

- Création du fichier de config `k0sctl`

```bash
k0sctl init > k0sctl.yaml
```

- Editer ce fichier en fonction de vos besoins en renseignant les bons user/@IP et le chemin vers votre clé privé SSH (cf `k8s/k0ctl.yaml`).
  Préciser également si besoin, l'interface réseau à utiliser pour chaque noeud (champ `privateInterface`).

## Déployer le cluster kubernetes

- Exécuter la commande suivante pour déployer le cluster

```bash
k0sctl apply --config k0sctl.yaml
```

- Si la commande échoue avec des erreurs par exemple,

    - détruire ce qui a été effectué avec :

    ```bash
    k0sctl reset --config k0sctl.yaml
    ```

    - se connecter sur chaque noeuds et redémarrer le service ssh :

    ```bash
    sudo service sshd restart
    sudo service sshd reload
    sudo service sshd status
    ```

- Si tout est bon, récupérer le fichier `kubeconfig` afin de pouvoir accéder au cluster:

```bash
k0sctl kubeconfig --config k0sctl.yaml > ~/.kube/kubeconfig
```
Créer le repertoire `~/.kube` s'il n'existe pas. Si vous avez déjà un kubeconfig, faire un backup de ce dernier avant de le remplace par le nouveau.


