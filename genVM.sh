#L=Liste ; N=Nouvelle ;  S=Supprimer ; D=Démarrer ; A=Arrêt.
cd /home/fournm31/VirtualBoxVMs

#Listage des VMs
if [ $1 == L ]
then 
	VBoxManage list vms
fi 

#Création d'une VM
if [ $1 == N ]
then
	
	if [ -e $1 ]
	then
		rm -rf $1 ; echo "VM déjà existante : suppresion en cours..." ; sleep 5
	fi

	#Création d'une VM avec comme argument le nom de la machine
	VBoxManage createvm --name "$2" --ostype "Ubuntu" --register --basefolder "/home/fournm31/VirtualBoxVMs"
	
	#Paramètre de la VM
	VBoxManage modifyvm $2 --memory 1024 --vram 128

	#Paramètre réseau pour boot PXE
	VBoxManage modifyvm $2 --nic1 nat

	#Paramètrage du Disque Dur
	VBoxManage createmedium disk --filename /home/fournm31/VirtualBoxVMs/$2/$2_DISK.vdi --size 64000 --format VDI --variant Standard 
                
	VBoxManage storagectl "$2" --name "IDE" --add IDE  
	
	VBoxManage storageattach "$2" --storagectl "IDE" --port 0 --device 0 --type hdd --medium  "/home/fournm31/VirtualBoxVMs/$2/$2_DISK.vdi"
fi

#Suppression d'une VM
if [ $1 == S ]
then
	VBoxManage unregistervm "$2" --delete ; echo "VM supprimé !"
fi

#Mise en fonction d'une VM
if [ $1 == D ]
then
	VBoxManage startvm "$2"
fi

#Mise à l'arrêt d'une VM
if [ $1 == A ]
then
	VBoxManage controlvm $2 poweroff
fi
