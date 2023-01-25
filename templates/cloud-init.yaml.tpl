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
 - luarocks install luasocket
 - cd /home/ubuntu && git clone ${dsb_repo}
 - chown -R ubuntu:ubuntu /home/ubuntu

write_files:
  - content: |
      file=io.open("path.txt","w")
      io.output(file)
      io.write(string.format("'"..package.path.."'"))
      io.close(file)
      cfile=io.open("cpath.txt","w")
      io.output(cfile)
      io.write(string.format("'"..package.cpath.."'"))
      io.close(cfile)
    path: /home/ubuntu/luapaths.lua
  - content: |
      #!/usr/bin/env bash
      sudo luarocks install luasocket
      lua luapaths.lua
      export LUA_PATH=$(cat path.txt)
      export LUA_CPATH=$(cat cpath.txt)
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
      # rm -rf path.txt cpath.txt luapaths.lua
      LUA_PATH=(command lua -e "print(package.path..';$${PWD}/DeathStarBench/socialNetwork/wrk2/deps/luajit/src/?.lua')")
      cd DeathStarBench/socialNetwork/wrk2/deps
      rm -rf luajit
      git clone https://luajit.org/git/luajit.git
      cd luajit
      make
      sudo make install
      sudo ln -sf luajit-2.1.0-beta3 /usr/local/bin/luajit
      cd ../../
      # Build for wrk fails for x86. Use #ifdef to skip this header for aarch64
      sed -i 's/#include <x86intrin.h>/#ifdef __x86_64__\n #include <x86intrin.h>\n#endif\n/g' src/hdr_histogram.c
      # Build wrk2
      make
    path: /home/ubuntu/build_lua_wrk2.sh
    permissions: '0775'
