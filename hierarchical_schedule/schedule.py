from web3 import Web3
import os
import json
import sys
import random
import time

Provider = "http://127.0.0.1:30306"

web3 = Web3(Web3.HTTPProvider(Provider, request_kwargs={'timeout': 99999999}))
print(web3.isConnected())

account = web3.eth.accounts[0]

path = "./hierarchical_schedule.sol"

nameInfo = os.popen("solc --bin --abi {}".format(path)).read()
lines = nameInfo.split('\n')

addr = None
with open("tmpaddr.txt") as f:
    addr = f.read()
abi = json.loads(lines[5])

def getContract(addr, abi):
    c = web3.eth.contract(address=addr, abi=abi)
    return c

con = getContract(addr, abi)

# ==== 创建新账户 ====
# myAccount = web3.eth.account.create('put some extra entropy here')
# myAddress = myAccount.address
# ==== ======== ====

T = 1

for i in range(10):
    timeList = []
    count = T


    while count > 0:
        start = time.time()
        con.functions.scheduleParallel(200, 1, 200).call()
        timeList.append(time.time() - start)

        # os.popen("geth --exec \"miner.start()\" attach {}".format(Provider)).read()
        # start = time.time()
        # tx_hash = con.functions.wait().transact({
        #     # 'nonce': web3.eth.getTransactionCount(account) + i,
        #     #'gas': 4700000,
        #     #'gaslimit' : 0xffffffffffffffff,
        #     #'gasPrice': web3.toWei('1', 'gwei'),
        #     #'gasPrice': 1000000000,
        #     'from': account
        # })
        # web3.eth.wait_for_transaction_receipt(tx_hash)
        # timeList.append(time.time() - start)
        # os.popen("geth --exec \"miner.stop()\" attach {}".format(Provider)).read()

        # start = time.time()
        # con.functions.scheduleParallel(100, 1).call()
        # timeList.append(time.time() - start)

        count -= 1
    print(timeList)