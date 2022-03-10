const AMM = artifacts.require('AMM')

module.exports = (deployer) => {
    deployer.deploy(AMM, 10000, 1000)
}