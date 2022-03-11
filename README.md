# Perp Pretest

## Setup Environment

Install `Truffle` via `npm` with global flag.

```bash
npm install -g Truffle
```

Install `OpenZeppelin` via `npm` in `perp-pretest` folder.

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
