from brownie import SoulKey, Soul, Utils_bys
from scripts import commonScripts
import pytest

account = commonScripts.getAccount()
# Soul Key Attributes
BASE_URI = "ipfs://QmP43k8yAScy8GErzEFN7kadmCoHJoZD6VvdXyK7HpxGmQ"
NORMAL_PRICE = 5000000000000000
OP_PRICE = 15000000000000000
NORMAL_MINT_LIMIT = 10
OP_MINT_LIMIT = 5
SOUL_MINTED_WITH_OP = 3
MAXIMUM_NORMAL_FOR_ADDRESS = 5
MAXIMUM_OP_FOR_ADDRESS = 5
# Soul attributes
SOUL_MINT_LIMIT = 10
SOUL_PRICE = 50000000000000000
SOUL_BASE_URI = "ipfs://QmfDxAu91kit8Qs5dLbGd6xDXsVqwbtq2Hk6P8SEAscpSK"
MAX_SOUL_PER_ADDRESS = 4
# Convert To Soul with normal keys
def test_convertToSoulNormal():
    NORMAL_MINT = 1
    soulKey = getSoulKey()
    soul = getSoul()
    soulKey.setContractOnline(True, {"from" : account})
    soulKey.setSoulContract(soul, {"from" : account})

    soul.setAllowKeys(True, {"from" : account})
    soul.setSoulKeyContract(soulKey, {"from" : account})

    bNormalBalance = soulKey.normalBalanceOf(account)
    bBalance = soulKey.balanceOf(account)

    tx = soulKey.mintSKN(NORMAL_MINT, {"from" : account, "value" : NORMAL_MINT * NORMAL_PRICE})

    tx.wait(1)

    aNormalBalance = soulKey.normalBalanceOf(account)
    aBalance = soulKey.balanceOf(account)

    assert aNormalBalance == bNormalBalance + NORMAL_MINT
    assert aBalance == bBalance + NORMAL_MINT

    soulKey.convertToSoul(0, {"from" : account})

    assert soulKey.normalBalanceOf(account) == bNormalBalance
    assert soulKey.balanceOf(account) == bBalance
    assert soulKey.normalBalanceOf(soul) == aNormalBalance
    assert soulKey.balanceOf(soul) == aBalance

    assert soul.balanceOf(account) == 1
    

    soulKey.withdraw({"from" : account})

# Convert To Soul with OP keys
def test_convertToSoulOP():
    OP_MINT = 1
    soulKey = getSoulKey()
    soul = getSoul()
    soulKey.setContractOnline(True, {"from" : account})
    soulKey.setSoulContract(soul, {"from" : account})

    soul.setAllowKeys(True, {"from" : account})
    soul.setSoulKeyContract(soulKey, {"from" : account})

    bOPBalance = soulKey.opBalanceOf(account)
    bBalance = soulKey.balanceOf(account)

    tx = soulKey.mintSKOP(OP_MINT, {"from" : account, "value" : OP_MINT * OP_PRICE})

    tx.wait(1)

    aOPBalance = soulKey.opBalanceOf(account)
    aBalance = soulKey.balanceOf(account)

    assert aOPBalance == bOPBalance + OP_MINT
    assert aBalance == bBalance + OP_MINT

    soulKey.convertToSoul(0, {"from" : account})

    assert soulKey.opBalanceOf(account) == bOPBalance
    assert soulKey.balanceOf(account) == bBalance
    assert soulKey.opBalanceOf(soul) == aOPBalance
    assert soulKey.balanceOf(soul) == aBalance

    assert soul.balanceOf(account) == 3
    

    soulKey.withdraw({"from" : account})

# - Utils
def getSoulKey():
    return  SoulKey.deploy(BASE_URI, NORMAL_PRICE, OP_PRICE, NORMAL_MINT_LIMIT, OP_MINT_LIMIT, SOUL_MINTED_WITH_OP, getUtils(),
    MAXIMUM_NORMAL_FOR_ADDRESS, MAXIMUM_OP_FOR_ADDRESS, {"from" : account})
def getSoul():
    return Soul.deploy(SOUL_MINT_LIMIT, SOUL_PRICE, SOUL_BASE_URI, getUtils(), MAX_SOUL_PER_ADDRESS, {"from" : account})
def getUtils():
    return Utils_bys.deploy({"from" : account})