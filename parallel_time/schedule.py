from web3 import Web3
import os
import json
import sys
import random

Provider = "http://127.0.0.1:30306"

web3 = Web3(Web3.HTTPProvider(Provider, request_kwargs={'timeout': 99999999}))
print(web3.isConnected())

account = web3.eth.accounts[0]

path = "./parallel_schedule.sol"

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

for i in range(10):
    con.functions.scheduleParallel(1000, 40).call()