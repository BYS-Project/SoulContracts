from web3 import Web3
from brownie import Contract, SoulKey, Soul, config
from scripts import commonScripts

def main():
    # Addresses
    myAddress = "0x705ADdE55cFEfF70FA8F29f191a57c4337aa13f3"
    soulAddress = "0x2afea04AC8b511a0C13e58B084D7ABD5285FD4F7"
    soulKeyAddress = "0x6751d1E26934e9066eA9C58d0034e3B663b7b222"
    # Web3 Connection
    url = "https://rinkeby.infura.io/v3/", config["infura"]["link"]
    web3 = Web3(Web3.HTTPProvider(url))
    print("Is connected to infura? ", web3.isConnected())
    # Getting the account
    account = commonScripts.getAccount()
    # Getting the Smart Contracts
    soul = Contract.from_abi("Soul", soulAddress, Soul.abi)
    keys = Contract.from_abi("SoulKey", soulKeyAddress, SoulKey.abi)
    # Calling functions
    """
    keys.setBuyable(True, {"from" : account})
    soul.setBuyable(True, {"from" : account})
    keys.mintSKN({"from" : account, "value" : 50000000000000000})
    keys.mintSKOP({"from" : account, "value" : 150000000000000000})
    keys.setSoulContract(soulAddress, {"from" : account})
    soul.setSoulKeyContract(soulKeyAddress, {"from" : account})
    print("Owner sooner: ", keys.ownerOf(0))
    """
    # keys.convertToSoul(1, {"from" : account})
    print("Owner later: ", keys.ownerOf(0))
    print("Supply: ", keys.getSupply(), "(Normal: ", keys.getNormalMinted(), " Op: ", keys.getOpMinted(), ")")
    print("Meta: ", keys.tokenURI(0))
    print("Key type: ", keys.keyType(0, {"from" : account}))
    print("Meta: ", keys.tokenURI(1))
    print("Key type: ", keys.keyType(1, {"from" : account})) 

    print("URI 2: ", soul.tokenURI(2))
    # print("Soul 0 URI: ", soul.tokenURI(0))   
    # keys.withdraw({"from" : account})