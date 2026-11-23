# Starknet Token (Encode London hackathon)

An ERC-20-style token contract written in Cairo for Starknet, built at the Encode London hackathon as an entry for the Nethermind bounty for the most useful Starknet project.

## Features

- Supply cap set when the contract is initialised
- Owner-only minting, checked against the cap
- Burning from the caller's own balance
- Transfers, blocked while the contract is paused
- Pause and unpause, restricted to the owner
- `balance_of` and `total_supply` views

Cairo was new to me on the day, so this was as much about learning the language as building the contract.
