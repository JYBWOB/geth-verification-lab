import json
from web3 import Web3
import os

Provider = "http://127.0.0.1:30306"

web3 = Web3(Web3.HTTPProvider(Provider))
print("web3 is connected: ", web3.isConnected())

account = web3.eth.accounts[0]

path = "./hierarchical_schedule.sol"

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
tx_hash = newContract.constructor().transact(option)
print("deploy succeed, wait for miner")


info = os.popen("geth --exec \"miner.start()\" attach {}".format(Provider)).read()
print("miner start")
# # 等待挖矿使得交易成功
tx_receipt = web3.eth.waitForTransactionReceipt(tx_hash)
info = os.popen("geth --exec \"miner.stop()\" attach {}".format(Provider)).read()
print("miner stop")
print(tx_receipt.contractAddress)
with open("tmpaddr.txt", "w") as f:
    f.write(tx_receipt.contractAddress)

