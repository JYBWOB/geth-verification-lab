from web3 import Web3
import os
import json
import sys
import random

sendTime = 1000

Provider = "http://127.0.0.1:30306"

web3 = Web3(Web3.HTTPProvider(Provider, request_kwargs={'timeout': 99999999}))
print(web3.isConnected())

account = web3.eth.accounts[0]

path = "./total.sol"

nameInfo = os.popen("solc --bin --abi {} -o compile --overwrite".format(path)).read()
lines = nameInfo.split('\n')

addr = "0x695af2772b5E711b9c63E62Bd60e44F0D7270C86"
abi = {}
with open("compile/Schedule.abi") as f:
    abi = json.loads(f.read())

def getContract(addr, abi):
    c = web3.eth.contract(address=addr, abi=abi)
    return c

con = getContract(addr, abi)

# ==== 创建新账户 ====
# myAccount = web3.eth.account.create('put some extra entropy here')
# myAddress = myAccount.address
# ==== ======== ====


def random_hex(length):
    result = hex(random.randint(0,16**length))
    if(len(result)<length):
        result = '0'*(length-len(result))+result
    try:
        result = Web3.toChecksumAddress(result)
    except:
        result = random_hex(length)
    return result

resourceList = None
with open("data.json") as f:
    resourceList = json.load(f)["resource"]

print(resourceList)

pending = []
for i in range(sendTime):
    _in_addr = random_hex(40)
    print(_in_addr)
    tx_hash = con.functions.addResource(_in_addr, resourceList[i]).transact({
                # 'nonce': web3.eth.getTransactionCount(account) + i,
                'gas': 4700000,
                'gaslimit' : 0xffffffffffffffff,
                'gasPrice': web3.toWei('1', 'gwei'),
                #'gasPrice': 1000000000,
                'from': account
            })
    pending.append(tx_hash)

info = os.popen("geth --exec \"miner.start()\" attach {}".format(Provider)).read()
print("miner start")
print("wait for receipt...")
for i in range(sendTime):
    web3.eth.wait_for_transaction_receipt(pending[i])
    print("receive receipt {}".format(i))
info = os.popen("geth --exec \"miner.stop()\" attach {}".format(Provider)).read()
print("miner stop")