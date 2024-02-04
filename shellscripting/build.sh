https_proxy=$HTTPS_PROXY wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
sleep 10
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo http_proxy=$HTTP_PROXY apt update && sudo http_proxy=$HTTP_PROXY apt install -y terraform ansible sshpass
sleep 10
mkdir -p home/pslearner/terraform/docker
cat <<EOF > /home/pslearner/terraform/docker/main.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}
provider "docker" {}
EOF
sudo https_proxy=$HTTP_PROXY terraform -chdir=/home/pslearner/terraform/docker init
sudo chown  -R pslearner. /home/pslearner/terraform