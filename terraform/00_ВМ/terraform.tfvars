count_vm = 1

vm=[
      {name = "vm1"
      image = "fd82nvvtllmimo92uoul"   # ubuntu 22.04
      cpu = 2
      core_fraction = 20
      ram = 4
      disk_size = 16
      allow_stopping = true
      platform = "standard-v1"
      zone = "ru-central1-a"
      preemptible = true
      nat = true
      cmd =[
        "wget https://hashicorp-releases.yandexcloud.net/terraform/1.10.5/terraform_1.10.5_linux_amd64.zip",
        "apt install -y unzip",
        "unzip terraform_1.10.5_linux_amd64.zip -d /root",
        "mv /root/terraform /bin/trr",
        "curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash",
        "chmod 400 /root/.ssh/id_ed25519",
        "git clone -b terraform-03 https://github.com/DmitryIll/terraform-uprav-constr.git",        
        "cp terraform-uprav-constr/src/.terraformrc /root/",
      #   "trr init",
      ]},
]

      #   "git clone -b terraform-03 https://github.com/DmitryIll/terraform-uprav-constr.git",
      #   "sudo apt-add-repository -y ppa:ansible/ansible",
      #   "sudo apt update",
      #   "sudo apt install -y ansible",
      #   "cd terraform-uprav-constr/src/",

#         "sudo apt-get update",
#         "sudo apt-get install -y ca-certificates curl gnupg",
#         "sudo install -m 0755 -d /etc/apt/keyrings",
#         "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
#         "sudo chmod a+r /etc/apt/keyrings/docker.gpg",
#         "echo \"deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \"$(. /etc/os-release && echo \"$VERSION_CODENAME\")\" stable\" |  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
#         "sudo apt-get update",
#         "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
#     #    "sudo chmod +x /root/proxy.yaml",
#         "apt install -y mariadb-client-core-10.6 ",