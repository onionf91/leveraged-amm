const AMM = artifacts.require('AMM')

contract('AMM', (accounts) => {

    it('Should put 10000 Rt and 1000 Ru in the contract.', async () => {
        let amm = await AMM.deployed();

        let initRt = await amm.reserveTwd()
        let initRu = await amm.reserveUsd()

        assert.equal(initRt.valueOf(), 10000)
        assert.equal(initRu.valueOf(), 1000)
    })

})