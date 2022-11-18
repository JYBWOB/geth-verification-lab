# GETH='geth'
GETH='./go-ethereum/build/bin/geth'
$GETH --datadir data1/ --networkid 15 --unlock 0 \
    --syncmode full \
    --password password.txt --nodiscover --rpc.evmtimeout 0 \
    --rpc.txfeecap 0 --rpc.gascap 0 --http --http.addr "0.0.0.0" \
    --http.port 30306 --http.vhosts "*" --http.api "admin,web3,eth,debug,personal,net" \
    --http.corsdomain "*" --snapshot=false \
    --allow-insecure-unlock console 2> node1.log