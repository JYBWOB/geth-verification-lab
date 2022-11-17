from web3 import Web3
import os
import json


web3 = Web3(Web3.HTTPProvider("http://127.0.0.1:30306", request_kwargs={'timeout': 99999999}))
print(web3.isConnected())

account = web3.eth.accounts[0]

path = "contracts/Fib.sol"

nameInfo = os.popen("solc --bin --abi {}".format(path)).read()
lines = nameInfo.split('\n')

sendTime = 300
addr = "0xeB30eEeF24F7aAC488d706C2Cffcae71DBbb3349"
abi = json.loads(lines[5])

def getContract(addr, abi):
    c = web3.eth.contract(address=addr, abi=abi)
    return c

con = getContract(addr, abi)

pending = []
for i in range(sendTime):
    print(i)
    tx_hash = con.functions.exec(i, 50000).transact({
                'from': account,
                # 'nonce': web3.eth.getTransactionCount(account) + i,
                'gas': 0xfffff + i,
                'gasPrice': web3.toWei('21', 'gwei')
            })
    pending.append(tx_hash)
print("wait for receipt...")
for i in range(sendTime):
    web3.eth.wait_for_transaction_receipt(pending[i])
    print("receive receipt {}".format(i))

