from brownie import accounts, network, config
TESTNETS = ["rinkeby"]
def getAccount():
    print("Active network: ", network.show_active())
    return "0x6aC1D3C86DD80C730cbbd333A1A208d4095bc301"
    return accounts.add(config["wallets"]["fromKey"])