# GETH='geth'
GETH='./go-ethereum/build/bin/geth'
$GETH --datadir data2/ --networkid 15 \
    --syncmode full \
    --nodiscover --rpc.evmtimeout 0 \
    --rpc.txfeecap 0 --rpc.gascap 0 --http --http.addr "0.0.0.0" \
    --http.port 30307 --port 30304 --http.vhosts "*" \
    --http.api "admin,web3,eth,debug,personal,net,miner" \
    --http.corsdomain "*" --snapshot=false \
    --allow-insecure-unlock console 2> node2.log
