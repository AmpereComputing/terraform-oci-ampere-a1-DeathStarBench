#!/usr/bin/env bash
exec &> $HOME/www/index.html
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
cd /home/ubuntu/DeathStarBench/socialNetwork/wrk2
echo "<html>
<body>
<h1>DeathStarBench WRK2 Results</h1>
<table><tr><td>"
./wrk -t ${w_threads} -c ${w_conns} -d ${w_duration} -L -s ./scripts/social-network/compose-post.lua http://${dsb_private_ip}:32080/wrk2-api/post/compose -R ${w_rps}
echo "
</tr></td>
</table>
</body>
</html>
"
