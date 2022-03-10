from web3 import Web3
from brownie import Contract, SoulKey, Soul, config
from scripts import commonScripts

def main():
    address = "0xc76135c1c49AF52d2F8996761802Bb6272B4d5A3"
    #address = "0xE296fCAa004A3607A94C383ec0D1940b764e4C51"
    url = "https://rinkeby.infura.io/v3/", config["infura"]["link"]
    web3 = Web3(Web3.HTTPProvider(url))
    #web3 = Web3(Web3.HTTPProvider("HTTP://127.0.0.1:7545"))
    print("Is connected to infura? ", web3.isConnected())
    account = commonScripts.getAccount()

    contract = Contract.from_abi("SoulKey", address, SoulKey.abi)
    print("Roba: ", contract.getNormalMinted())
    print("Roba: ", contract.getOPMinted())
    #contract.setNormalDefaultURI("ipfs://QmVGQETn37xSpBiZKjWgHLKdmyQCBT3e2QFuxj9LEGT6g8", {"from" : account})
    #contract.mintSKN("0x705ADdE55cFEfF70FA8F29f191a57c4337aa13f3", "", {"from" : account, "value" : 50000000000000000})
    #contract.mintSKOP("0x08c27130cd2717c70A9552EC30739BF82C06FbA1", "", {"from" : account, "value" : 150000000000000000})
    print("URI: " + contract.tokenURI(0))
    #contract.withdraw({"from" : account})
    contract.transferFrom("0x705ADdE55cFEfF70FA8F29f191a57c4337aa13f3", "0xba28DA2b8d71E21fdf8cb12A2b940405085c3809", 0, {"from" : account})
