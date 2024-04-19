# TP4 CREATION MACHINE VIRTUEL AVEC TERRAFORM SUR AZURE

## Installation de Terraform

Assurez-vous que votre système est à jour et que vous avez installé les 
paquets `gnupg`, `software-properties-common` et `curl`. Vous utiliserez 
ces paquets pour vérifier la signature GPG de HashiCorp et installer le
référentiel de paquets Debian de HashiCorp.

```shell
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
```

Install the HashiCorp GPG key.

```shell
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
```

Verify the key's fingerprint.

```shell
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
```

Ajoutez le référentiel officiel de HashiCorp à votre système.
La commande ```lsb_release -cs``` trouve le nom de code de la 
version de distribution de votre système actuel, tel que
buster, groovy ou sid
```shell
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
tee /etc/apt/sources.list.d/hashicorp.list
```
Téléchargez les informations sur le package depuis HashiCorp.
```shell
sudo apt update
```
Installez Terraform à partir du nouveau référentiel.
```shell
sudo apt-get install terraform
```

## installation de AZURE CLI et connection 
Mettez à jour les informations du package :
```shell
sudo apt update
```
Installez les dépendances nécessaires pour l'installation de Azure CLI :
```shell
sudo apt install ca-certificates curl apt-transport-https lsb-release gnupg
```
Téléchargez et importez la clé GPG Microsoft pour vérifier les packages :
```shell
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
```
Configurez le référentiel de packages Azure CLI:
```shell
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
```
Mettez à jour les informations du package une fois de plus :
```shell
sudo apt update
```
Installez Azure CLI :
```shell
sudo apt install azure-cli
```

Connection :
```shell
az login
```

## creation de la VM
le fichier ```main.tf``` déploie une machine virtuelle Azure (VM) dans le reseau
```network-tp4``` et configure une adresse IP publique. Ce fichier lance l'installation
de python sur la machine une fois crée car l'installation de docker me genere des conflits.
Il utilise aussi le fichier ```variables.tf``` pour 
un code plus compact.

Pour formater correctement le code Terraform, nous devons exécuter la commande suivante
dans votre terminal :

```bash
terraform fmt
```
## lancement
Initialisez votre répertoire learn-terraform-azure dans 
votre terminal. Les commandes terraform fonctionneront avec 
n'importe quel système d'exploitation. Votre sortie devrait 
ressembler à celle ci-dessous.
```shell
terraform init
```
cette variable d'environnement nous permet d'indiquez à Terraform
de ne pas tenter de s'enregistrer automatiquement auprès des 
fournisseurs Azure lors de l'exécution de vos scripts Terraform
```shell
export ARM_SKIP_PROVIDER_REGISTRATION=true
```
validation et application des codes :
```shell
terraform validate
```
```shell
terraform apply
```
après cette commande, notre machine virtuelle est créer sur Azure et
nous pouvons verifier que tout fonctionne bien avec : 
```shell
chmod 600 id_rsa
ssh -i id_rsa devops@52.143.170.87 cat /etc/os-release
```
avant de détruire nos ressources nous retirer le sous reseau de notre state
car nous n'avons pas de droit de modification dessus
```shell
terraform state rm azurerm_subnet.internal
terraform destroy
```


