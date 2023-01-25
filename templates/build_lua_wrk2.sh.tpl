      #!/usr/bin/evn bash
      lua luapaths.lua
      export LUA_PATH=$(cat path.txt)
      export LUA_CPATH=$(cat cpath.txt)
      rm -rf path.txt cpath.txt luapaths.lua
      LUA_PATH=(command lua -e "print(package.path..';${PWD}/DeathStarBench/socialNetwork/wrk2/deps/luajit/src/?.lua')")
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
