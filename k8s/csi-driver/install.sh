# Installation of kubernetes-csi driver (csi-driver-nfs)
curl -skSL https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/v4.9.0/deploy/install-driver.sh | bash -s v4.9.0 --

# Check created resources
# kubectl -n kube-system get pod -o wide -l app=csi-nfs-controller
# kubectl -n kube-system get pod -o wide -l app=csi-nfs-node

# Si les pods sont toujours en "ContainerCreating", créer au niveau de chaque noeuds les dossiers /var/lib/kubelet/pods et /var/lib/kubelet/plugins_registry