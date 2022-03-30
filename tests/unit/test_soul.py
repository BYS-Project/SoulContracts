from brownie import Soul,  Utils_bys
from scripts import commonScripts
import pytest

account = commonScripts.getAccount()
MAX_TOKEN_SUPPLY = 10
MAX_TOKEN_PER_ADDRESS = 3
TOKEN_MINT_VALUE = 5000000000000000
TOKEN_DEFAULT_DIR = "ipfs://QmfDxAu91kit8Qs5dLbGd6xDXsVqwbtq2Hk6P8SEAscpSK"
# Tests
# 1) Mint function & Withdraw
def test_mintSuccessfull():
    AMOUNT_TO_MINT = 1
    soul = getSoul()
    soul.setContractOnline(True, {"from" : account})
    bTokenSupply = soul.getTokenSupply()
    bBalanceOf = soul.balanceOf(account)
    bContractBalance = soul.balance()
    tx = soul.mint(AMOUNT_TO_MINT, {"from" : account, "value" : TOKEN_MINT_VALUE * AMOUNT_TO_MINT})

    tx.wait(1)

    aTokenSupply = soul.getTokenSupply()
    aBalanceOf = soul.balanceOf(account)
    aContractBalance = soul.balance()
    
    assert aTokenSupply == (bTokenSupply + AMOUNT_TO_MINT)
    assert aBalanceOf == (bBalanceOf + AMOUNT_TO_MINT)
    assert aContractBalance == (bContractBalance + AMOUNT_TO_MINT * TOKEN_MINT_VALUE)

    soul.withdraw({"from" : account})

    assert soul.balance() == 0
def test_mintUnsuccessful1():
    AMOUNT_TO_MINT = MAX_TOKEN_SUPPLY
    soul = getSoul()

    with pytest.raises(Exception) as exception:
        soul.mint(AMOUNT_TO_MINT, {"from" : account})
def test_mintUnsuccessful2():
    AMOUNT_TO_MINT = MAX_TOKEN_SUPPLY
    soul = getSoul()
    soul.setContractOnline(True, {"from" : account})

    with pytest.raises(Exception) as exception:
        soul.mint(AMOUNT_TO_MINT, {"from" : account})
def test_mintUnsuccessful3():
    AMOUNT_TO_MINT = MAX_TOKEN_PER_ADDRESS
    soul = getSoul()
    soul.setContractOnline(True, {"from" : account})

    with pytest.raises(Exception) as exception:
        soul.mint(AMOUNT_TO_MINT, {"from" : account})
# 2) Token URI
def test_tokenURI():
    AMOUNT_TO_MINT = 1
    soul = getSoul()
    soul.setContractOnline(True, {"from" : account})
    soul.mint(AMOUNT_TO_MINT, {"from" : account, "value" : AMOUNT_TO_MINT * TOKEN_MINT_VALUE})
    soul.withdraw({"from" : account})
    
    assert soul.tokenURI(0) == (TOKEN_DEFAULT_DIR + "/" + "0" + ".json")


# - Utils
def getSoul():
    return  Soul.deploy(MAX_TOKEN_SUPPLY, TOKEN_MINT_VALUE, TOKEN_DEFAULT_DIR, getUtils(), MAX_TOKEN_PER_ADDRESS, {"from" : account})
def getUtils():
    return Utils_bys.deploy({"from" : account})