from web3 import Web3
from brownie import Contract, PrivateSK, config
from scripts import commonScripts

def main():
    address = "0xe463fe26E60611387358Bf18cC114D08a5cB01AA"
    url = "https://rinkeby.infura.io/v3/", config["infura"]["link"]
    web3 = Web3(Web3.HTTPProvider(url))
    print("Is connected to infura? ", web3.isConnected())
    account = commonScripts.getAccount()

    contract = Contract.from_abi("PrivateSK", address, PrivateSK.abi)
    contract.mintSKOP("0x705ADdE55cFEfF70FA8F29f191a57c4337aa13f3", "ipfs://QmZsWbe1TMyRc2g1D6kpTMVgEqtJnrzSu1DBbxoaH6hfk3", {"from" : account, "value" : 150000000000000000})
    print("URI: " + contract.tokenURI(0))
    contract.withdraw({"from" : account})