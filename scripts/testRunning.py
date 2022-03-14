from web3 import Web3
from brownie import Contract, SoulKey, Soul, config
from scripts import commonScripts

def main():
    # Addresses
    myAddress = "0x705ADdE55cFEfF70FA8F29f191a57c4337aa13f3";
    soulAddress = "0xD552b6e6613F9398a49114873ADb3a2264bcE83a"
    soulKeyAddress = "0x15b18566359DBc412EdDb678A00d002426461e03";
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
    #keys.setNormalDefaultURI("ipfs://QmVGQETn37xSpBiZKjWgHLKdmyQCBT3e2QFuxj9LEGT6g8", {"from" : account})
    #keys.mintSKN(myAddress, "", {"from" : account, "value": 50000000000000000})
    #keys.setSoul(soulAddress, {"from" : account})
    keys.convertToSoul(myAddress, 0, {"from" : account})
    #keys.withdraw({"from" : account});
    print("Normal keys minted: ", keys.getNormalMinted())