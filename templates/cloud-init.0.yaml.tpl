#cloud-config

apt:
  sources:
    docker.list:
      source: deb [arch=arm64] https://download.docker.com/linux/ubuntu $RELEASE stable
      keyid: 9DC858229FC7DD38854AE2D88D81803C0EBFCD88
    kubernetes.list:
      source: deb https://apt.kubernetes.io/ kubernetes-xenial main
      keyid: A362B822F6DEDC652817EA46B53DC80D13EDEF05

package_update: true
package_upgrade: true

packages:
  - build-essential 
  - openssl 
  - libssl-dev 
  - libz-dev 
  - libreadline-dev 
  - unzip 
  - lua5.1 
  - luarocks
  - ca-certificates
  - lsb-release
  - gnupg
  - screen
  - rsync
  - git
  - curl
  - docker-ce
  - docker-ce-cli
  - containerd.io
  - docker-compose-plugin
  - python3-pip
  - python3-dev
  - python3-selinux
  - python3-setuptools
  - python3-venv
  - python3-aiohttp 
  - libffi-dev
  - gcc
  - libssl-dev
  - apt-transport-https

groups:
  - docker
system_info:
  default_user:
    groups: [docker]

runcmd:
  - apt-get update -y
  - apt-get install kubeadm kubectl kubelet -y
  - wget -qO- https://get.helm.sh/helm-v3.10.3-linux-arm64.tar.gz | tar xvz -C /usr/local/bin
  - mv /usr/local/bin/linux-arm64/helm /usr/local/bin/
  - rm -rf /usr/local/bin/linux-arm64
  - sed -i 's/disabled_plugins/#disabled_plugins/g' /etc/containerd/config.toml
  - systemctl restart containerd
  - iptables -P INPUT ACCEPT
  - iptables -P FORWARD ACCEPT
  - iptables -P OUTPUT ACCEPT
  - iptables -t nat -F
  - iptables -t mangle -F
  - iptables -F
  - iptables -X
  - kubeadm init --pod-network-cidr=192.168.0.0/16
  - mkdir - p /home/ubuntu/.kube
  - cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
  - chown -R ubuntu:ubuntu /home/ubuntu/.kube/config
  - sleep 2
  - sudo -u ubuntu kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/tigera-operator.yaml
  - sleep 2
  - sudo -u ubuntu kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/custom-resources.yaml
  - sleep 180
  - sudo -u ubuntu kubectl taint nodes --all node-role.kubernetes.io/control-plane-
  - sleep 5
  - cd /home/ubuntu && git clone ${dsb_repo} 
  - "sed -i '0,/name: nginx-thrift/a type: NodePort' /home/ubuntu/DeathStarBench/socialNetwork/helm-chart/socialnetwork/charts/nginx-thrift/values.yaml"
  - "sed -i '/    targetPort: 8080/a \\ \\ \\ \\ nodePort: 32080' /home/ubuntu/DeathStarBench/socialNetwork/helm-chart/socialnetwork/charts/nginx-thrift/values.yaml"
  - "sed -i '/    targetPort: {{ .targetPort }}/a \\ \\ \\ \\ nodePort: {{ .nodePort }}' /home/ubuntu/DeathStarBench/socialNetwork/helm-chart/socialnetwork/templates/_baseService.tpl"
  - chown -R ubuntu:ubuntu /home/ubuntu
  - cd /home/ubuntu/DeathStarBench/socialNetwork/helm-chart/ && chmod +x create delete describe install installdefault logs watch
  - sudo -u ubuntu /home/ubuntu/DeathStarBench/socialNetwork/helm-chart/create
  - sudo -u ubuntu sed -i 's/10m0s/25m0s/g' /home/ubuntu/DeathStarBench/socialNetwork/helm-chart/install
  - sudo -u ubuntu /home/ubuntu/DeathStarBench/socialNetwork/helm-chart/install
# - sudo -u ubuntu python3 /home/ubuntu/DeathStarBench/socialNetwork/scripts/init_social_graph.py --graph=socfb-Reed98 --ip=10.0.10.236 --port=32080
