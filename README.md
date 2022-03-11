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
