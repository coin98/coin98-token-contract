// Import the necessary dependencies
import { ethers } from "hardhat";
import { Signer, BigNumber } from "ethers";
import { expect } from "chai";
import { Coin98VRC25 } from "../typechain-types";
import { ZERO_ADDRESS } from '@coin98/solidity-support-library';
import { calculateFee } from "./common/fee";

describe("Coin98VRC25 token", async function() {
  let owner: Signer;
  let ownerAddress: string;
  let sender: Signer;
  let senderAddress: string;
  let recipient: Signer;
  let recipientAddress: string;
  let c98Token: Coin98VRC25;
  let maxSupply = 1_000_000_000;
  let minFee = ethers.utils.parseEther("1");
  let priceN = BigNumber.from("1");
  let priceD = BigNumber.from("100"); 

  beforeEach(async function() {
    [owner, sender, recipient] = await ethers.getSigners();
    ownerAddress = await owner.getAddress();
    senderAddress = await sender.getAddress();
    recipientAddress = await recipient.getAddress();
    const tokenFactory = await ethers.getContractFactory("Coin98VRC25");
    c98Token = await tokenFactory.connect(owner).deploy();
    await c98Token.setFee(priceN, priceD, minFee);
    await c98Token.mint(senderAddress, ethers.utils.parseEther("1000"));
  });

  it("check ownership", async function() {
    expect(await c98Token.owner()).to.equal(ownerAddress);
  });

  it("should transfer ownership", async function() {
    await c98Token.transferOwnership(recipientAddress);
    expect(await c98Token.owner()).to.equal(ownerAddress);
    await c98Token.connect(recipient).acceptOwnership();
    expect(await c98Token.owner()).to.equal(recipientAddress);
  });

  it("should mint tokens", async function() {
    const amount = ethers.utils.parseEther("1000");
    const balanceBefore = await c98Token.balanceOf(recipientAddress);
    await c98Token.connect(owner).mint(recipientAddress, amount);
    const balanceAfter = await c98Token.balanceOf(recipientAddress);
    expect(balanceAfter).to.equal(balanceBefore.add(amount));
  });

  it("cannot mint exceeds max supply", async function() {
    const amount = ethers.utils.parseEther((maxSupply + 1).toString());
    await expect(c98Token.connect(owner).mint(ownerAddress, amount))
    .to.be.rejectedWith("ERC20: mint amount exceeds max supply");    
  });

  it("should burn tokens", async function() {
    const amount = ethers.utils.parseEther("100");
    const balanceBefore = await c98Token.balanceOf(senderAddress);
    await c98Token.connect(sender).burn(amount);
    const balanceAfter = await c98Token.balanceOf(senderAddress);
    expect(balanceAfter).to.equal(balanceBefore.sub(amount.add(minFee)));
  });

  it("cannot burn exceeds balance", async function() {
    const amount = ethers.utils.parseEther("1001");
    await expect(c98Token.connect(owner).burn(amount))
    .to.be.rejectedWith("ERC20: burn amount exceeds balance");    
  });

  it("should burnFrom tokens", async function() {
    const amount = ethers.utils.parseEther("100");
    const balanceBefore = await c98Token.balanceOf(senderAddress);
    await c98Token.connect(sender).approve(recipientAddress, amount.add(minFee));
    await c98Token.connect(recipient).burnFrom(senderAddress, amount);
    const balanceAfter = await c98Token.balanceOf(senderAddress);
    const totalAmountLeft = amount.add(minFee).add(minFee); //2 times lost fee (approve, burnFrom)
    expect(balanceAfter).to.equal(balanceBefore.sub(totalAmountLeft));
  });

  it("cannot burnFrom exceeds allowance", async function() {
    const approveAmount = ethers.utils.parseEther("100");
    const burnAmount = ethers.utils.parseEther("101");
    await c98Token.connect(sender).approve(recipientAddress, approveAmount);
    await expect(c98Token.connect(recipient).burnFrom(ownerAddress, burnAmount))
    .to.be.rejectedWith("ERC20: burn amount exceeds allowance");
  });

  it("should transfer tokens", async function() {
    const initialSenderBalance = ethers.utils.parseEther("1000");
    const transferAmount = ethers.utils.parseEther("500");
    const fee = calculateFee(transferAmount, priceN, priceD, minFee);
    const initialRecipientBalance = ethers.BigNumber.from(0);
    const ownerBalance = await c98Token.balanceOf(senderAddress);
    const recipientBalance = await c98Token.balanceOf(recipientAddress);
    expect(ownerBalance).to.equal(initialSenderBalance);
    expect(recipientBalance).to.equal(initialRecipientBalance);
    await c98Token.connect(sender).transfer(recipientAddress, transferAmount);
    expect(await c98Token.balanceOf(senderAddress)).to.equal(initialSenderBalance.sub(transferAmount.add(fee)));
    expect(await c98Token.balanceOf(recipientAddress)).to.equal(initialRecipientBalance.add(transferAmount));
  });

  it("cannot transfer exceeds balance", async function() {
    const amount = ethers.utils.parseEther("1001");
    await expect(c98Token.connect(sender).transfer(recipientAddress, amount))
    .to.be.rejectedWith("ERC20: transfer amount exceeds balance");
  });

  it("cannot transfer to the zero address", async function() {
    recipientAddress = ZERO_ADDRESS;
    const transferAmount = ethers.utils.parseEther("500");
    await expect(c98Token.connect(sender).transfer(recipientAddress, transferAmount))
    .to.be.rejectedWith("ERC20: transfer to the zero address");
  });

  it("cannot transfer tokens while the token is frozen", async function() {
    const transferAmount = ethers.utils.parseEther("500");
    await c98Token.connect(owner).freeze();
    await expect(c98Token.connect(sender).transfer(recipientAddress, transferAmount))
    .to.be.rejectedWith("ERC20: token transfer while frozen");
    await c98Token.connect(owner).unfreeze();
    await c98Token.connect(sender).transfer(recipientAddress, transferAmount);
  });

  it("should rescue accidentally sent token", async function() {
    const tokenFactory = await ethers.getContractFactory("Coin98");
    const anotherC98Token = await tokenFactory.connect(owner).deploy();
    const initialBalance = ethers.utils.parseEther("1000");
    await anotherC98Token.connect(owner).mint(ownerAddress, initialBalance);
    await anotherC98Token.connect(owner).transfer(c98Token.address, initialBalance);
    await c98Token.connect(owner).withdraw(anotherC98Token.address, recipientAddress, initialBalance);
    expect(await anotherC98Token.balanceOf(recipientAddress)).to.equal(initialBalance);
  });

  it("should approve tokens", async function() {
    const beforeAllowance = await c98Token.allowance(senderAddress, recipientAddress);
    const amount = ethers.utils.parseEther("1000");
    const fee = calculateFee(amount, priceN, priceD, minFee);
    await c98Token.connect(sender).approve(recipientAddress, amount);
    const afterAllowance = await c98Token.allowance(senderAddress, recipientAddress);
    expect(afterAllowance).to.equal(beforeAllowance.add(amount));
  });

  it("cannot approve to the zero address", async function() {
    await expect(c98Token.connect(owner).approve(ZERO_ADDRESS, "1"))
    .to.be.rejectedWith("ERC20: approve to the zero address");
  });
  
  it("should increase allowance", async function() {
    const beforeAllowance = await c98Token.allowance(senderAddress, recipientAddress);
    const initAmount = ethers.utils.parseEther("1000");
    await c98Token.connect(sender).approve(recipientAddress, initAmount);
    const increaseAmount = ethers.utils.parseEther("500");
    await c98Token.connect(sender).increaseAllowance(recipientAddress, increaseAmount);
    const afterAllowance = await c98Token.allowance(senderAddress, recipientAddress);
    expect(afterAllowance).to.equal(beforeAllowance.add(initAmount).add(increaseAmount));
  });

  it("should decrease allowance", async function() {
    const beforeAllowance = await c98Token.allowance(senderAddress, recipientAddress);
    const initAmount = ethers.utils.parseEther("1000");
    await c98Token.connect(sender).approve(recipientAddress, initAmount);
    const decreaseAmount = ethers.utils.parseEther("500");
    await c98Token.connect(sender).decreaseAllowance(recipientAddress, decreaseAmount);
    const afterAllowance = await c98Token.allowance(senderAddress, recipientAddress);
    expect(afterAllowance).to.equal(beforeAllowance.add(initAmount).sub(decreaseAmount));
  });

  it("cannot decrease allowance below zero", async function() {
    const initAmount = ethers.utils.parseEther("1000");
    await c98Token.connect(sender).approve(recipientAddress, initAmount);
    const decreaseAmount = ethers.utils.parseEther("1001");
    await expect(c98Token.connect(sender).decreaseAllowance(recipientAddress, decreaseAmount))
    .to.be.rejectedWith("ERC20: decreased allowance below zero");
  });

  it("should transferFrom successful", async function() {
    const balanceBefore = await c98Token.balanceOf(recipientAddress);
    const amount = ethers.utils.parseEther("100");
    const fee = calculateFee(amount, priceN, priceD, minFee);
    await c98Token.connect(sender).approve(recipientAddress, amount.add(fee));
    await c98Token.connect(recipient).transferFrom(senderAddress, recipientAddress, amount);
    const balanceAfter = await c98Token.balanceOf(recipientAddress);
    expect(balanceAfter).to.equal(balanceBefore.add(amount));
  });

  it("cannot transferFrom exceeds allowance", async function() {
    const approveAmount = ethers.utils.parseEther("100");
    const transferAmount = ethers.utils.parseEther("101");
    await c98Token.connect(sender).approve(recipientAddress, approveAmount);
    await expect(c98Token.connect(recipient).transferFrom(senderAddress, recipientAddress, transferAmount))
    .to.be.rejectedWith("ERC20: transfer amount exceeds allowance");
  });
});
