from brownie import accounts, network, config
TEST_ENV = ["ganache-local"]
TESTNET_ENV = ["rinkeby"]
def getAccount():
    print("Active network: ", network.show_active())
    if network.show_active() in TEST_ENV:
        return accounts[0]
    return accounts.add(config["wallets"]["fromKey"])