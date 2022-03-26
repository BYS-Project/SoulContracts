from web3 import Web3
from brownie import Contract, SoulKey, Soul, config
from scripts import commonScripts

def main():
    # Addresses
    myAddress = "0x705ADdE55cFEfF70FA8F29f191a57c4337aa13f3"
    utilsAddress = "0x67Bb75F4160766Cb9E55a18B577709B2aC2E2b9a"
    soulAddress = "0x25FaaC3B8AA4F257c9821F46C1F6f969882D9262"
    soulKeyAddress = "0x5fc4473400261C91cAd03a3c0840c197551BF86C"
    # Web3 Connection
    url = "https://rinkeby.infura.io/v3/", config["infura"]["link"]
    web3 = Web3(Web3.HTTPProvider(url))
    print("Is connected to infura? ", web3.isConnected())
    # Getting the account
    account = commonScripts.getAccount()
    # Getting the Smart Contracts
    soul = Contract.from_abi("Soul", soulAddress, Soul.abi)
    keys = Contract.from_abi("SoulKey", soulKeyAddress, SoulKey.abi)

    cond = True
    while(cond):
        print ("1) For minting Normal Key\n2) For minting OP Key\n3) Startup\n4)Owner of\n5)Get Supply\n6) Token URI\n7) Withdraw\n8)Key Type")
        opt = input("Enter the option: ")
        print("Opt: ", opt)
        print("\n----------\n")
        if(opt == "1"):
            qty = int(input("Specify the amount to mint: "))
            keys.mintSKN(qty, {"from" : account, "value" : qty * 50000000000000000})
        elif (opt == "2"):
            qty = int(input("Specify the amount to mint: "))
            keys.mintSKOP(qty, {"from" : account, "value" : qty * 150000000000000000})
        elif (opt == "3"):
            keys.setContractOnline(True, {"from" : account})
            soul.setContractOnline(True, {"from" : account})
            keys.setSoulContract(soulAddress, {"from" : account})
            soul.setSoulKeyContract(soulKeyAddress, {"from" : account})
        elif (opt == "4"):
            key = int(input("Keys: "))
            if key >= 0:
                print("Owner of Keys: ", keys.ownerOf(key))
            sou = int(input("Soul: "))
            if sou >= 0:
                print("Owner of Soul: ", soul.ownerOf(sou))
        elif (opt == "5"):
            print("Token Supply Keys: ", keys.getTokenSupply(), " Normal: ", keys.getNormalMinted(), " OP: ", keys.getOpMinted())
            print("Token Supply Soul: ", soul.getTokenSupply())
        elif (opt == "6"):
            key = int(input("Keys: "))
            if key >= 0:
                print("Token URI of Keys", keys.tokenURI(key))
            sou = int(input("Soul: "))
            if sou >= 0:
                print("Token URI of Soul", soul.tokenURI(sou))
        elif (opt == "7"):
            keys.withdraw({"from" : account})
            soul.withdraw({"from" : account})
        elif (opt == "8"):
            key = int(input("Key number: "))
            print("Key type of ", key, ": ", keys.keyType(key, {"from" : account}))
        elif (opt == "9"):
            tokens = keys.getTokens({"from" : account})
            print("Tokens: " + list(tokens))
        elif (opt == "exit"):
            cond = False