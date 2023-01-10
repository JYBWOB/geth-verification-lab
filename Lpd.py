from web3 import Web3
import os
import json

Provider = "http://127.0.0.1:30306"

web3 = Web3(Web3.HTTPProvider(Provider, request_kwargs={'timeout': 99999999}))
print(web3.isConnected())

account = web3.eth.accounts[0]

path = "contracts/Lpd.sol"

nameInfo = os.popen("solc --bin --abi {}".format(path)).read()
lines = nameInfo.split('\n')

# prime = 769 * 839  # 25ms
# prime = 1009 * 1013 # 27ms
prime = 2351 * 2609 # 130ms
# prime = 3253 * 3257 # 240ms

sendTime = 10
addr = ""
with open("tmpaddr.txt") as f:
    addr = f.read()
abi = json.loads(lines[5])

with open("res.csv", 'w') as f:
    f.truncate(0)

def getContract(addr, abi):
    c = web3.eth.contract(address=addr, abi=abi)
    return c

con = getContract(addr, abi)

# ==== 创建新账户 ====
# myAccount = web3.eth.account.create('put some extra entropy here')
# myAddress = myAccount.address
# ==== ======== ====

wait_hash = con.functions.setPrime(prime).transact({
            # 'nonce': web3.eth.getTransactionCount(account) + i,
            #'gas': 4700000,
            #'gaslimit' : 0xffffffffffffffff,
            #'gasPrice': web3.toWei('1', 'gwei'),
            #'gasPrice': 1000000000,
            'from': account
        })

info = os.popen("geth --exec \"miner.start()\" attach {}".format(Provider)).read()
print("miner start")
print("wait for receipt...")
web3.eth.wait_for_transaction_receipt(wait_hash)
print("receive receipt")
info = os.popen("geth --exec \"miner.stop()\" attach {}".format(Provider)).read()
print("miner stop")

for i in range(sendTime):
    print(i)
    con.functions.exec().call()