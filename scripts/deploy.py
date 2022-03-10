from scripts.commonScripts import getAccount
from brownie import SoulKey, Soul

def deploy():    
    account = getAccount()
    SoulKey.deploy({"from" : account})
    Soul.deploy({"from" : account})

def main():
    deploy()