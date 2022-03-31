from brownie import accounts, network, config
TESTNETS = ["rinkeby"]
def getAccount():
    print("Active network: ", network.show_active())
    return "0x18c6962d4507b0eeD7128b0852515a0d9e89a65e"
    return accounts.add(config["wallets"]["fromKey"])