import json
from web3 import Web3
import os

web3 = Web3(Web3.HTTPProvider('http://127.0.0.1:30306'))
print(web3.isConnected())

account = web3.eth.accounts[0]

path = "contracts/Fib.sol"

nameInfo = os.popen("solc --bin --abi {}".format(path)).read()
lines = nameInfo.split('\n')

bin = lines[3]
abi = json.loads(lines[5])
print(bin)
print(abi)

newContract = web3.eth.contract(bytecode=bin, abi=abi)

# # 发起交易部署合约
option = {'from': account, 'gas': 1000000}
# web3.geth.personal.unlock_account(account, '123')
tx_hash = newContract.constructor([b'dog', b'cat', b'bird']).transact(option)

# # 等待挖矿使得交易成功
tx_receipt = web3.eth.waitForTransactionReceipt(tx_hash)
print(tx_receipt.contractAddress)

