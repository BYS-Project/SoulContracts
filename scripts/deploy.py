from scripts.commonScripts import getAccount
from brownie import Soul, SoulKey

def deploy():    
    account = getAccount()
    Soul.deploy(12000, 70000000000000000, "ipfs://QmfDxAu91kit8Qs5dLbGd6xDXsVqwbtq2Hk6P8SEAscpSK", {"from" : account})
    SoulKey.deploy("ipfs://QmP43k8yAScy8GErzEFN7kadmCoHJoZD6VvdXyK7HpxGmQ", 50000000000000000, 150000000000000000, 3000, 1000, 3, {"from" : account})

def main():
    deploy()