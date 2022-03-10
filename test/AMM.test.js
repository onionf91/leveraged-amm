const AMM = artifacts.require('AMM')

contract('AMM', (accounts) => {
    let amm

    it('Should put 10000 Rt and 1000 Ru in the contract.', async () => {
        amm = await AMM.deployed();

        let initRt = await amm.reserveTwd.call()
        let initRu = await amm.reserveUsd.call()

        assert.equal(initRt.valueOf(), 10000)
        assert.equal(initRu.valueOf(), 1000)
    })

    it('Should exchange USD success.', async () => {
        let usdOut = await amm.exchangeUSD.call(6000) // dry-run
        assert.equal(usdOut.valueOf(), 375)

        await amm.exchangeUSD(6000) // actually send transaction
    })

    it('Should update reserved TWD and USD after USD exchanged.', async () => {
        let updatedRt = await amm.reserveTwd.call()
        let updatedRu = await amm.reserveUsd.call()

        assert.equal(updatedRt.valueOf(), 16000)
        assert.equal(updatedRu.valueOf(), 625)
    })

    it('Should exchange TWD success.', async () => {
        let usdOut = await amm.exchangeTWD.call(625) // dry-run
        assert.equal(usdOut.valueOf(), 8000)

        await amm.exchangeTWD(625) // actually send transaction
    })

    it('Should update reserved TWD and USD after TWD exchanged.', async () => {
        let updatedRt = await amm.reserveTwd.call()
        let updatedRu = await amm.reserveUsd.call()

        assert.equal(updatedRt.valueOf(), 8000)
        assert.equal(updatedRu.valueOf(), 1250)
    })

})