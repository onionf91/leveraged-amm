const AMM = artifacts.require('AMM')
const MockUSDC = artifacts.require('MockUSDC')

module.exports = (deployer) => {
    deployer.deploy(AMM, 10000, 1000)
    deployer.deploy(MockUSDC)
}