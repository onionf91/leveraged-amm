const LAMM = artifacts.require('LeveragedAMM')
const MockUSDC = artifacts.require('MockUSDC')
const catchRevert = require("./exceptions.js").catchRevert;

contract('LeveragedAMM', (accounts) => {
    let lAmm, usdc, owner, alice

    before(() => {
        owner = accounts[0]
        alice = accounts[1]
    })

    it('Should add eth liquidity when owner deposit eth to LAMM.', async () => {
        lAmm = await LAMM.deployed()

        await web3.eth.sendTransaction({to: lAmm.address, from: owner, value: web3.utils.toWei('2', 'ether')})

        let balance = await web3.eth.getBalance(lAmm.address);
        assert.equal(web3.utils.fromWei(balance.valueOf(), 'ether'), 2)

        let reserveEth = await lAmm.reserveEth.call()
        assert.equal(reserveEth.valueOf(), web3.utils.toWei('2', 'ether'))
    })

    it('Should add eth cash to user when deposit eth to LAMM.', async () => {
        lAmm = await LAMM.deployed()

        await web3.eth.sendTransaction({to: lAmm.address, from: alice, value: web3.utils.toWei('0.1', 'ether')})

        let balance = await web3.eth.getBalance(lAmm.address);
        assert.equal(web3.utils.fromWei(balance.valueOf(), 'ether'), 2.1)

        let ethCash = await lAmm.ethCashOf.call(alice)
        assert.equal(ethCash.valueOf(), web3.utils.toWei('0.1', 'ether'))
    })

    it('Should add usdc liquidity when owner deposit usdc to LAMM.', async () => {
        usdc = await MockUSDC.deployed()

        await usdc.approve(lAmm.address, 5000, {from: owner})
        await lAmm.depositUsdc(5000, {from: owner})

        let balance = await usdc.balanceOf.call(lAmm.address)
        assert.equal(balance.valueOf(), 5000)

        let reserveUsdc = await lAmm.reserveUsdc.call()
        assert.equal(reserveUsdc.valueOf(), 5000)
    })

    it('Should add usdc cash to user when deposit usdc to LAMM.', async () => {
        usdc = await MockUSDC.deployed()

        await usdc.transfer(alice, 100, {from: owner})
        await usdc.approve(lAmm.address, 50, {from: alice})
        await lAmm.depositUsdc(50, {from: alice})

        let balance = await usdc.balanceOf.call(lAmm.address)
        assert.equal(balance.valueOf(), 5050)

        let usdcCash = await lAmm.usdcCashOf.call(alice)
        assert.equal(usdcCash.valueOf(), 50)
    })

    it('Estimate eth position should calculate position by AMM with leverage.', async () => {
        let ethPosition = await lAmm.estimateEthPosition.call(200, 5)
        assert.equal(web3.utils.fromWei(ethPosition.valueOf(), 'ether'), 0.333333333333333334)
    })

    it('Estimate eth position should revert while leverage exceed max value.', async () => {
        await catchRevert(lAmm.estimateEthPosition.call(50, 11))
    })

    it('Estimate eth position should revert while leveraged usdc exceed reserve usdc.', async () => {
        await catchRevert(lAmm.estimateEthPosition.call(4000, 2))
    })

    it('Estimate usdc position should calculate position by AMM with leverage.', async () => {
        let usdcPosition = await lAmm.estimateUsdcPosition.call(web3.utils.toWei('0.01', 'ether'), 8)
        assert.equal(usdcPosition.valueOf(), 193)
    })

    it('Estimate usdc position should revert while leverage exceed max value.', async () => {
        await catchRevert(lAmm.estimateUsdcPosition.call(web3.utils.toWei('0.01', 'ether'), 12))
    })

    it('Estimate usdc position should revert while leveraged eth exceed reserve eth.', async () => {
        await catchRevert(lAmm.estimateUsdcPosition.call(web3.utils.toWei('1.0', 'ether'), 3))
    })
})
