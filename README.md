# Jara Ink Test NFT

A deliberately bounded ERC-721 fixture for Jara's first real Ink preflight.

## Contract rules

- Public `mint(uint256)`.
- `MINT_PRICE = 0`.
- `MAX_PER_CALL = 1`.
- `MAX_SUPPLY = 3`.
- One successful mint per wallet.
- No owner/admin mint.
- No whitelist.
- No withdrawal function.
- No arbitrary calldata, signer permissions, or submission permissions.
- Three fixed Jara mascot metadata URIs.

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
# Put the separate deployer wallet private key in .env locally only.
set -a
source .env
set +a
forge test -vv
```

## Deploy to Ink mainnet

```bash
forge script script/Deploy.s.sol:DeployJaraInkTestNFT \
  --rpc-url "$INK_RPC_URL" \
  --broadcast \
  --verify \
  --verifier blockscout \
  --verifier-url https://explorer.inkonchain.com/api/
```

Do not mint from Jara immediately after deployment. First verify bytecode and constants, register the public address in Jara at price `0`, create a Target Total `1` intent, and run Jara's read-only Ink preflight.
