const { expect } = require("chai");
const { ethers, artifacts } = require("hardhat");
const { ether } = require('@openzeppelin/test-helpers')
const { tokens } = require('./helpers')
require('dotenv').config()

const BASE = new ethers.BigNumber.from(10**10).mul(new ethers.BigNumber.from(10**8))

describe("BancorOracle", async function () {
  before(async function () {
    const BancorOracle = await ethers.getContractFactory('BancorOracle')
    this.reg = await ethers.getContractAt('IBancorRegistry', '0x52Ae12ABe5D8BD778BD5397F99cA900624CfADD4')
    // this.reg = await Registry.attach('0x52Ae12ABe5D8BD778BD5397F99cA900624CfADD4')
    // this.bancorOracle = await BancorOracle.attach(process.env.BANCOR_ORACLE)
    this.bancorOracle = await BancorOracle.deploy('0x52Ae12ABe5D8BD778BD5397F99cA900624CfADD4')
  });

  it('weth -> dai', async function () {
    const rate = await this.bancorOracle.getRate(tokens.COMP, tokens.BNT, tokens.DAI);
    console.log(rate.rate)
    expect(rate.rate.toString()).to.be.bignumber.greaterThan(ether('55'));
});

it('bnt -> dai', async function () {
    const rate = await this.bancorOracle.getRate(tokens.BNT, tokens.DAI, tokens.NONE);
    console.log(rate.rate)
    expect(rate.rate.toString()).to.be.bignumber.greaterThan(ether('3'));
});

it('eth -> link', async function () {
  const rate = await this.bancorOracle.getRate(tokens.ETH, tokens.LINK, tokens.NONE);
  console.log(rate.rate)
  expect(rate.rate.toString()).to.be.bignumber.greaterThan(ether('200'));
});

// it('dai -> eth', async function () {
//     const rate = await this.bancorOracle.getRate(tokens.DAI, tokens.ETH, tokens.NONE);
//     expect(rate.rate).to.be.bignumber.lessThan(ether('0.001'));
// });
});
