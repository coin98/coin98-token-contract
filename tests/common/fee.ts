import { BigNumber } from "ethers";

export function calculateFee(value: BigNumber, numerator: BigNumber, denominator: BigNumber, minFee: BigNumber) {
    return value.mul(numerator).div(denominator).add(minFee)
}