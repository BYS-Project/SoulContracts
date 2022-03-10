from scripts.commonScripts import getAccount
from brownie import PrivateSK

def deploy():    
    account = getAccount()
    PrivateSK.deploy({"from" : account})

def main():
    deploy()