# TipJar Smart Contract on Stacks Blockchain

This repository contains a Clarity smart contract for a TipJar on the Stacks blockchain. The contract allows users to send tips to a designated owner and enables the owner to withdraw the accumulated tips.

## Features

- **Owner Initialization**: The contract owner is set during initialization.
- **Send Tips**: Users can send tips to the owner, and the transaction is logged.
- **Withdraw Tips**: The owner can withdraw the accumulated tips.
- **View Total Tips**: Anyone can view the total amount of tips received.
- **Individual Contribution**: Users can check their individual contribution to the tip jar.

## Contract Functions

### `get-owner` : Returns the owner of the tip jar.

### `send-tip` : Allows users to send tips to the jar.

### `withdraw-tips` : Allows the owner to withdraw tips from the jar.

### `get-total-tips` : Returns the total amount of tips received.

### `get-contribution` : Returns the individual contribution of a sender.

## Deployment

To deploy this contract, follow these steps:

1. Clone the repository.
2. Ensure you have the Clarity development environment set up.
3. Deploy the `mintify.clar` contract to the Stacks blockchain.
