# GETH='geth'
GETH='./go-ethereum/build/bin/geth'
ENNODE_TMP=$(${GETH} --exec "admin.nodeInfo.enode" attach http://127.0.0.1:30306)
ENNODE_TMP=${ENNODE_TMP/?discport=0/}
echo "$GETH --exec \"admin.addPeer($ENNODE_TMP)\" attach http://127.0.0.1:30307"
$GETH --exec "admin.addPeer($ENNODE_TMP)" attach http://127.0.0.1:30307