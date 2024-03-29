# PoC: Leveraged AMM

An automated market maker (AMM) is the underlying protocol
that powers all decentralized exchanges (DEXs).

In leveraged yield farming, users can borrow tokens to
strengthen their farming positions and therefore, enjoy
additional farming yields. The process is simple: in a
leveraged yield farming protocol, users initially deposit
any proportion of the two tokens. Users could deposit one
of the two or a combination of both.


## Setup Environment

Install `Truffle` via `npm` with global flag.

```bash
npm install -g Truffle
```

Install `OpenZeppelin` via `npm` in `leveraged-amm` folder.

```bash
 npm install @openzeppelin/contracts
```

## Execute Tests for AMM

```bash
truffle test ./test/AMM.test.js
```

## Execute Tests for Leveraged AMM

```bash
truffle test ./test/LeveragedAMM.test.js
```

## Deployment

Run following command to compile smart contracts:

```bash
truffle compile
```

The output files will be generated in `build/` folder. The
output files contains smart contract `ABI` and `bytecode`
for deployment and operation usage.

If you want to deploy smart contracts via truffle
suit. Please reference to
[this](https://trufflesuite.com/guides/using-infura-custom-provider/index.html)
tutorial to configure EVM node connection and your wallet.
