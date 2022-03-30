from brownie import SoulKey,  Utils_bys
from scripts import commonScripts
import pytest

account = commonScripts.getAccount()
BASE_URI = "ipfs://QmP43k8yAScy8GErzEFN7kadmCoHJoZD6VvdXyK7HpxGmQ"
NORMAL_PRICE = 5000000000000000
OP_PRICE = 15000000000000000
NORMAL_MINT_LIMIT = 10
OP_MINT_LIMIT = 5
SOUL_MINTED_WITH_OP = 3
MAXIMUM_NORMAL_FOR_ADDRESS = 5
MAXIMUM_OP_FOR_ADDRESS = 5
# 1) Mint SKN Function
def test_successfulMintSKN():
    QUANTITY_TO_MINT = 1
    soulKey = getSoulKey()
    soulKey.setContractOnline(True, {"from" : account})
    bBalance = soulKey.balance()
    bTokenSupply = soulKey.getTokenSupply()
    tx = soulKey.mintSKN(QUANTITY_TO_MINT, {"from" : account, "value" : NORMAL_PRICE * QUANTITY_TO_MINT})

    tx.wait(1)

    aBalance = soulKey.balance()
    aTokenSupply = soulKey.getTokenSupply()

    assert aBalance == bBalance + QUANTITY_TO_MINT * NORMAL_PRICE
    assert aTokenSupply == bTokenSupply + QUANTITY_TO_MINT
    assert soulKey.ownerOf(0) == account

    soulKey.withdraw({"from" : account})

    assert soulKey.balance() == 0
def test_unsuccessfulMintSKN1():
    QUANTITY_TO_MINT = 1
    soulKey = getSoulKey()
    with pytest.raises(Exception) as exception:
        soulKey.mintSKN(QUANTITY_TO_MINT, {"from" : account, "value" : NORMAL_PRICE * QUANTITY_TO_MINT})
def test_unsuccessfulMintSKN2():
    QUANTITY_TO_MINT = NORMAL_MINT_LIMIT + 1
    soulKey = getSoulKey()
    soulKey.setContractOnline(True, {"from" : account})
    with pytest.raises(Exception) as exception:
        soulKey.mintSKN(QUANTITY_TO_MINT, {"from" : account, "value" : NORMAL_PRICE * QUANTITY_TO_MINT})
def test_unsuccessfulMintSKN3():
    QUANTITY_TO_MINT = MAXIMUM_NORMAL_FOR_ADDRESS + 1
    soulKey = getSoulKey()
    soulKey.setContractOnline(True, {"from" : account})
    with pytest.raises(Exception) as exception:
        soulKey.mintSKN(QUANTITY_TO_MINT, {"from" : account, "value" : NORMAL_PRICE * QUANTITY_TO_MINT})
# 2) Mint SKOP Function
def test_successfulMintSKOP():
    QUANTITY_TO_MINT = 1
    soulKey = getSoulKey()
    soulKey.setContractOnline(True, {"from" : account})
    bBalance = soulKey.balance()
    bTokenSupply = soulKey.getTokenSupply()
    tx = soulKey.mintSKOP(QUANTITY_TO_MINT, {"from" : account, "value" : OP_PRICE * QUANTITY_TO_MINT})

    tx.wait(1)

    aBalance = soulKey.balance()
    aTokenSupply = soulKey.getTokenSupply()

    assert aBalance == bBalance + QUANTITY_TO_MINT * OP_PRICE
    assert aTokenSupply == bTokenSupply + QUANTITY_TO_MINT
    assert soulKey.ownerOf(0) == account

    soulKey.withdraw({"from" : account})

    assert soulKey.balance() == 0
def test_unsuccessfulMintSKOP1():
    QUANTITY_TO_MINT = 1
    soulKey = getSoulKey()
    with pytest.raises(Exception) as exception:
        soulKey.mintSKOP(QUANTITY_TO_MINT, {"from" : account, "value" : OP_PRICE * QUANTITY_TO_MINT})
def test_unsuccessfulMintSKOP2():
    QUANTITY_TO_MINT = NORMAL_MINT_LIMIT + 1
    soulKey = getSoulKey()
    soulKey.setContractOnline(True, {"from" : account})
    with pytest.raises(Exception) as exception:
        soulKey.mintSKOP(QUANTITY_TO_MINT, {"from" : account, "value" : OP_PRICE * QUANTITY_TO_MINT})
def test_unsuccessfulMintSKOP3():
    QUANTITY_TO_MINT = MAXIMUM_NORMAL_FOR_ADDRESS + 1
    soulKey = getSoulKey()
    soulKey.setContractOnline(True, {"from" : account})
    with pytest.raises(Exception) as exception:
        soulKey.mintSKOP(QUANTITY_TO_MINT, {"from" : account, "value" : OP_PRICE * QUANTITY_TO_MINT})
# 3) Token URI
def test_tokenURI():
    NORMAL_MINT = 1
    OP_MINT = 1
    soulKey = getSoulKey()
    soulKey.setContractOnline(True, {"from" : account})
    tx1 = soulKey.mintSKN(NORMAL_MINT, {"from" : account, "value" : NORMAL_MINT * NORMAL_PRICE})
    tx2 = soulKey.mintSKOP(OP_MINT, {"from" : account, "value" : OP_MINT * OP_PRICE})

    tx1.wait(1)
    tx2.wait(1)

    assert soulKey.tokenURI(0) == (BASE_URI + "/" + "0" + "_normal.json")
    assert soulKey.tokenURI(1) == (BASE_URI + "/" + "1" + "_op.json")

    soulKey.withdraw({"from" : account})
# 4) Key Type
def test_keyType():
    NORMAL_MINT = 1
    OP_MINT = 1
    soulKey = getSoulKey()
    soulKey.setContractOnline(True, {"from" : account})
    tx1 = soulKey.mintSKN(NORMAL_MINT, {"from" : account, "value" : NORMAL_MINT * NORMAL_PRICE})
    tx2 = soulKey.mintSKOP(OP_MINT, {"from" : account, "value" : OP_MINT * OP_PRICE})

    tx1.wait(1)
    tx2.wait(1)

    assert soulKey.keyType(0) == 1
    assert soulKey.keyType(1) == 2

    soulKey.withdraw({"from" : account})
# Test Getters
def test_getters():
    # There are two steps of minting
    NORMAL_FIRST_STEP = 2
    OP_FIRST_STEP = 2
    NORMAL_SECOND_STEP = 3
    OP_SECOND_STEP = 3
    soulKey = getSoulKey()
    soulKey.setContractOnline(True, {"from" : account})
    # First step normal variables
    bNormalMinted = soulKey.getNormalMinted()
    bNormalBalance = soulKey.normalBalanceOf(account)

    tx = soulKey.mintSKN(NORMAL_FIRST_STEP, {"from" : account, "value" : NORMAL_FIRST_STEP * NORMAL_PRICE})

    tx.wait(1)
    # First step normal assertions
    assert soulKey.getNormalMinted() == bNormalMinted + NORMAL_FIRST_STEP
    assert soulKey.normalBalanceOf(account) == bNormalBalance + NORMAL_FIRST_STEP
    # First step OP variables
    bOpMinted = soulKey.getOpMinted()
    bOpBalance = soulKey.opBalanceOf(account)

    tx = soulKey.mintSKOP(OP_FIRST_STEP, {"from" : account, "value" : OP_FIRST_STEP * OP_PRICE})

    tx.wait(1)
    # First step op assertions
    assert soulKey.getOpMinted() == bOpMinted + OP_FIRST_STEP
    assert soulKey.opBalanceOf(account) == bOpBalance + OP_FIRST_STEP
    # Second step normal variables
    bNormalMinted = soulKey.getNormalMinted()
    bNormalBalance = soulKey.normalBalanceOf(account)

    tx = soulKey.mintSKN(NORMAL_SECOND_STEP, {"from" : account, "value" : NORMAL_SECOND_STEP * NORMAL_PRICE})

    tx.wait(1)
    # Second step normal variables
    assert soulKey.getNormalMinted() == bNormalMinted + NORMAL_SECOND_STEP
    assert soulKey.normalBalanceOf(account) == bNormalBalance + NORMAL_SECOND_STEP
    # Second step op variables
    bOpMinted = soulKey.getOpMinted()
    bOpBalance = soulKey.opBalanceOf(account)

    tx = soulKey.mintSKOP(OP_SECOND_STEP, {"from" : account, "value" : OP_SECOND_STEP * OP_PRICE})

    tx.wait(1)
    # Second step op assertions
    assert soulKey.getOpMinted() == bOpMinted + OP_SECOND_STEP
    assert soulKey.opBalanceOf(account) == bOpBalance + OP_SECOND_STEP

    soulKey.withdraw({"from" : account})


# - Utils
def getSoulKey():
    return  SoulKey.deploy(BASE_URI, NORMAL_PRICE, OP_PRICE, NORMAL_MINT_LIMIT, OP_MINT_LIMIT, SOUL_MINTED_WITH_OP, getUtils(),
    MAXIMUM_NORMAL_FOR_ADDRESS, MAXIMUM_OP_FOR_ADDRESS, {"from" : account})
def getUtils():
    return Utils_bys.deploy({"from" : account})