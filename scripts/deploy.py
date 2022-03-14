from scripts.commonScripts import getAccount
from brownie import Soul, SoulKey

def deploy():    
    account = getAccount()
    Soul.deploy({"from" : account})
    SoulKey.deploy({"from" : account})

def main():
    deploy()