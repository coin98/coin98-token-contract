const C98ERC20 = artifacts.require('C98ERC20')
const SafeMath = artifacts.require('SafeMath')

module.exports = function (deployer, network, accounts) {
  deployer.deploy(SafeMath, {
    from: accounts[0]
  })
  deployer.link(SafeMath, C98ERC20)
  deployer.deploy(C98ERC20, 'C98Labs', 'C98', '1000000000000000000', {
    from: accounts[0]
  })
}
