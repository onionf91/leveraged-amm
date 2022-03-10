const MockUSDC = artifacts.require('MockUSDC')

contract('AMM', (accounts) => {
    let usdc, owner

    before(() => {
        owner = accounts[0]
    })

    it('Should init 10000 unit of token to first account.', async () => {
        usdc = await MockUSDC.new()

        let ownerBalance = await usdc.balanceOf.call(owner)

        assert.equal(ownerBalance.valueOf(), 10000)
    })

})
