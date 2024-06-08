# Audit `hyacinthaudits.xyz` registration test [![Foundry][foundry-badge]][foundry]

[gitpod]: https://gitpod.io/#https://github.com/PaulRBerg/foundry-template
[gitpod-badge]: https://img.shields.io/badge/Gitpod-Open%20in%20Gitpod-FFB45B?logo=gitpod
[gha]: https://github.com/PaulRBerg/foundry-template/actions
[gha-badge]: https://github.com/PaulRBerg/foundry-template/actions/workflows/ci.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[license]: https://opensource.org/licenses/MIT
[license-badge]: https://img.shields.io/badge/License-MIT-blue.svg

Audit `TestErrorNFT.sol` for registration test of `hyacinthaudits.xyz` platform.


# Table of Contents

- [Summary](#summary)
  - [Files Summary](#files-summary)
  - [Files Details](#files-details)
  - [Issue Summary](#issue-summary)
- [High Issues](#high-issues)
  - [H-1: Mint Limit Check Missing](#h-1-mint-limit-check-missing)
  - [H-2: Reentrancy Issues](#h-2-reentrancy-issues)
- [Medium Issues](#medium-issues)
  - [M-1: Compile errors | No arguments passed to the base constructor](#m-1-compile-errors-no-arguments-passed-to-the-base-constructor)
  - [M-2: Compile errors | Line 30: The line totalSupply += amount; is outside of any function](#m-2-compile-errors-line-30-the-line-totalsupply-=-amount;-is-outside-of-any-function)
  - [M-3: Wrong Visibility of Functions](#m-3-wrong-visibility-of-functions)
  - [M-4: Redundant totalSupply Update](#m-4-redundant-totalsupply-update)
- [Low Issues](#low-issues)
  - [L-1: SPDX license identifiers missing](#l-1-spdx-license-identifiers-missing)
  - [L-2: Imports files method](#l-2-imports-files-method)
  - [L-3: Removed imported openzeppelin contract in new version](#l-3-removed-imported-openzeppelin-contract-in-new-version)
  - [L-4: Naming Convention](#l-4-naming-convention)
  - [L-5: Incorrect Return Statement in _baseURI](#l-5-incorrect-return-statement-in-_baseuri)

# Summary

## Files Summary

| Key        | Value |
|------------|-------|
| .sol Files | 1     |
| Total nSLOC| 41    |

## Files Details

| Filepath              | nSLOC |
|-----------------------|-------|
| src/TestErrorNFT.sol  | 41    |
| **Total**             | **41**|

## Issue Summary

| Category | No. of Issues |
|----------|---------------|
| High     | 2             |
| Medium   | 4             |
| Low      | 5             |

# High Issues

## H-1: Mint Limit Check Missing

There is no check to enforce the `maxMintPerUser` limit in the `mint` or `batchMint` functions.

<details><summary>2 Found Instances</summary>

- Found in src/TestErrorNFT.sol [Line: 18](src\TestErrorNFT.sol#L18)

    ```solidity
        function mint(address to) public {
    +       require(userMintedCount[to] < maxMintPerUser, "Max mint per user exceeded");
    +       require(totalSupply() < maxSupply, "Max supply exceeded");

            _safeMint(to, _tokenIdCounter.current());
            _tokenIdCounter.increment();
            userMintedCount[to]++;
        }
    ```

- Found in src/TestErrorNFT.sol [Line: 25](src\TestErrorNFT.sol#L25)

    ```solidity
        function batchMint(address to, uint256 amount) public {
    +       require(userMintedCount[to] + amount <= maxMintPerUser, "Max mint per user exceeded");
    +       require(totalSupply() + amount <= maxSupply, "Max supply exceeded");

            for (uint256 i = 0; i < amount; i++) {
                mint(to);
            }
        }
    ```

</details>

## H-2: Reentrancy Issues

The contract could benefit from using checks-effects-interactions pattern for safer minting processes.

<details><summary>1 Found Instance</summary>

- Found in src/TestErrorNFT.sol [Line: 18](src\TestErrorNFT.sol#L18)

</details>

# Medium Issues

## M-1: Compile errors | No arguments passed to the base constructor

No arguments were passed to the base constructor. Specify the arguments.

<details><summary>1 Found Instance</summary>

- Found in src/TestErrorNFT.sol [Line: 16](src\TestErrorNFT.sol#L16)

    ```solidity
    TypeError: No arguments passed to the base constructor. Specify the arguments
    Note: Base constructor parameters:
    --> @openzeppelin/contracts/access/Ownable.sol:38:16:
    |
    38 |     constructor(address initialOwner) {
    |                ^^^^^^^^^^^^^^^^^^^^^^
    ```

    ```solidity
    constructor() ERC721("ErrorNFT", "ENFT") Ownable(msg.sender) {}
    ```

</details>

## M-2: Compile errors | Line 30: The line totalSupply += amount; is outside of any function

The line `totalSupply += amount;` should be inside the `batchMint` function.

<details><summary>1 Found Instance</summary>

- Found in src/TestErrorNFT.sol [Line: 30](src\TestErrorNFT.sol#L30)

    ```solidity
        function batchMint(address to, uint256 amount) public {
            for (uint256 i = 0; i < amount; i++) {
                mint(to);
            }
    +        totalSupply += amount;
        }
    -        totalSupply += amount;
    ```

</details>

## M-3: Wrong Visibility of Functions

The `batchMint` and `setUserMintLimit` functions should ideally be `external` based on the intended use case.

<details><summary>2 Found Instances</summary>

- Found in src/TestErrorNFT.sol [Line: 25](src\TestErrorNFT.sol#L25)

    ```solidity
    function batchMint(address to, uint256 amount) external
    ```

- Found in src/TestErrorNFT.sol [Line: 32](src\TestErrorNFT.sol#L32)

    ```solidity
    function setUserMintLimit(uint256 newLimit) external onlyOwner
    ```

</details>

## M-4: Redundant totalSupply Update

The `totalSupply` is incremented both in the `mint` function and in the `batchMint` function for each mint.

<details><summary>2 Found Instances</summary>

- Found in src/TestErrorNFT.sol [Line: 24](src\TestErrorNFT.sol#L24)
- Found in src/TestErrorNFT.sol [Line: 32](src\TestErrorNFT.sol#L32)

    Recommended: we can remove `totalSupply` variable and use a counter instead.

    ```solidity
        function totalSupply() public view returns (uint256) {
            return _tokenIdCounter.current();
        }
    ```

</details>

# Low Issues

## L-1: SPDX license identifiers missing

SPDX license identifiers should be added to the top of contract files.

<details><summary>1 Found Instance</summary>

- Found in src/TestErrorNFT.sol [Line: 0](src\TestErrorNFT.sol#L0)

    ```solidity
    // SPDX-License-Identifier: MIT
    ```

</details>

## L-2: Imports files method

Instead of `Wildcard Import`, consider using `Named Import`.

<details><summary>3 Found Instances</summary>

- Found in src/TestErrorNFT.sol [Line: 3](src\TestErrorNFT.sol#L3)

    ```solidity
    import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
    ```

- Found in src/TestErrorNFT.sol [Line: 4](src@TestErrorNFT.sol#L4)

    ```solidity
    import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";
    ```

- Found in src/TestErrorNFT.sol [Line: 5](src\TestErrorNFT.sol#L5)

    ```solidity
    import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
    ```

</details>

## L-3: Removed imported openzeppelin contract in new version

`Counters.sol` in version 5 has been removed.

<details><summary>1 Found Instance</summary>

- Found in src/TestErrorNFT.sol [Line: 4](src@TestErrorNFT.sol#L4)

    [Link to Issue](https://github.com/OpenZeppelin/openzeppelin-contracts/issues/4233)

</details>

## L-4: Naming Convention

For consistency and readability, you may want to keep a consistent naming convention for variables (e.g., `maxMintPerUser` could be `maxMintPerAddress`).

<details><summary>1 Found Instance</summary>

- Found in src@TestErrorNFT.sol [Line: 11](src@TestErrorNFT.sol#L11)

</details>

## L-5: Incorrect Return Statement in _baseURI

The `_baseURI` function should have a valid URI string in return and can be marked as `pure`.

<details><summary>1 Found Instance</summary>

- Found in src@TestErrorNFT.sol [Line: 38](src@TestErrorNFT.sol#L38)

    ```solidity
    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }
    ```

</details>
