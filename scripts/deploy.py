from scripts.commonScripts import getAccount
from brownie import Soul, SoulKey, Utils_bys

def deploy():    
    account = getAccount()
    # Utils address
    utils = Utils_bys.deploy({"from" : account})
    # uint _tokenMintLimit, uint _tokenPrice, string memory _baseURI, address _utils, uint _maxSoulPerAddress
    soul = Soul.deploy(3, 50000000000000000, "ipfs://QmfDxAu91kit8Qs5dLbGd6xDXsVqwbtq2Hk6P8SEAscpSK", utils, 10, {"from" : account})
    # string memory _baseURI, uint _normalPrice, uint _opPrice, uint _normalMintLimit, uint _opMintLimit, uint _soulMintedWithOpKey, address _utils, uint _maximumNormalForAddress, uint _maximumOpForAddress
    soulKey = SoulKey.deploy("ipfs://QmP43k8yAScy8GErzEFN7kadmCoHJoZD6VvdXyK7HpxGmQ", 50000000000000000, 150000000000000000, 3000, 1000, 3, utils, 100, 10, {"from" : account})

def main():
    deploy()