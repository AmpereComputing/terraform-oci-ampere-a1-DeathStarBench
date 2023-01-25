git clone ${dsb_repo}
rm -rf ~/DeathStarBench/socialNetwork/wrk2/deps/luajit
cd ~/DeathStarBench/socialNetwork/wrk2/deps/
git clone https://luajit.org/git/luajit.git
cd luajit
make
sudo make install
sudo ln -sf luajit-2.1.0-beta3 /usr/local/bin/luajit
cd ~/DeathStarBench/socialNetwork/wrk2
sed -i 's/#include <x86intrin.h>/#ifdef __x86_64__\n #include <x86intrin.h>\n#endif\n/g' src/hdr_histogram.c
make

:
