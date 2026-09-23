# Jara Ink Test NFT

A deliberately bounded ERC-721 fixture for Jara's first real Ink preflight.

## Contract rules

- Public interface remains `mint(uint256)`.
- Only the three execution-wallet addresses fixed in the constructor may mint.
- `MINT_PRICE = 0`.
- `MAX_PER_CALL = 1`.
- `MAX_SUPPLY = 3`.
- One successful mint per approved wallet.
- No owner/admin mint.
- No mutable allowlist.
- No withdrawal function.
- No arbitrary external calls, signer permissions, or submission permissions.
- No proxy or upgradeability.
- Three fixed Jara mascot metadata URIs.

## Allowlist

The repository contains no real Jara execution-wallet addresses.

At deployment time, the script reads three public EVM addresses:

```text
JARA_EXECUTION_WALLET_1=
JARA_EXECUTION_WALLET_2=
JARA_EXECUTION_WALLET_3=
```

Those addresses are passed to the constructor and fixed for the lifetime of the contract. The constructor rejects zero addresses and duplicates. There is no post-deployment allowlist setter.

## Artwork

1. Jara Scout
2. Jara Operator
3. Jara Sentinel

The metadata and compressed JPEGs live in this public repository so the test assets remain simple and inspectable.

## Local setup

```bash
forge install foundry-rs/forge-std --no-commit
forge install OpenZeppelin/openzeppelin-contracts --no-commit
cp .env.example .env
# Fill only the three PUBLIC execution-wallet addresses in .env.
set -a
source .env
set +a
forge test -vv
```

## Deployment

The deploy script deliberately does not read a private key. Supply deployment signing to Foundry separately from the repository and environment file.

Example shape only:

```bash
forge script script/Deploy.s.sol:DeployJaraInkTestNFT \
  --rpc-url "$INK_RPC_URL" \
  --account <LOCAL_FOUNDRY_ACCOUNT> \
  --broadcast \
  --verify \
  --verifier blockscout \
  --verifier-url https://explorer.inkonchain.com/api/
```

Do not mint from Jara immediately after deployment. First verify bytecode and constants, register the public address in Jara at price `0`, create a Target Total `1` intent, and run Jara's read-only Ink preflight.
