# Solidity API

## web3jsTest

### a

```solidity
int256 a
```

### b

```solidity
bool b
```

### input

```solidity
struct input {
  int256 _a;
  bool isTrue;
}
```

### structTest

```solidity
function structTest(struct web3jsTest.input _params) public returns (int256, bool)
```

## AggregatorV3Interface

### decimals

```solidity
function decimals() external view returns (uint8)
```

### description

```solidity
function description() external view returns (string)
```

### version

```solidity
function version() external view returns (uint256)
```

### getRoundData

```solidity
function getRoundData(uint80 _roundId) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
```

### latestRoundData

```solidity
function latestRoundData() external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
```

## ChainlinkPriceFeed

Gets price of token from Chainlink oracle

_Yet to be integrated to check against v3 twap_

### ETHprice

```solidity
contract AggregatorV3Interface ETHprice
```

### BTCprice

```solidity
contract AggregatorV3Interface BTCprice
```

### constructor

```solidity
constructor() public
```

### PriceETH

```solidity
function PriceETH() public view returns (int256)
```

### PriceBTC

```solidity
function PriceBTC() public view returns (int256)
```

## OptionHedger

This contract is reposible for the main logic behind handling User 2's hedging of User 1's position

_addresses at top of file can be removed_

### DAI

```solidity
address DAI
```

### USDT

```solidity
address USDT
```

### USDC

```solidity
address USDC
```

### WETH

```solidity
address WETH
```

### BS_Options

```solidity
mapping(address => mapping(address => mapping(uint256 => struct BS.BS_params))) BS_Options
```

### JDM_Options

```solidity
mapping(address => mapping(address => mapping(uint256 => struct JDM.JDM_params))) JDM_Options
```

### BSC_Options

```solidity
mapping(address => mapping(address => mapping(uint256 => struct BSC.BSC_params))) BSC_Options
```

### BSgetHedgeAvailability

```solidity
function BSgetHedgeAvailability(address pair, address user, uint256 ID) public view returns (bool isHedgeable)
```

Black Scholes Model

### BScalculateNewDelta

```solidity
function BScalculateNewDelta(address pair, address user, uint256 ID, int256 price) public view returns (int256 delta)
```

### BS_HEDGE

```solidity
function BS_HEDGE(address pair, address user, uint256 ID) public returns (uint256 payment)
```

### JDMgetHedgeAvailability

```solidity
function JDMgetHedgeAvailability(address pair, address user, uint256 ID) public view returns (bool isHedgeable)
```

Jump Diffusion Model

### JDMcalculateNewDelta

```solidity
function JDMcalculateNewDelta(address pair, address user, uint256 ID, int256 price) public view returns (int256 delta)
```

### JDM_HEDGE

```solidity
function JDM_HEDGE(address pair, address user, uint256 ID) public returns (uint256 payment)
```

### BSCgetHedgeAvailability

```solidity
function BSCgetHedgeAvailability(address pair, address user, uint256 ID) public view returns (bool isHedgeable)
```

### BSCcalculatePreviousDelta

```solidity
function BSCcalculatePreviousDelta(address pair, address user, uint256 ID) public view returns (int256 delta)
```

### BSCcalculateNewDelta

```solidity
function BSCcalculateNewDelta(address pair, address user, uint256 ID, int256 price) public view returns (int256 delta)
```

### BSC_HEDGE

```solidity
function BSC_HEDGE(address pair, address user, uint256 ID) public returns (uint256 payment)
```

## OptionMaker

This contract contains the main logic for initializing option replication positions

_using delegatecall to run logic of BSOptionMaker and JDMOptionMaker_

### BSOptionMaker

```solidity
address BSOptionMaker
```

### JDMOptionMaker

```solidity
address JDMOptionMaker
```

### BSCOptionMaker

```solidity
address BSCOptionMaker
```

### constructor

```solidity
constructor(address _BS, address _JDM, address _BSC) public
```

### BS_START_REPLICATION

```solidity
function BS_START_REPLICATION(struct BS.BS_params _params) public returns (address, uint256)
```

### BS_edit_params

```solidity
function BS_edit_params(address pair, uint256 ID, uint256 feeAmount, struct BS.BS_params _params) public returns (bool)
```

### BS_Withdraw

```solidity
function BS_Withdraw(address pair, uint256 ID) public returns (address, uint256)
```

### JDM_START_REPLICATION

```solidity
function JDM_START_REPLICATION(struct JDM.JDM_params _params) public returns (address, uint256)
```

### JDM_edit_params

```solidity
function JDM_edit_params(address pair, uint256 ID, uint256 feeAmount, struct JDM.JDM_params _params) public returns (bool)
```

### JDM_Withdraw

```solidity
function JDM_Withdraw(address pair, uint256 ID) public returns (uint256, uint256)
```

### BSC_START_REPLICATION

```solidity
function BSC_START_REPLICATION(struct BSC.BSC_params _params) public returns (address, uint256)
```

### BSC_edit_params

```solidity
function BSC_edit_params(address pair, uint256 ID, uint256 feeAmount, struct BSC.BSC_params _params) public returns (bool)
```

### BSC_Withdraw

```solidity
function BSC_Withdraw(address pair, uint256 ID) public returns (address, uint256)
```

## PairMaker

Creates a token pair address

_This token pair address is used to keep track of of protocol fees accrued in the token pair_

### Pair

```solidity
struct Pair {
  address tokenA;
  uint256 tokenA_balance;
  address tokenB;
  uint256 tokenB_balance;
}
```

### Fees

```solidity
struct Fees {
  uint256 tokenA;
  uint256 tokenB;
}
```

### getPair

```solidity
mapping(address => mapping(address => address)) getPair
```

### allPairs

```solidity
address[] allPairs
```

### Pairs

```solidity
mapping(address => struct PairMaker.Pair) Pairs
```

### PairFees

```solidity
mapping(address => struct PairMaker.Fees) PairFees
```

### PairUsers

```solidity
mapping(address => address[]) PairUsers
```

### Positions

```solidity
mapping(address => address[]) Positions
```

### numOfPairs

```solidity
function numOfPairs() public view returns (uint256)
```

### userIDlength

```solidity
function userIDlength(address user) external view returns (uint256 numberOfPositions)
```

### getUserPositions

```solidity
function getUserPositions(address user) external view returns (address[])
```

### getUserAddressesInPair

```solidity
function getUserAddressesInPair(address pair) external view returns (address[])
```

### getNumberOfUsersInPair

```solidity
function getNumberOfUsersInPair(address pair) external view returns (uint256 numberOfUsers)
```

### getPairUserAddress

```solidity
function getPairUserAddress(address pair, uint256 ID) external view returns (address user)
```

### createPair

```solidity
function createPair(address tokenA, address tokenB) internal returns (address pair)
```

## UniswapV2Swap

Swaps token0 for token1 on Uniswap V2 (sushiswap, pancakeswap etc)

_Currently this contract is not being inherited by the main DeltaDex contract_

### UNISWAP_V2_ROUTER

```solidity
address UNISWAP_V2_ROUTER
```

### WETH

```solidity
address WETH
```

### swapV2

```solidity
function swapV2(address token0, address token1, uint256 amountIn, uint256 amountOutMin) internal
```

### getAmountOutMin

```solidity
function getAmountOutMin(address _tokenIn, address _tokenOut) public view returns (uint256)
```

## Swapper

This contract swaps token0 for token1

_This contract currently provides the core functionality of the DeltaDex delta hedging strategy_

### swapRouter

```solidity
contract ISwapRouter swapRouter
```

### getPrice

```solidity
function getPrice(address token0, address token1) public view returns (int256)
```

### swapExactInputSingle

```solidity
function swapExactInputSingle(address token0, address token1, uint256 amountIn) internal returns (uint256 amountOut)
```

### swapExactOutputSingle

```solidity
function swapExactOutputSingle(address token0, address token1, uint256 amountOut, uint256 amountInMaximum) internal returns (uint256 amountIn)
```

## Address

_Collection of functions related to the address type_

### isContract

```solidity
function isContract(address account) internal view returns (bool)
```

_Returns true if `account` is a contract.

[IMPORTANT]
====
It is unsafe to assume that an address for which this function returns
false is an externally-owned account (EOA) and not a contract.

Among others, `isContract` will return false for the following
types of addresses:

 - an externally-owned account
 - a contract in construction
 - an address where a contract will be created
 - an address where a contract lived, but was destroyed
====

[IMPORTANT]
====
You shouldn't rely on `isContract` to protect against flash loan attacks!

Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
constructor.
====_

### sendValue

```solidity
function sendValue(address payable recipient, uint256 amount) internal
```

_Replacement for Solidity's `transfer`: sends `amount` wei to
`recipient`, forwarding all available gas and reverting on errors.

https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
of certain opcodes, possibly making contracts go over the 2300 gas limit
imposed by `transfer`, making them unable to receive funds via
`transfer`. {sendValue} removes this limitation.

https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].

IMPORTANT: because control is transferred to `recipient`, care must be
taken to not create reentrancy vulnerabilities. Consider using
{ReentrancyGuard} or the
https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern]._

### functionCall

```solidity
function functionCall(address target, bytes data) internal returns (bytes)
```

_Performs a Solidity function call using a low level `call`. A
plain `call` is an unsafe replacement for a function call: use this
function instead.

If `target` reverts with a revert reason, it is bubbled up by this
function (like regular Solidity function calls).

Returns the raw returned data. To convert to the expected return value,
use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].

Requirements:

- `target` must be a contract.
- calling `target` with `data` must not revert.

_Available since v3.1.__

### functionCall

```solidity
function functionCall(address target, bytes data, string errorMessage) internal returns (bytes)
```

_Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
`errorMessage` as a fallback revert reason when `target` reverts.

_Available since v3.1.__

### functionCallWithValue

```solidity
function functionCallWithValue(address target, bytes data, uint256 value) internal returns (bytes)
```

_Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
but also transferring `value` wei to `target`.

Requirements:

- the calling contract must have an ETH balance of at least `value`.
- the called Solidity function must be `payable`.

_Available since v3.1.__

### functionCallWithValue

```solidity
function functionCallWithValue(address target, bytes data, uint256 value, string errorMessage) internal returns (bytes)
```

_Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
with `errorMessage` as a fallback revert reason when `target` reverts.

_Available since v3.1.__

### functionStaticCall

```solidity
function functionStaticCall(address target, bytes data) internal view returns (bytes)
```

_Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
but performing a static call.

_Available since v3.3.__

### functionStaticCall

```solidity
function functionStaticCall(address target, bytes data, string errorMessage) internal view returns (bytes)
```

_Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
but performing a static call.

_Available since v3.3.__

### functionDelegateCall

```solidity
function functionDelegateCall(address target, bytes data) internal returns (bytes)
```

_Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
but performing a delegate call.

_Available since v3.4.__

### functionDelegateCall

```solidity
function functionDelegateCall(address target, bytes data, string errorMessage) internal returns (bytes)
```

_Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
but performing a delegate call.

_Available since v3.4.__

### verifyCallResultFromTarget

```solidity
function verifyCallResultFromTarget(address target, bool success, bytes returndata, string errorMessage) internal view returns (bytes)
```

_Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.

_Available since v4.8.__

### verifyCallResult

```solidity
function verifyCallResult(bool success, bytes returndata, string errorMessage) internal pure returns (bytes)
```

_Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
revert reason or using the provided one.

_Available since v4.3.__

### _revert

```solidity
function _revert(bytes returndata, string errorMessage) private pure
```

## IERC20

_Interface of the ERC20 standard as defined in the EIP._

### Transfer

```solidity
event Transfer(address from, address to, uint256 value)
```

_Emitted when `value` tokens are moved from one account (`from`) to
another (`to`).

Note that `value` may be zero._

### Approval

```solidity
event Approval(address owner, address spender, uint256 value)
```

_Emitted when the allowance of a `spender` for an `owner` is set by
a call to {approve}. `value` is the new allowance._

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```

_Returns the amount of tokens in existence._

### balanceOf

```solidity
function balanceOf(address account) external view returns (uint256)
```

_Returns the amount of tokens owned by `account`._

### transfer

```solidity
function transfer(address to, uint256 amount) external returns (bool)
```

_Moves `amount` tokens from the caller's account to `to`.

Returns a boolean value indicating whether the operation succeeded.

Emits a {Transfer} event._

### allowance

```solidity
function allowance(address owner, address spender) external view returns (uint256)
```

_Returns the remaining number of tokens that `spender` will be
allowed to spend on behalf of `owner` through {transferFrom}. This is
zero by default.

This value changes when {approve} or {transferFrom} are called._

### approve

```solidity
function approve(address spender, uint256 amount) external returns (bool)
```

_Sets `amount` as the allowance of `spender` over the caller's tokens.

Returns a boolean value indicating whether the operation succeeded.

IMPORTANT: Beware that changing an allowance with this method brings the risk
that someone may use both the old and the new allowance by unfortunate
transaction ordering. One possible solution to mitigate this race
condition is to first reduce the spender's allowance to 0 and set the
desired value afterwards:
https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

Emits an {Approval} event._

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 amount) external returns (bool)
```

_Moves `amount` tokens from `from` to `to` using the
allowance mechanism. `amount` is then deducted from the caller's
allowance.

Returns a boolean value indicating whether the operation succeeded.

Emits a {Transfer} event._

## SafeERC20

_Wrappers around ERC20 operations that throw on failure (when the token
contract returns false). Tokens that return no value (and instead revert or
throw on failure) are also supported, non-reverting calls are assumed to be
successful.
To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
which allows you to call the safe operations as `token.safeTransfer(...)`, etc._

### safeTransfer

```solidity
function safeTransfer(contract IERC20 token, address to, uint256 value) internal
```

### safeTransferFrom

```solidity
function safeTransferFrom(contract IERC20 token, address from, address to, uint256 value) internal
```

### safeApprove

```solidity
function safeApprove(contract IERC20 token, address spender, uint256 value) internal
```

_Deprecated. This function has issues similar to the ones found in
{IERC20-approve}, and its usage is discouraged.

Whenever possible, use {safeIncreaseAllowance} and
{safeDecreaseAllowance} instead._

### safeIncreaseAllowance

```solidity
function safeIncreaseAllowance(contract IERC20 token, address spender, uint256 value) internal
```

### safeDecreaseAllowance

```solidity
function safeDecreaseAllowance(contract IERC20 token, address spender, uint256 value) internal
```

### safePermit

```solidity
function safePermit(contract IERC20Permit token, address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) internal
```

### _callOptionalReturn

```solidity
function _callOptionalReturn(contract IERC20 token, bytes data) private
```

_Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
on the return value: the return value is optional (but if data is returned, it must not be false)._

| Name | Type | Description |
| ---- | ---- | ----------- |
| token | contract IERC20 | The token targeted by the call. |
| data | bytes | The call data (encoded using abi.encode or one of its variants). |

## IERC20Permit

_Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].

Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
need to send a transaction, and thus is not required to hold Ether at all._

### permit

```solidity
function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external
```

_Sets `value` as the allowance of `spender` over ``owner``'s tokens,
given ``owner``'s signed approval.

IMPORTANT: The same issues {IERC20-approve} has related to transaction
ordering also apply here.

Emits an {Approval} event.

Requirements:

- `spender` cannot be the zero address.
- `deadline` must be a timestamp in the future.
- `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
over the EIP712-formatted function arguments.
- the signature must use ``owner``'s current nonce (see {nonces}).

For more information on the signature format, see the
https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
section]._

### nonces

```solidity
function nonces(address owner) external view returns (uint256)
```

_Returns the current nonce for `owner`. This value must be
included whenever a signature is generated for {permit}.

Every successful call to {permit} increases ``owner``'s nonce by one. This
prevents a signature from being used multiple times._

### DOMAIN_SEPARATOR

```solidity
function DOMAIN_SEPARATOR() external view returns (bytes32)
```

_Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}._

## PRBMath__MulDivFixedPointOverflow

```solidity
error PRBMath__MulDivFixedPointOverflow(uint256 prod1)
```

Emitted when the result overflows uint256.

## PRBMath__MulDivOverflow

```solidity
error PRBMath__MulDivOverflow(uint256 prod1, uint256 denominator)
```

Emitted when the result overflows uint256.

## PRBMath__MulDivSignedInputTooSmall

```solidity
error PRBMath__MulDivSignedInputTooSmall()
```

Emitted when one of the inputs is type(int256).min.

## PRBMath__MulDivSignedOverflow

```solidity
error PRBMath__MulDivSignedOverflow(uint256 rAbs)
```

Emitted when the intermediary absolute result overflows int256.

## PRBMathSD59x18__AbsInputTooSmall

```solidity
error PRBMathSD59x18__AbsInputTooSmall()
```

Emitted when the input is MIN_SD59x18.

## PRBMathSD59x18__CeilOverflow

```solidity
error PRBMathSD59x18__CeilOverflow(int256 x)
```

Emitted when ceiling a number overflows SD59x18.

## PRBMathSD59x18__DivInputTooSmall

```solidity
error PRBMathSD59x18__DivInputTooSmall()
```

Emitted when one of the inputs is MIN_SD59x18.

## PRBMathSD59x18__DivOverflow

```solidity
error PRBMathSD59x18__DivOverflow(uint256 rAbs)
```

Emitted when one of the intermediary unsigned results overflows SD59x18.

## PRBMathSD59x18__ExpInputTooBig

```solidity
error PRBMathSD59x18__ExpInputTooBig(int256 x)
```

Emitted when the input is greater than 133.084258667509499441.

## PRBMathSD59x18__Exp2InputTooBig

```solidity
error PRBMathSD59x18__Exp2InputTooBig(int256 x)
```

Emitted when the input is greater than 192.

## PRBMathSD59x18__FloorUnderflow

```solidity
error PRBMathSD59x18__FloorUnderflow(int256 x)
```

Emitted when flooring a number underflows SD59x18.

## PRBMathSD59x18__FromIntOverflow

```solidity
error PRBMathSD59x18__FromIntOverflow(int256 x)
```

Emitted when converting a basic integer to the fixed-point format overflows SD59x18.

## PRBMathSD59x18__FromIntUnderflow

```solidity
error PRBMathSD59x18__FromIntUnderflow(int256 x)
```

Emitted when converting a basic integer to the fixed-point format underflows SD59x18.

## PRBMathSD59x18__GmNegativeProduct

```solidity
error PRBMathSD59x18__GmNegativeProduct(int256 x, int256 y)
```

Emitted when the product of the inputs is negative.

## PRBMathSD59x18__GmOverflow

```solidity
error PRBMathSD59x18__GmOverflow(int256 x, int256 y)
```

Emitted when multiplying the inputs overflows SD59x18.

## PRBMathSD59x18__LogInputTooSmall

```solidity
error PRBMathSD59x18__LogInputTooSmall(int256 x)
```

Emitted when the input is less than or equal to zero.

## PRBMathSD59x18__MulInputTooSmall

```solidity
error PRBMathSD59x18__MulInputTooSmall()
```

Emitted when one of the inputs is MIN_SD59x18.

## PRBMathSD59x18__MulOverflow

```solidity
error PRBMathSD59x18__MulOverflow(uint256 rAbs)
```

Emitted when the intermediary absolute result overflows SD59x18.

## PRBMathSD59x18__PowuOverflow

```solidity
error PRBMathSD59x18__PowuOverflow(uint256 rAbs)
```

Emitted when the intermediary absolute result overflows SD59x18.

## PRBMathSD59x18__SqrtNegativeInput

```solidity
error PRBMathSD59x18__SqrtNegativeInput(int256 x)
```

Emitted when the input is negative.

## PRBMathSD59x18__SqrtOverflow

```solidity
error PRBMathSD59x18__SqrtOverflow(int256 x)
```

Emitted when the calculating the square root overflows SD59x18.

## PRBMathUD60x18__AddOverflow

```solidity
error PRBMathUD60x18__AddOverflow(uint256 x, uint256 y)
```

Emitted when addition overflows UD60x18.

## PRBMathUD60x18__CeilOverflow

```solidity
error PRBMathUD60x18__CeilOverflow(uint256 x)
```

Emitted when ceiling a number overflows UD60x18.

## PRBMathUD60x18__ExpInputTooBig

```solidity
error PRBMathUD60x18__ExpInputTooBig(uint256 x)
```

Emitted when the input is greater than 133.084258667509499441.

## PRBMathUD60x18__Exp2InputTooBig

```solidity
error PRBMathUD60x18__Exp2InputTooBig(uint256 x)
```

Emitted when the input is greater than 192.

## PRBMathUD60x18__FromUintOverflow

```solidity
error PRBMathUD60x18__FromUintOverflow(uint256 x)
```

Emitted when converting a basic integer to the fixed-point format format overflows UD60x18.

## PRBMathUD60x18__GmOverflow

```solidity
error PRBMathUD60x18__GmOverflow(uint256 x, uint256 y)
```

Emitted when multiplying the inputs overflows UD60x18.

## PRBMathUD60x18__LogInputTooSmall

```solidity
error PRBMathUD60x18__LogInputTooSmall(uint256 x)
```

Emitted when the input is less than 1.

## PRBMathUD60x18__SqrtOverflow

```solidity
error PRBMathUD60x18__SqrtOverflow(uint256 x)
```

Emitted when the calculating the square root overflows UD60x18.

## PRBMathUD60x18__SubUnderflow

```solidity
error PRBMathUD60x18__SubUnderflow(uint256 x, uint256 y)
```

Emitted when subtraction underflows UD60x18.

## PRBMath

_Common mathematical functions used in both PRBMathSD59x18 and PRBMathUD60x18. Note that this shared library
does not always assume the signed 59.18-decimal fixed-point or the unsigned 60.18-decimal fixed-point
representation. When it does not, it is explicitly mentioned in the NatSpec documentation._

### SD59x18

```solidity
struct SD59x18 {
  int256 value;
}
```

### UD60x18

```solidity
struct UD60x18 {
  uint256 value;
}
```

### SCALE

```solidity
uint256 SCALE
```

_How many trailing decimals can be represented._

### SCALE_LPOTD

```solidity
uint256 SCALE_LPOTD
```

_Largest power of two divisor of SCALE._

### SCALE_INVERSE

```solidity
uint256 SCALE_INVERSE
```

_SCALE inverted mod 2^256._

### exp2

```solidity
function exp2(uint256 x) internal pure returns (uint256 result)
```

Calculates the binary exponent of x using the binary fraction method.

_Has to use 192.64-bit fixed-point numbers.
See https://ethereum.stackexchange.com/a/96594/24693._

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | uint256 | The exponent as an unsigned 192.64-bit fixed-point number. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | uint256 | The result as an unsigned 60.18-decimal fixed-point number. |

### mostSignificantBit

```solidity
function mostSignificantBit(uint256 x) internal pure returns (uint256 msb)
```

Finds the zero-based index of the first one in the binary representation of x.

_See the note on msb in the "Find First Set" Wikipedia article https://en.wikipedia.org/wiki/Find_first_set_

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | uint256 | The uint256 number for which to find the index of the most significant bit. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| msb | uint256 | The index of the most significant bit as an uint256. |

### mulDiv

```solidity
function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result)
```

Calculates floor(x*y÷denominator) with full precision.

_Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv.

Requirements:
- The denominator cannot be zero.
- The result must fit within uint256.

Caveats:
- This function does not work with fixed-point numbers._

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | uint256 | The multiplicand as an uint256. |
| y | uint256 | The multiplier as an uint256. |
| denominator | uint256 | The divisor as an uint256. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | uint256 | The result as an uint256. |

### mulDivFixedPoint

```solidity
function mulDivFixedPoint(uint256 x, uint256 y) internal pure returns (uint256 result)
```

Calculates floor(x*y÷1e18) with full precision.

_Variant of "mulDiv" with constant folding, i.e. in which the denominator is always 1e18. Before returning the
final result, we add 1 if (x * y) % SCALE >= HALF_SCALE. Without this, 6.6e-19 would be truncated to 0 instead of
being rounded to 1e-18.  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717.

Requirements:
- The result must fit within uint256.

Caveats:
- The body is purposely left uncommented; see the NatSpec comments in "PRBMath.mulDiv" to understand how this works.
- It is assumed that the result can never be type(uint256).max when x and y solve the following two equations:
    1. x * y = type(uint256).max * SCALE
    2. (x * y) % SCALE >= SCALE / 2_

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | uint256 | The multiplicand as an unsigned 60.18-decimal fixed-point number. |
| y | uint256 | The multiplier as an unsigned 60.18-decimal fixed-point number. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | uint256 | The result as an unsigned 60.18-decimal fixed-point number. |

### mulDivSigned

```solidity
function mulDivSigned(int256 x, int256 y, int256 denominator) internal pure returns (int256 result)
```

Calculates floor(x*y÷denominator) with full precision.

_An extension of "mulDiv" for signed numbers. Works by computing the signs and the absolute values separately.

Requirements:
- None of the inputs can be type(int256).min.
- The result must fit within int256._

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | The multiplicand as an int256. |
| y | int256 | The multiplier as an int256. |
| denominator | int256 | The divisor as an int256. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | int256 | The result as an int256. |

### sqrt

```solidity
function sqrt(uint256 x) internal pure returns (uint256 result)
```

Calculates the square root of x, rounding down.

_Uses the Babylonian method https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method.

Caveats:
- This function does not work with fixed-point numbers._

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | uint256 | The uint256 number for which to calculate the square root. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | uint256 | The result as an uint256. |

## PRBMathSD59x18

Smart contract library for advanced fixed-point math that works with int256 numbers considered to have 18
trailing decimals. We call this number representation signed 59.18-decimal fixed-point, since the numbers can have
a sign and there can be up to 59 digits in the integer part and up to 18 decimals in the fractional part. The numbers
are bound by the minimum and the maximum values permitted by the Solidity type int256.

### LOG2_E

```solidity
int256 LOG2_E
```

_log2(e) as a signed 59.18-decimal fixed-point number._

### HALF_SCALE

```solidity
int256 HALF_SCALE
```

_Half the SCALE number._

### MAX_SD59x18

```solidity
int256 MAX_SD59x18
```

_The maximum value a signed 59.18-decimal fixed-point number can have._

### MAX_WHOLE_SD59x18

```solidity
int256 MAX_WHOLE_SD59x18
```

_The maximum whole value a signed 59.18-decimal fixed-point number can have._

### MIN_SD59x18

```solidity
int256 MIN_SD59x18
```

_The minimum value a signed 59.18-decimal fixed-point number can have._

### MIN_WHOLE_SD59x18

```solidity
int256 MIN_WHOLE_SD59x18
```

_The minimum whole value a signed 59.18-decimal fixed-point number can have._

### SCALE

```solidity
int256 SCALE
```

_How many trailing decimals can be represented._

### abs

```solidity
function abs(int256 x) internal pure returns (int256 result)
```

Calculate the absolute value of x.

_Requirements:
- x must be greater than MIN_SD59x18._

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | The number to calculate the absolute value for. |

### avg

```solidity
function avg(int256 x, int256 y) internal pure returns (int256 result)
```

Calculates the arithmetic average of x and y, rounding down.

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | The first operand as a signed 59.18-decimal fixed-point number. |
| y | int256 | The second operand as a signed 59.18-decimal fixed-point number. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | int256 | The arithmetic average as a signed 59.18-decimal fixed-point number. |

### ceil

```solidity
function ceil(int256 x) internal pure returns (int256 result)
```

Yields the least greatest signed 59.18 decimal fixed-point number greater than or equal to x.

_Optimized for fractional value inputs, because for every whole value there are (1e18 - 1) fractional counterparts.
See https://en.wikipedia.org/wiki/Floor_and_ceiling_functions.

Requirements:
- x must be less than or equal to MAX_WHOLE_SD59x18._

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | The signed 59.18-decimal fixed-point number to ceil. |

### div

```solidity
function div(int256 x, int256 y) internal pure returns (int256 result)
```

Divides two signed 59.18-decimal fixed-point numbers, returning a new signed 59.18-decimal fixed-point number.

_Variant of "mulDiv" that works with signed numbers. Works by computing the signs and the absolute values separately.

Requirements:
- All from "PRBMath.mulDiv".
- None of the inputs can be MIN_SD59x18.
- The denominator cannot be zero.
- The result must fit within int256.

Caveats:
- All from "PRBMath.mulDiv"._

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | The numerator as a signed 59.18-decimal fixed-point number. |
| y | int256 | The denominator as a signed 59.18-decimal fixed-point number. |

### e

```solidity
function e() internal pure returns (int256 result)
```

Returns Euler's number as a signed 59.18-decimal fixed-point number.

_See https://en.wikipedia.org/wiki/E_(mathematical_constant)._

### exp

```solidity
function exp(int256 x) internal pure returns (int256 result)
```

Calculates the natural exponent of x.

_Based on the insight that e^x = 2^(x * log2(e)).

Requirements:
- All from "log2".
- x must be less than 133.084258667509499441.

Caveats:
- All from "exp2".
- For any x less than -41.446531673892822322, the result is zero._

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | The exponent as a signed 59.18-decimal fixed-point number. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | int256 | The result as a signed 59.18-decimal fixed-point number. |

### exp2

```solidity
function exp2(int256 x) internal pure returns (int256 result)
```

Calculates the binary exponent of x using the binary fraction method.

_See https://ethereum.stackexchange.com/q/79903/24693.

Requirements:
- x must be 192 or less.
- The result must fit within MAX_SD59x18.

Caveats:
- For any x less than -59.794705707972522261, the result is zero._

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | The exponent as a signed 59.18-decimal fixed-point number. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | int256 | The result as a signed 59.18-decimal fixed-point number. |

### floor

```solidity
function floor(int256 x) internal pure returns (int256 result)
```

Yields the greatest signed 59.18 decimal fixed-point number less than or equal to x.

_Optimized for fractional value inputs, because for every whole value there are (1e18 - 1) fractional counterparts.
See https://en.wikipedia.org/wiki/Floor_and_ceiling_functions.

Requirements:
- x must be greater than or equal to MIN_WHOLE_SD59x18._

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | The signed 59.18-decimal fixed-point number to floor. |

### frac

```solidity
function frac(int256 x) internal pure returns (int256 result)
```

Yields the excess beyond the floor of x for positive numbers and the part of the number to the right
of the radix point for negative numbers.

_Based on the odd function definition. https://en.wikipedia.org/wiki/Fractional_part_

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | The signed 59.18-decimal fixed-point number to get the fractional part of. |

### fromInt

```solidity
function fromInt(int256 x) internal pure returns (int256 result)
```

Converts a number from basic integer form to signed 59.18-decimal fixed-point representation.

_Requirements:
- x must be greater than or equal to MIN_SD59x18 divided by SCALE.
- x must be less than or equal to MAX_SD59x18 divided by SCALE._

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | The basic integer to convert. |

### gm

```solidity
function gm(int256 x, int256 y) internal pure returns (int256 result)
```

Calculates geometric mean of x and y, i.e. sqrt(x * y), rounding down.

_Requirements:
- x * y must fit within MAX_SD59x18, lest it overflows.
- x * y cannot be negative._

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | The first operand as a signed 59.18-decimal fixed-point number. |
| y | int256 | The second operand as a signed 59.18-decimal fixed-point number. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | int256 | The result as a signed 59.18-decimal fixed-point number. |

### inv

```solidity
function inv(int256 x) internal pure returns (int256 result)
```

Calculates 1 / x, rounding toward zero.

_Requirements:
- x cannot be zero._

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | The signed 59.18-decimal fixed-point number for which to calculate the inverse. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | int256 | The inverse as a signed 59.18-decimal fixed-point number. |

### ln

```solidity
function ln(int256 x) internal pure returns (int256 result)
```

Calculates the natural logarithm of x.

_Based on the insight that ln(x) = log2(x) / log2(e).

Requirements:
- All from "log2".

Caveats:
- All from "log2".
- This doesn't return exactly 1 for 2718281828459045235, for that we would need more fine-grained precision._

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | The signed 59.18-decimal fixed-point number for which to calculate the natural logarithm. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | int256 | The natural logarithm as a signed 59.18-decimal fixed-point number. |

### log10

```solidity
function log10(int256 x) internal pure returns (int256 result)
```

Calculates the common logarithm of x.

_First checks if x is an exact power of ten and it stops if yes. If it's not, calculates the common
logarithm based on the insight that log10(x) = log2(x) / log2(10).

Requirements:
- All from "log2".

Caveats:
- All from "log2"._

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | The signed 59.18-decimal fixed-point number for which to calculate the common logarithm. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | int256 | The common logarithm as a signed 59.18-decimal fixed-point number. |

### log2

```solidity
function log2(int256 x) internal pure returns (int256 result)
```

Calculates the binary logarithm of x.

_Based on the iterative approximation algorithm.
https://en.wikipedia.org/wiki/Binary_logarithm#Iterative_approximation

Requirements:
- x must be greater than zero.

Caveats:
- The results are not perfectly accurate to the last decimal, due to the lossy precision of the iterative approximation._

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | The signed 59.18-decimal fixed-point number for which to calculate the binary logarithm. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | int256 | The binary logarithm as a signed 59.18-decimal fixed-point number. |

### mul

```solidity
function mul(int256 x, int256 y) internal pure returns (int256 result)
```

Multiplies two signed 59.18-decimal fixed-point numbers together, returning a new signed 59.18-decimal
fixed-point number.

_Variant of "mulDiv" that works with signed numbers and employs constant folding, i.e. the denominator is
always 1e18.

Requirements:
- All from "PRBMath.mulDivFixedPoint".
- None of the inputs can be MIN_SD59x18
- The result must fit within MAX_SD59x18.

Caveats:
- The body is purposely left uncommented; see the NatSpec comments in "PRBMath.mulDiv" to understand how this works._

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | The multiplicand as a signed 59.18-decimal fixed-point number. |
| y | int256 | The multiplier as a signed 59.18-decimal fixed-point number. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | int256 | The product as a signed 59.18-decimal fixed-point number. |

### pi

```solidity
function pi() internal pure returns (int256 result)
```

Returns PI as a signed 59.18-decimal fixed-point number.

### pow

```solidity
function pow(int256 x, int256 y) internal pure returns (int256 result)
```

Raises x to the power of y.

_Based on the insight that x^y = 2^(log2(x) * y).

Requirements:
- All from "exp2", "log2" and "mul".
- z cannot be zero.

Caveats:
- All from "exp2", "log2" and "mul".
- Assumes 0^0 is 1._

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | Number to raise to given power y, as a signed 59.18-decimal fixed-point number. |
| y | int256 | Exponent to raise x to, as a signed 59.18-decimal fixed-point number. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | int256 | x raised to power y, as a signed 59.18-decimal fixed-point number. |

### powu

```solidity
function powu(int256 x, uint256 y) internal pure returns (int256 result)
```

Raises x (signed 59.18-decimal fixed-point number) to the power of y (basic unsigned integer) using the
famous algorithm "exponentiation by squaring".

_See https://en.wikipedia.org/wiki/Exponentiation_by_squaring

Requirements:
- All from "abs" and "PRBMath.mulDivFixedPoint".
- The result must fit within MAX_SD59x18.

Caveats:
- All from "PRBMath.mulDivFixedPoint".
- Assumes 0^0 is 1._

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | The base as a signed 59.18-decimal fixed-point number. |
| y | uint256 | The exponent as an uint256. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | int256 | The result as a signed 59.18-decimal fixed-point number. |

### scale

```solidity
function scale() internal pure returns (int256 result)
```

Returns 1 as a signed 59.18-decimal fixed-point number.

### sqrt

```solidity
function sqrt(int256 x) internal pure returns (int256 result)
```

Calculates the square root of x, rounding down.

_Uses the Babylonian method https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method.

Requirements:
- x cannot be negative.
- x must be less than MAX_SD59x18 / SCALE._

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | The signed 59.18-decimal fixed-point number for which to calculate the square root. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | int256 | The result as a signed 59.18-decimal fixed-point . |

### toInt

```solidity
function toInt(int256 x) internal pure returns (int256 result)
```

Converts a signed 59.18-decimal fixed-point number to basic integer form, rounding down in the process.

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | int256 | The signed 59.18-decimal fixed-point number to convert. |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | int256 | The same number in basic integer form. |

## FullMath

Facilitates multiplication and division that can have overflow of an intermediate value without any loss of precision

_Handles "phantom overflow" i.e., allows multiplication and division where an intermediate value overflows 256 bits_

### mulDiv

```solidity
function mulDiv(uint256 a, uint256 b, uint256 denominator) internal pure returns (uint256 result)
```

Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0

_Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv_

| Name | Type | Description |
| ---- | ---- | ----------- |
| a | uint256 | The multiplicand |
| b | uint256 | The multiplier |
| denominator | uint256 | The divisor |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | uint256 | The 256-bit result |

### mulDivRoundingUp

```solidity
function mulDivRoundingUp(uint256 a, uint256 b, uint256 denominator) internal pure returns (uint256 result)
```

Calculates ceil(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0

| Name | Type | Description |
| ---- | ---- | ----------- |
| a | uint256 | The multiplicand |
| b | uint256 | The multiplier |
| denominator | uint256 | The divisor |

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | uint256 | The 256-bit result |

## ISwapRouter

Functions for swapping tokens via Uniswap V3

### ExactInputSingleParams

```solidity
struct ExactInputSingleParams {
  address tokenIn;
  address tokenOut;
  uint24 fee;
  address recipient;
  uint256 deadline;
  uint256 amountIn;
  uint256 amountOutMinimum;
  uint160 sqrtPriceLimitX96;
}
```

### exactInputSingle

```solidity
function exactInputSingle(struct ISwapRouter.ExactInputSingleParams params) external payable returns (uint256 amountOut)
```

Swaps `amountIn` of one token for as much as possible of another token

| Name | Type | Description |
| ---- | ---- | ----------- |
| params | struct ISwapRouter.ExactInputSingleParams | The parameters necessary for the swap, encoded as `ExactInputSingleParams` in calldata |

| Name | Type | Description |
| ---- | ---- | ----------- |
| amountOut | uint256 | The amount of the received token |

### ExactInputParams

```solidity
struct ExactInputParams {
  bytes path;
  address recipient;
  uint256 deadline;
  uint256 amountIn;
  uint256 amountOutMinimum;
}
```

### exactInput

```solidity
function exactInput(struct ISwapRouter.ExactInputParams params) external payable returns (uint256 amountOut)
```

Swaps `amountIn` of one token for as much as possible of another along the specified path

| Name | Type | Description |
| ---- | ---- | ----------- |
| params | struct ISwapRouter.ExactInputParams | The parameters necessary for the multi-hop swap, encoded as `ExactInputParams` in calldata |

| Name | Type | Description |
| ---- | ---- | ----------- |
| amountOut | uint256 | The amount of the received token |

### ExactOutputSingleParams

```solidity
struct ExactOutputSingleParams {
  address tokenIn;
  address tokenOut;
  uint24 fee;
  address recipient;
  uint256 deadline;
  uint256 amountOut;
  uint256 amountInMaximum;
  uint160 sqrtPriceLimitX96;
}
```

### exactOutputSingle

```solidity
function exactOutputSingle(struct ISwapRouter.ExactOutputSingleParams params) external payable returns (uint256 amountIn)
```

Swaps as little as possible of one token for `amountOut` of another token

| Name | Type | Description |
| ---- | ---- | ----------- |
| params | struct ISwapRouter.ExactOutputSingleParams | The parameters necessary for the swap, encoded as `ExactOutputSingleParams` in calldata |

| Name | Type | Description |
| ---- | ---- | ----------- |
| amountIn | uint256 | The amount of the input token |

### ExactOutputParams

```solidity
struct ExactOutputParams {
  bytes path;
  address recipient;
  uint256 deadline;
  uint256 amountOut;
  uint256 amountInMaximum;
}
```

### exactOutput

```solidity
function exactOutput(struct ISwapRouter.ExactOutputParams params) external payable returns (uint256 amountIn)
```

Swaps as little as possible of one token for `amountOut` of another along the specified path (reversed)

| Name | Type | Description |
| ---- | ---- | ----------- |
| params | struct ISwapRouter.ExactOutputParams | The parameters necessary for the multi-hop swap, encoded as `ExactOutputParams` in calldata |

| Name | Type | Description |
| ---- | ---- | ----------- |
| amountIn | uint256 | The amount of the input token |

## IUniswapV2Router

### getAmountsOut

```solidity
function getAmountsOut(uint256 amountIn, address[] path) external view returns (uint256[] amounts)
```

### swapExactTokensForTokens

```solidity
function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external returns (uint256[] amounts)
```

### swapExactTokensForETH

```solidity
function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external returns (uint256[] amounts)
```

### swapExactETHForTokens

```solidity
function swapExactETHForTokens(uint256 amountOutMin, address[] path, address to, uint256 deadline) external payable returns (uint256[] amounts)
```

### addLiquidity

```solidity
function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB, uint256 liquidity)
```

### removeLiquidity

```solidity
function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB)
```

## IUniswapV2Pair

### Approval

```solidity
event Approval(address owner, address spender, uint256 value)
```

### Transfer

```solidity
event Transfer(address from, address to, uint256 value)
```

### name

```solidity
function name() external pure returns (string)
```

### symbol

```solidity
function symbol() external pure returns (string)
```

### decimals

```solidity
function decimals() external pure returns (uint8)
```

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```

### balanceOf

```solidity
function balanceOf(address owner) external view returns (uint256)
```

### allowance

```solidity
function allowance(address owner, address spender) external view returns (uint256)
```

### approve

```solidity
function approve(address spender, uint256 value) external returns (bool)
```

### transfer

```solidity
function transfer(address to, uint256 value) external returns (bool)
```

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 value) external returns (bool)
```

### DOMAIN_SEPARATOR

```solidity
function DOMAIN_SEPARATOR() external view returns (bytes32)
```

### PERMIT_TYPEHASH

```solidity
function PERMIT_TYPEHASH() external pure returns (bytes32)
```

### nonces

```solidity
function nonces(address owner) external view returns (uint256)
```

### permit

```solidity
function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external
```

### Mint

```solidity
event Mint(address sender, uint256 amount0, uint256 amount1)
```

### Burn

```solidity
event Burn(address sender, uint256 amount0, uint256 amount1, address to)
```

### Swap

```solidity
event Swap(address sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address to)
```

### Sync

```solidity
event Sync(uint112 reserve0, uint112 reserve1)
```

### MINIMUM_LIQUIDITY

```solidity
function MINIMUM_LIQUIDITY() external pure returns (uint256)
```

### factory

```solidity
function factory() external view returns (address)
```

### token0

```solidity
function token0() external view returns (address)
```

### token1

```solidity
function token1() external view returns (address)
```

### getReserves

```solidity
function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast)
```

### price0CumulativeLast

```solidity
function price0CumulativeLast() external view returns (uint256)
```

### price1CumulativeLast

```solidity
function price1CumulativeLast() external view returns (uint256)
```

### kLast

```solidity
function kLast() external view returns (uint256)
```

### mint

```solidity
function mint(address to) external returns (uint256 liquidity)
```

### burn

```solidity
function burn(address to) external returns (uint256 amount0, uint256 amount1)
```

### swap

```solidity
function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes data) external
```

### skim

```solidity
function skim(address to) external
```

### sync

```solidity
function sync() external
```

### initialize

```solidity
function initialize(address, address) external
```

## IUniswapV2Factory

### PairCreated

```solidity
event PairCreated(address token0, address token1, address pair, uint256)
```

### feeTo

```solidity
function feeTo() external view returns (address)
```

### feeToSetter

```solidity
function feeToSetter() external view returns (address)
```

### getPair

```solidity
function getPair(address tokenA, address tokenB) external view returns (address pair)
```

### allPairs

```solidity
function allPairs(uint256) external view returns (address pair)
```

### allPairsLength

```solidity
function allPairsLength() external view returns (uint256)
```

### createPair

```solidity
function createPair(address tokenA, address tokenB) external returns (address pair)
```

### setFeeTo

```solidity
function setFeeTo(address) external
```

### setFeeToSetter

```solidity
function setFeeToSetter(address) external
```

## IUniswapV3Factory

The Uniswap V3 Factory facilitates creation of Uniswap V3 pools and control over the protocol fees

### OwnerChanged

```solidity
event OwnerChanged(address oldOwner, address newOwner)
```

Emitted when the owner of the factory is changed

| Name | Type | Description |
| ---- | ---- | ----------- |
| oldOwner | address | The owner before the owner was changed |
| newOwner | address | The owner after the owner was changed |

### PoolCreated

```solidity
event PoolCreated(address token0, address token1, uint24 fee, int24 tickSpacing, address pool)
```

Emitted when a pool is created

| Name | Type | Description |
| ---- | ---- | ----------- |
| token0 | address | The first token of the pool by address sort order |
| token1 | address | The second token of the pool by address sort order |
| fee | uint24 | The fee collected upon every swap in the pool, denominated in hundredths of a bip |
| tickSpacing | int24 | The minimum number of ticks between initialized ticks |
| pool | address | The address of the created pool |

### FeeAmountEnabled

```solidity
event FeeAmountEnabled(uint24 fee, int24 tickSpacing)
```

Emitted when a new fee amount is enabled for pool creation via the factory

| Name | Type | Description |
| ---- | ---- | ----------- |
| fee | uint24 | The enabled fee, denominated in hundredths of a bip |
| tickSpacing | int24 | The minimum number of ticks between initialized ticks for pools created with the given fee |

### owner

```solidity
function owner() external view returns (address)
```

Returns the current owner of the factory

_Can be changed by the current owner via setOwner_

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | The address of the factory owner |

### feeAmountTickSpacing

```solidity
function feeAmountTickSpacing(uint24 fee) external view returns (int24)
```

Returns the tick spacing for a given fee amount, if enabled, or 0 if not enabled

_A fee amount can never be removed, so this value should be hard coded or cached in the calling context_

| Name | Type | Description |
| ---- | ---- | ----------- |
| fee | uint24 | The enabled fee, denominated in hundredths of a bip. Returns 0 in case of unenabled fee |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | int24 | The tick spacing |

### getPool

```solidity
function getPool(address tokenA, address tokenB, uint24 fee) external view returns (address pool)
```

Returns the pool address for a given pair of tokens and a fee, or address 0 if it does not exist

_tokenA and tokenB may be passed in either token0/token1 or token1/token0 order_

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenA | address | The contract address of either token0 or token1 |
| tokenB | address | The contract address of the other token |
| fee | uint24 | The fee collected upon every swap in the pool, denominated in hundredths of a bip |

| Name | Type | Description |
| ---- | ---- | ----------- |
| pool | address | The pool address |

### createPool

```solidity
function createPool(address tokenA, address tokenB, uint24 fee) external returns (address pool)
```

Creates a pool for the given two tokens and fee

_tokenA and tokenB may be passed in either order: token0/token1 or token1/token0. tickSpacing is retrieved
from the fee. The call will revert if the pool already exists, the fee is invalid, or the token arguments
are invalid._

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenA | address | One of the two tokens in the desired pool |
| tokenB | address | The other of the two tokens in the desired pool |
| fee | uint24 | The desired fee for the pool |

| Name | Type | Description |
| ---- | ---- | ----------- |
| pool | address | The address of the newly created pool |

### setOwner

```solidity
function setOwner(address _owner) external
```

Updates the owner of the factory

_Must be called by the current owner_

| Name | Type | Description |
| ---- | ---- | ----------- |
| _owner | address | The new owner of the factory |

### enableFeeAmount

```solidity
function enableFeeAmount(uint24 fee, int24 tickSpacing) external
```

Enables a fee amount with the given tickSpacing

_Fee amounts may never be removed once enabled_

| Name | Type | Description |
| ---- | ---- | ----------- |
| fee | uint24 | The fee amount to enable, denominated in hundredths of a bip (i.e. 1e-6) |
| tickSpacing | int24 | The spacing between ticks to be enforced for all pools created with the given fee amount |

## IUniswapV3Pool

A Uniswap pool facilitates swapping and automated market making between any two assets that strictly conform
to the ERC20 specification

_The pool interface is broken up into many smaller pieces_

## IUniswapV3SwapCallback

Any contract that calls IUniswapV3PoolActions#swap must implement this interface

### uniswapV3SwapCallback

```solidity
function uniswapV3SwapCallback(int256 amount0Delta, int256 amount1Delta, bytes data) external
```

Called to `msg.sender` after executing a swap via IUniswapV3Pool#swap.

_In the implementation you must pay the pool tokens owed for the swap.
The caller of this method must be checked to be a UniswapV3Pool deployed by the canonical UniswapV3Factory.
amount0Delta and amount1Delta can both be 0 if no tokens were swapped._

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount0Delta | int256 | The amount of token0 that was sent (negative) or must be received (positive) by the pool by the end of the swap. If positive, the callback must send that amount of token0 to the pool. |
| amount1Delta | int256 | The amount of token1 that was sent (negative) or must be received (positive) by the pool by the end of the swap. If positive, the callback must send that amount of token1 to the pool. |
| data | bytes | Any data passed through by the caller via the IUniswapV3PoolActions#swap call |

## OracleLibrary

Provides functions to integrate with V3 pool oracle

### consult

```solidity
function consult(address pool, uint32 secondsAgo) internal view returns (int24 arithmeticMeanTick, uint128 harmonicMeanLiquidity)
```

Calculates time-weighted means of tick and liquidity for a given Uniswap V3 pool

| Name | Type | Description |
| ---- | ---- | ----------- |
| pool | address | Address of the pool that we want to observe |
| secondsAgo | uint32 | Number of seconds in the past from which to calculate the time-weighted means |

| Name | Type | Description |
| ---- | ---- | ----------- |
| arithmeticMeanTick | int24 | The arithmetic mean tick from (block.timestamp - secondsAgo) to block.timestamp |
| harmonicMeanLiquidity | uint128 | The harmonic mean liquidity from (block.timestamp - secondsAgo) to block.timestamp |

### getQuoteAtTick

```solidity
function getQuoteAtTick(int24 tick, uint128 baseAmount, address baseToken, address quoteToken) internal pure returns (uint256 quoteAmount)
```

Given a tick and a token amount, calculates the amount of token received in exchange

| Name | Type | Description |
| ---- | ---- | ----------- |
| tick | int24 | Tick value used to calculate the quote |
| baseAmount | uint128 | Amount of token to be converted |
| baseToken | address | Address of an ERC20 token contract used as the baseAmount denomination |
| quoteToken | address | Address of an ERC20 token contract used as the quoteAmount denomination |

| Name | Type | Description |
| ---- | ---- | ----------- |
| quoteAmount | uint256 | Amount of quoteToken received for baseAmount of baseToken |

### getOldestObservationSecondsAgo

```solidity
function getOldestObservationSecondsAgo(address pool) internal view returns (uint32 secondsAgo)
```

Given a pool, it returns the number of seconds ago of the oldest stored observation

| Name | Type | Description |
| ---- | ---- | ----------- |
| pool | address | Address of Uniswap V3 pool that we want to observe |

| Name | Type | Description |
| ---- | ---- | ----------- |
| secondsAgo | uint32 | The number of seconds ago of the oldest observation stored for the pool |

### getBlockStartingTickAndLiquidity

```solidity
function getBlockStartingTickAndLiquidity(address pool) internal view returns (int24, uint128)
```

Given a pool, it returns the tick value as of the start of the current block

| Name | Type | Description |
| ---- | ---- | ----------- |
| pool | address | Address of Uniswap V3 pool |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | int24 | The tick that the pool was in at the start of the current block |
| [1] | uint128 |  |

### WeightedTickData

```solidity
struct WeightedTickData {
  int24 tick;
  uint128 weight;
}
```

### getWeightedArithmeticMeanTick

```solidity
function getWeightedArithmeticMeanTick(struct OracleLibrary.WeightedTickData[] weightedTickData) internal pure returns (int24 weightedArithmeticMeanTick)
```

Given an array of ticks and weights, calculates the weighted arithmetic mean tick

_Each entry of `weightedTickData` should represents ticks from pools with the same underlying pool tokens. If they do not,
extreme care must be taken to ensure that ticks are comparable (including decimal differences).
Note that the weighted arithmetic mean tick corresponds to the weighted geometric mean price._

| Name | Type | Description |
| ---- | ---- | ----------- |
| weightedTickData | struct OracleLibrary.WeightedTickData[] | An array of ticks and weights |

| Name | Type | Description |
| ---- | ---- | ----------- |
| weightedArithmeticMeanTick | int24 | The weighted arithmetic mean tick |

### getChainedPrice

```solidity
function getChainedPrice(address[] tokens, int24[] ticks) internal pure returns (int256 syntheticTick)
```

Returns the "synthetic" tick which represents the price of the first entry in `tokens` in terms of the last

_Useful for calculating relative prices along routes.
There must be one tick for each pairwise set of tokens._

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokens | address[] | The token contract addresses |
| ticks | int24[] | The ticks, representing the price of each token pair in `tokens` |

| Name | Type | Description |
| ---- | ---- | ----------- |
| syntheticTick | int256 | The synthetic tick, representing the relative price of the outermost tokens in `tokens` |

## TickMath

Computes sqrt price for ticks of size 1.0001, i.e. sqrt(1.0001^tick) as fixed point Q64.96 numbers. Supports
prices between 2**-128 and 2**128

### T

```solidity
error T()
```

### R

```solidity
error R()
```

### MIN_TICK

```solidity
int24 MIN_TICK
```

_The minimum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**-128_

### MAX_TICK

```solidity
int24 MAX_TICK
```

_The maximum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**128_

### MIN_SQRT_RATIO

```solidity
uint160 MIN_SQRT_RATIO
```

_The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)_

### MAX_SQRT_RATIO

```solidity
uint160 MAX_SQRT_RATIO
```

_The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)_

### getSqrtRatioAtTick

```solidity
function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96)
```

Calculates sqrt(1.0001^tick) * 2^96

_Throws if |tick| > max tick_

| Name | Type | Description |
| ---- | ---- | ----------- |
| tick | int24 | The input tick for the above formula |

| Name | Type | Description |
| ---- | ---- | ----------- |
| sqrtPriceX96 | uint160 | A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0) at the given tick |

### getTickAtSqrtRatio

```solidity
function getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick)
```

Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio

_Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
ever return._

| Name | Type | Description |
| ---- | ---- | ----------- |
| sqrtPriceX96 | uint160 | The sqrt ratio for which to compute the tick as a Q64.96 |

| Name | Type | Description |
| ---- | ---- | ----------- |
| tick | int24 | The greatest tick for which the ratio is less than or equal to the input ratio |

## TransferHelper

### safeTransferFrom

```solidity
function safeTransferFrom(address token, address from, address to, uint256 value) internal
```

Transfers tokens from the targeted address to the given destination
Errors with 'STF' if transfer fails

| Name | Type | Description |
| ---- | ---- | ----------- |
| token | address | The contract address of the token to be transferred |
| from | address | The originating address from which the tokens will be transferred |
| to | address | The destination address of the transfer |
| value | uint256 | The amount to be transferred |

### safeTransfer

```solidity
function safeTransfer(address token, address to, uint256 value) internal
```

Transfers tokens from msg.sender to a recipient

_Errors with ST if transfer fails_

| Name | Type | Description |
| ---- | ---- | ----------- |
| token | address | The contract address of the token which will be transferred |
| to | address | The recipient of the transfer |
| value | uint256 | The value of the transfer |

### safeApprove

```solidity
function safeApprove(address token, address to, uint256 value) internal
```

Approves the stipulated contract to spend the given allowance in the given token

_Errors with 'SA' if transfer fails_

| Name | Type | Description |
| ---- | ---- | ----------- |
| token | address | The contract address of the token to be approved |
| to | address | The target of the approval |
| value | uint256 | The amount of the given token the target will be allowed to spend |

### safeTransferETH

```solidity
function safeTransferETH(address to, uint256 value) internal
```

Transfers ETH to the recipient address

_Fails with `STE`_

| Name | Type | Description |
| ---- | ---- | ----------- |
| to | address | The destination of the transfer |
| value | uint256 | The value to be transferred |

## IUniswapV3PoolActions

Contains pool methods that can be called by anyone

### initialize

```solidity
function initialize(uint160 sqrtPriceX96) external
```

Sets the initial price for the pool

_Price is represented as a sqrt(amountToken1/amountToken0) Q64.96 value_

| Name | Type | Description |
| ---- | ---- | ----------- |
| sqrtPriceX96 | uint160 | the initial sqrt price of the pool as a Q64.96 |

### mint

```solidity
function mint(address recipient, int24 tickLower, int24 tickUpper, uint128 amount, bytes data) external returns (uint256 amount0, uint256 amount1)
```

Adds liquidity for the given recipient/tickLower/tickUpper position

_The caller of this method receives a callback in the form of IUniswapV3MintCallback#uniswapV3MintCallback
in which they must pay any token0 or token1 owed for the liquidity. The amount of token0/token1 due depends
on tickLower, tickUpper, the amount of liquidity, and the current price._

| Name | Type | Description |
| ---- | ---- | ----------- |
| recipient | address | The address for which the liquidity will be created |
| tickLower | int24 | The lower tick of the position in which to add liquidity |
| tickUpper | int24 | The upper tick of the position in which to add liquidity |
| amount | uint128 | The amount of liquidity to mint |
| data | bytes | Any data that should be passed through to the callback |

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount0 | uint256 | The amount of token0 that was paid to mint the given amount of liquidity. Matches the value in the callback |
| amount1 | uint256 | The amount of token1 that was paid to mint the given amount of liquidity. Matches the value in the callback |

### collect

```solidity
function collect(address recipient, int24 tickLower, int24 tickUpper, uint128 amount0Requested, uint128 amount1Requested) external returns (uint128 amount0, uint128 amount1)
```

Collects tokens owed to a position

_Does not recompute fees earned, which must be done either via mint or burn of any amount of liquidity.
Collect must be called by the position owner. To withdraw only token0 or only token1, amount0Requested or
amount1Requested may be set to zero. To withdraw all tokens owed, caller may pass any value greater than the
actual tokens owed, e.g. type(uint128).max. Tokens owed may be from accumulated swap fees or burned liquidity._

| Name | Type | Description |
| ---- | ---- | ----------- |
| recipient | address | The address which should receive the fees collected |
| tickLower | int24 | The lower tick of the position for which to collect fees |
| tickUpper | int24 | The upper tick of the position for which to collect fees |
| amount0Requested | uint128 | How much token0 should be withdrawn from the fees owed |
| amount1Requested | uint128 | How much token1 should be withdrawn from the fees owed |

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount0 | uint128 | The amount of fees collected in token0 |
| amount1 | uint128 | The amount of fees collected in token1 |

### burn

```solidity
function burn(int24 tickLower, int24 tickUpper, uint128 amount) external returns (uint256 amount0, uint256 amount1)
```

Burn liquidity from the sender and account tokens owed for the liquidity to the position

_Can be used to trigger a recalculation of fees owed to a position by calling with an amount of 0
Fees must be collected separately via a call to #collect_

| Name | Type | Description |
| ---- | ---- | ----------- |
| tickLower | int24 | The lower tick of the position for which to burn liquidity |
| tickUpper | int24 | The upper tick of the position for which to burn liquidity |
| amount | uint128 | How much liquidity to burn |

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount0 | uint256 | The amount of token0 sent to the recipient |
| amount1 | uint256 | The amount of token1 sent to the recipient |

### swap

```solidity
function swap(address recipient, bool zeroForOne, int256 amountSpecified, uint160 sqrtPriceLimitX96, bytes data) external returns (int256 amount0, int256 amount1)
```

Swap token0 for token1, or token1 for token0

_The caller of this method receives a callback in the form of IUniswapV3SwapCallback#uniswapV3SwapCallback_

| Name | Type | Description |
| ---- | ---- | ----------- |
| recipient | address | The address to receive the output of the swap |
| zeroForOne | bool | The direction of the swap, true for token0 to token1, false for token1 to token0 |
| amountSpecified | int256 | The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative) |
| sqrtPriceLimitX96 | uint160 | The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this value after the swap. If one for zero, the price cannot be greater than this value after the swap |
| data | bytes | Any data to be passed through to the callback |

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount0 | int256 | The delta of the balance of token0 of the pool, exact when negative, minimum when positive |
| amount1 | int256 | The delta of the balance of token1 of the pool, exact when negative, minimum when positive |

### flash

```solidity
function flash(address recipient, uint256 amount0, uint256 amount1, bytes data) external
```

Receive token0 and/or token1 and pay it back, plus a fee, in the callback

_The caller of this method receives a callback in the form of IUniswapV3FlashCallback#uniswapV3FlashCallback
Can be used to donate underlying tokens pro-rata to currently in-range liquidity providers by calling
with 0 amount{0,1} and sending the donation amount(s) from the callback_

| Name | Type | Description |
| ---- | ---- | ----------- |
| recipient | address | The address which will receive the token0 and token1 amounts |
| amount0 | uint256 | The amount of token0 to send |
| amount1 | uint256 | The amount of token1 to send |
| data | bytes | Any data to be passed through to the callback |

### increaseObservationCardinalityNext

```solidity
function increaseObservationCardinalityNext(uint16 observationCardinalityNext) external
```

Increase the maximum number of price and liquidity observations that this pool will store

_This method is no-op if the pool already has an observationCardinalityNext greater than or equal to
the input observationCardinalityNext._

| Name | Type | Description |
| ---- | ---- | ----------- |
| observationCardinalityNext | uint16 | The desired minimum number of observations for the pool to store |

## IUniswapV3PoolDerivedState

Contains view functions to provide information about the pool that is computed rather than stored on the
blockchain. The functions here may have variable gas costs.

### observe

```solidity
function observe(uint32[] secondsAgos) external view returns (int56[] tickCumulatives, uint160[] secondsPerLiquidityCumulativeX128s)
```

Returns the cumulative tick and liquidity as of each timestamp `secondsAgo` from the current block timestamp

_To get a time weighted average tick or liquidity-in-range, you must call this with two values, one representing
the beginning of the period and another for the end of the period. E.g., to get the last hour time-weighted average tick,
you must call it with secondsAgos = [3600, 0].
The time weighted average tick represents the geometric time weighted average price of the pool, in
log base sqrt(1.0001) of token1 / token0. The TickMath library can be used to go from a tick value to a ratio._

| Name | Type | Description |
| ---- | ---- | ----------- |
| secondsAgos | uint32[] | From how long ago each cumulative tick and liquidity value should be returned |

| Name | Type | Description |
| ---- | ---- | ----------- |
| tickCumulatives | int56[] | Cumulative tick values as of each `secondsAgos` from the current block timestamp |
| secondsPerLiquidityCumulativeX128s | uint160[] | Cumulative seconds per liquidity-in-range value as of each `secondsAgos` from the current block timestamp |

### snapshotCumulativesInside

```solidity
function snapshotCumulativesInside(int24 tickLower, int24 tickUpper) external view returns (int56 tickCumulativeInside, uint160 secondsPerLiquidityInsideX128, uint32 secondsInside)
```

Returns a snapshot of the tick cumulative, seconds per liquidity and seconds inside a tick range

_Snapshots must only be compared to other snapshots, taken over a period for which a position existed.
I.e., snapshots cannot be compared if a position is not held for the entire period between when the first
snapshot is taken and the second snapshot is taken._

| Name | Type | Description |
| ---- | ---- | ----------- |
| tickLower | int24 | The lower tick of the range |
| tickUpper | int24 | The upper tick of the range |

| Name | Type | Description |
| ---- | ---- | ----------- |
| tickCumulativeInside | int56 | The snapshot of the tick accumulator for the range |
| secondsPerLiquidityInsideX128 | uint160 | The snapshot of seconds per liquidity for the range |
| secondsInside | uint32 | The snapshot of seconds per liquidity for the range |

## IUniswapV3PoolErrors

Contains all events emitted by the pool

### LOK

```solidity
error LOK()
```

### TLU

```solidity
error TLU()
```

### TLM

```solidity
error TLM()
```

### TUM

```solidity
error TUM()
```

### AI

```solidity
error AI()
```

### M0

```solidity
error M0()
```

### M1

```solidity
error M1()
```

### AS

```solidity
error AS()
```

### IIA

```solidity
error IIA()
```

### L

```solidity
error L()
```

### F0

```solidity
error F0()
```

### F1

```solidity
error F1()
```

## IUniswapV3PoolEvents

Contains all events emitted by the pool

### Initialize

```solidity
event Initialize(uint160 sqrtPriceX96, int24 tick)
```

Emitted exactly once by a pool when #initialize is first called on the pool

_Mint/Burn/Swap cannot be emitted by the pool before Initialize_

| Name | Type | Description |
| ---- | ---- | ----------- |
| sqrtPriceX96 | uint160 | The initial sqrt price of the pool, as a Q64.96 |
| tick | int24 | The initial tick of the pool, i.e. log base 1.0001 of the starting price of the pool |

### Mint

```solidity
event Mint(address sender, address owner, int24 tickLower, int24 tickUpper, uint128 amount, uint256 amount0, uint256 amount1)
```

Emitted when liquidity is minted for a given position

| Name | Type | Description |
| ---- | ---- | ----------- |
| sender | address | The address that minted the liquidity |
| owner | address | The owner of the position and recipient of any minted liquidity |
| tickLower | int24 | The lower tick of the position |
| tickUpper | int24 | The upper tick of the position |
| amount | uint128 | The amount of liquidity minted to the position range |
| amount0 | uint256 | How much token0 was required for the minted liquidity |
| amount1 | uint256 | How much token1 was required for the minted liquidity |

### Collect

```solidity
event Collect(address owner, address recipient, int24 tickLower, int24 tickUpper, uint128 amount0, uint128 amount1)
```

Emitted when fees are collected by the owner of a position

_Collect events may be emitted with zero amount0 and amount1 when the caller chooses not to collect fees_

| Name | Type | Description |
| ---- | ---- | ----------- |
| owner | address | The owner of the position for which fees are collected |
| recipient | address |  |
| tickLower | int24 | The lower tick of the position |
| tickUpper | int24 | The upper tick of the position |
| amount0 | uint128 | The amount of token0 fees collected |
| amount1 | uint128 | The amount of token1 fees collected |

### Burn

```solidity
event Burn(address owner, int24 tickLower, int24 tickUpper, uint128 amount, uint256 amount0, uint256 amount1)
```

Emitted when a position's liquidity is removed

_Does not withdraw any fees earned by the liquidity position, which must be withdrawn via #collect_

| Name | Type | Description |
| ---- | ---- | ----------- |
| owner | address | The owner of the position for which liquidity is removed |
| tickLower | int24 | The lower tick of the position |
| tickUpper | int24 | The upper tick of the position |
| amount | uint128 | The amount of liquidity to remove |
| amount0 | uint256 | The amount of token0 withdrawn |
| amount1 | uint256 | The amount of token1 withdrawn |

### Swap

```solidity
event Swap(address sender, address recipient, int256 amount0, int256 amount1, uint160 sqrtPriceX96, uint128 liquidity, int24 tick)
```

Emitted by the pool for any swaps between token0 and token1

| Name | Type | Description |
| ---- | ---- | ----------- |
| sender | address | The address that initiated the swap call, and that received the callback |
| recipient | address | The address that received the output of the swap |
| amount0 | int256 | The delta of the token0 balance of the pool |
| amount1 | int256 | The delta of the token1 balance of the pool |
| sqrtPriceX96 | uint160 | The sqrt(price) of the pool after the swap, as a Q64.96 |
| liquidity | uint128 | The liquidity of the pool after the swap |
| tick | int24 | The log base 1.0001 of price of the pool after the swap |

### Flash

```solidity
event Flash(address sender, address recipient, uint256 amount0, uint256 amount1, uint256 paid0, uint256 paid1)
```

Emitted by the pool for any flashes of token0/token1

| Name | Type | Description |
| ---- | ---- | ----------- |
| sender | address | The address that initiated the swap call, and that received the callback |
| recipient | address | The address that received the tokens from flash |
| amount0 | uint256 | The amount of token0 that was flashed |
| amount1 | uint256 | The amount of token1 that was flashed |
| paid0 | uint256 | The amount of token0 paid for the flash, which can exceed the amount0 plus the fee |
| paid1 | uint256 | The amount of token1 paid for the flash, which can exceed the amount1 plus the fee |

### IncreaseObservationCardinalityNext

```solidity
event IncreaseObservationCardinalityNext(uint16 observationCardinalityNextOld, uint16 observationCardinalityNextNew)
```

Emitted by the pool for increases to the number of observations that can be stored

_observationCardinalityNext is not the observation cardinality until an observation is written at the index
just before a mint/swap/burn._

| Name | Type | Description |
| ---- | ---- | ----------- |
| observationCardinalityNextOld | uint16 | The previous value of the next observation cardinality |
| observationCardinalityNextNew | uint16 | The updated value of the next observation cardinality |

### SetFeeProtocol

```solidity
event SetFeeProtocol(uint8 feeProtocol0Old, uint8 feeProtocol1Old, uint8 feeProtocol0New, uint8 feeProtocol1New)
```

Emitted when the protocol fee is changed by the pool

| Name | Type | Description |
| ---- | ---- | ----------- |
| feeProtocol0Old | uint8 | The previous value of the token0 protocol fee |
| feeProtocol1Old | uint8 | The previous value of the token1 protocol fee |
| feeProtocol0New | uint8 | The updated value of the token0 protocol fee |
| feeProtocol1New | uint8 | The updated value of the token1 protocol fee |

### CollectProtocol

```solidity
event CollectProtocol(address sender, address recipient, uint128 amount0, uint128 amount1)
```

Emitted when the collected protocol fees are withdrawn by the factory owner

| Name | Type | Description |
| ---- | ---- | ----------- |
| sender | address | The address that collects the protocol fees |
| recipient | address | The address that receives the collected protocol fees |
| amount0 | uint128 | The amount of token0 protocol fees that is withdrawn |
| amount1 | uint128 |  |

## IUniswapV3PoolImmutables

These parameters are fixed for a pool forever, i.e., the methods will always return the same values

### factory

```solidity
function factory() external view returns (address)
```

The contract that deployed the pool, which must adhere to the IUniswapV3Factory interface

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | The contract address |

### token0

```solidity
function token0() external view returns (address)
```

The first of the two tokens of the pool, sorted by address

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | The token contract address |

### token1

```solidity
function token1() external view returns (address)
```

The second of the two tokens of the pool, sorted by address

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | The token contract address |

### fee

```solidity
function fee() external view returns (uint24)
```

The pool's fee in hundredths of a bip, i.e. 1e-6

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint24 | The fee |

### tickSpacing

```solidity
function tickSpacing() external view returns (int24)
```

The pool tick spacing

_Ticks can only be used at multiples of this value, minimum of 1 and always positive
e.g.: a tickSpacing of 3 means ticks can be initialized every 3rd tick, i.e., ..., -6, -3, 0, 3, 6, ...
This value is an int24 to avoid casting even though it is always positive._

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | int24 | The tick spacing |

### maxLiquidityPerTick

```solidity
function maxLiquidityPerTick() external view returns (uint128)
```

The maximum amount of position liquidity that can use any tick in the range

_This parameter is enforced per tick to prevent liquidity from overflowing a uint128 at any point, and
also prevents out-of-range liquidity from being used to prevent adding in-range liquidity to a pool_

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint128 | The max amount of liquidity per tick |

## IUniswapV3PoolOwnerActions

Contains pool methods that may only be called by the factory owner

### setFeeProtocol

```solidity
function setFeeProtocol(uint8 feeProtocol0, uint8 feeProtocol1) external
```

Set the denominator of the protocol's % share of the fees

| Name | Type | Description |
| ---- | ---- | ----------- |
| feeProtocol0 | uint8 | new protocol fee for token0 of the pool |
| feeProtocol1 | uint8 | new protocol fee for token1 of the pool |

### collectProtocol

```solidity
function collectProtocol(address recipient, uint128 amount0Requested, uint128 amount1Requested) external returns (uint128 amount0, uint128 amount1)
```

Collect the protocol fee accrued to the pool

| Name | Type | Description |
| ---- | ---- | ----------- |
| recipient | address | The address to which collected protocol fees should be sent |
| amount0Requested | uint128 | The maximum amount of token0 to send, can be 0 to collect fees in only token1 |
| amount1Requested | uint128 | The maximum amount of token1 to send, can be 0 to collect fees in only token0 |

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount0 | uint128 | The protocol fee collected in token0 |
| amount1 | uint128 | The protocol fee collected in token1 |

## IUniswapV3PoolState

These methods compose the pool's state, and can change with any frequency including multiple times
per transaction

### slot0

```solidity
function slot0() external view returns (uint160 sqrtPriceX96, int24 tick, uint16 observationIndex, uint16 observationCardinality, uint16 observationCardinalityNext, uint8 feeProtocol, bool unlocked)
```

The 0th storage slot in the pool stores many values, and is exposed as a single method to save gas
when accessed externally.

| Name | Type | Description |
| ---- | ---- | ----------- |
| sqrtPriceX96 | uint160 | The current price of the pool as a sqrt(token1/token0) Q64.96 value |
| tick | int24 | The current tick of the pool, i.e. according to the last tick transition that was run. This value may not always be equal to SqrtTickMath.getTickAtSqrtRatio(sqrtPriceX96) if the price is on a tick boundary. |
| observationIndex | uint16 | The index of the last oracle observation that was written, |
| observationCardinality | uint16 | The current maximum number of observations stored in the pool, |
| observationCardinalityNext | uint16 | The next maximum number of observations, to be updated when the observation. |
| feeProtocol | uint8 | The protocol fee for both tokens of the pool. Encoded as two 4 bit values, where the protocol fee of token1 is shifted 4 bits and the protocol fee of token0 is the lower 4 bits. Used as the denominator of a fraction of the swap fee, e.g. 4 means 1/4th of the swap fee. unlocked Whether the pool is currently locked to reentrancy |
| unlocked | bool |  |

### feeGrowthGlobal0X128

```solidity
function feeGrowthGlobal0X128() external view returns (uint256)
```

The fee growth as a Q128.128 fees of token0 collected per unit of liquidity for the entire life of the pool

_This value can overflow the uint256_

### feeGrowthGlobal1X128

```solidity
function feeGrowthGlobal1X128() external view returns (uint256)
```

The fee growth as a Q128.128 fees of token1 collected per unit of liquidity for the entire life of the pool

_This value can overflow the uint256_

### protocolFees

```solidity
function protocolFees() external view returns (uint128 token0, uint128 token1)
```

The amounts of token0 and token1 that are owed to the protocol

_Protocol fees will never exceed uint128 max in either token_

### liquidity

```solidity
function liquidity() external view returns (uint128)
```

The currently in range liquidity available to the pool

_This value has no relationship to the total liquidity across all ticks_

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint128 | The liquidity at the current price of the pool |

### ticks

```solidity
function ticks(int24 tick) external view returns (uint128 liquidityGross, int128 liquidityNet, uint256 feeGrowthOutside0X128, uint256 feeGrowthOutside1X128, int56 tickCumulativeOutside, uint160 secondsPerLiquidityOutsideX128, uint32 secondsOutside, bool initialized)
```

Look up information about a specific tick in the pool

| Name | Type | Description |
| ---- | ---- | ----------- |
| tick | int24 | The tick to look up |

| Name | Type | Description |
| ---- | ---- | ----------- |
| liquidityGross | uint128 | the total amount of position liquidity that uses the pool either as tick lower or tick upper |
| liquidityNet | int128 | how much liquidity changes when the pool price crosses the tick, |
| feeGrowthOutside0X128 | uint256 | the fee growth on the other side of the tick from the current tick in token0, |
| feeGrowthOutside1X128 | uint256 | the fee growth on the other side of the tick from the current tick in token1, |
| tickCumulativeOutside | int56 | the cumulative tick value on the other side of the tick from the current tick |
| secondsPerLiquidityOutsideX128 | uint160 | the seconds spent per liquidity on the other side of the tick from the current tick, |
| secondsOutside | uint32 | the seconds spent on the other side of the tick from the current tick, |
| initialized | bool | Set to true if the tick is initialized, i.e. liquidityGross is greater than 0, otherwise equal to false. Outside values can only be used if the tick is initialized, i.e. if liquidityGross is greater than 0. In addition, these values are only relative and must be used only in comparison to previous snapshots for a specific position. |

### tickBitmap

```solidity
function tickBitmap(int16 wordPosition) external view returns (uint256)
```

Returns 256 packed tick initialized boolean values. See TickBitmap for more information

### positions

```solidity
function positions(bytes32 key) external view returns (uint128 liquidity, uint256 feeGrowthInside0LastX128, uint256 feeGrowthInside1LastX128, uint128 tokensOwed0, uint128 tokensOwed1)
```

Returns the information about a position by the position's key

| Name | Type | Description |
| ---- | ---- | ----------- |
| key | bytes32 | The position's key is a hash of a preimage composed by the owner, tickLower and tickUpper |

| Name | Type | Description |
| ---- | ---- | ----------- |
| liquidity | uint128 | The amount of liquidity in the position, |
| feeGrowthInside0LastX128 | uint256 | fee growth of token0 inside the tick range as of the last mint/burn/poke, |
| feeGrowthInside1LastX128 | uint256 | fee growth of token1 inside the tick range as of the last mint/burn/poke, |
| tokensOwed0 | uint128 | the computed amount of token0 owed to the position as of the last mint/burn/poke, |
| tokensOwed1 | uint128 | the computed amount of token1 owed to the position as of the last mint/burn/poke |

### observations

```solidity
function observations(uint256 index) external view returns (uint32 blockTimestamp, int56 tickCumulative, uint160 secondsPerLiquidityCumulativeX128, bool initialized)
```

Returns data about a specific observation index

_You most likely want to use #observe() instead of this method to get an observation as of some amount of time
ago, rather than at a specific index in the array._

| Name | Type | Description |
| ---- | ---- | ----------- |
| index | uint256 | The element of the observations array to fetch |

| Name | Type | Description |
| ---- | ---- | ----------- |
| blockTimestamp | uint32 | The timestamp of the observation, |
| tickCumulative | int56 | the tick multiplied by seconds elapsed for the life of the pool as of the observation timestamp, |
| secondsPerLiquidityCumulativeX128 | uint160 | the seconds per in range liquidity for the life of the pool as of the observation timestamp, |
| initialized | bool | whether the observation has been initialized and the values are safe to use |

## ERC20Wrapper

### ERC20addr

```solidity
address ERC20addr
```

### setAddress

```solidity
function setAddress(address addr) public returns (bool)
```

### sendERC20

```solidity
function sendERC20(uint256 tokenAmount) public payable
```

## BSC

Replicates a curved option that hedges IL on Uniswap V2

_Needs to be refactored for legibility @kirrya95_

### BSCurvedParams

```solidity
struct BSCurvedParams {
  int256 K;
  int256 T;
  int256 r;
  int256 sigma;
  int256 tv0;
}
```

### CurvedInput

```solidity
struct CurvedInput {
  int256 S;
  int256 K;
  int256 T;
  int256 r;
  int256 sigma;
  int256 tv0;
}
```

### BSC_params

```solidity
struct BSC_params {
  address tokenA;
  address tokenB;
  uint256 tokenA_balance;
  uint256 tokenB_balance;
  bool isCall;
  bool isLong;
  uint256 amount;
  uint256 expiry;
  uint256 fees;
  uint256 perDay;
  uint256 hedgeFee;
  uint256 lastHedgeTimeStamp;
  struct BSC.BSCurvedParams parameters;
}
```

### Delta

```solidity
function Delta(struct BSC.CurvedInput _params, int256 z) public pure returns (int256)
```

### RootFirstPart

```solidity
function RootFirstPart(struct BSC.CurvedInput _params, int256 z) public pure returns (int256)
```

### RootSecondPart

```solidity
function RootSecondPart(struct BSC.CurvedInput _params, int256 z) public pure returns (int256)
```

### Z1

```solidity
function Z1(struct BSC.CurvedInput _params) public pure returns (int256)
```

### Z2

```solidity
function Z2(struct BSC.CurvedInput _params) public pure returns (int256)
```

### BSPutRootFirstPart

```solidity
function BSPutRootFirstPart(struct BSC.CurvedInput _params) public pure returns (int256)
```

### BSPutRootSecondPart

```solidity
function BSPutRootSecondPart(struct BSC.CurvedInput _params) public pure returns (int256)
```

### BS_root_put

```solidity
function BS_root_put(struct BSC.CurvedInput _params) public pure returns (int256)
```

### delta_BS_root_put

```solidity
function delta_BS_root_put(struct BSC.CurvedInput _params) public pure returns (int256)
```

### BSCallRootFirstPart

```solidity
function BSCallRootFirstPart(struct BSC.CurvedInput _params) public pure returns (int256)
```

### BSCallRootSecondPart

```solidity
function BSCallRootSecondPart(struct BSC.CurvedInput _params) public pure returns (int256)
```

### BS_root_call

```solidity
function BS_root_call(struct BSC.CurvedInput _params) public pure returns (int256)
```

### delta_BS_root_call

```solidity
function delta_BS_root_call(struct BSC.CurvedInput _params) public pure returns (int256)
```

## BS

### BSOptionParams

```solidity
struct BSOptionParams {
  int256 K;
  int256 T;
  int256 r;
  int256 sigma;
}
```

### BlackScholesInput

```solidity
struct BlackScholesInput {
  int256 S;
  int256 K;
  int256 T;
  int256 r;
  int256 sigma;
}
```

### BS_params

```solidity
struct BS_params {
  address tokenA;
  address tokenB;
  uint256 tokenA_balance;
  uint256 tokenB_balance;
  bool isCall;
  bool isLong;
  uint256 amount;
  uint256 expiry;
  uint256 fees;
  uint256 perDay;
  uint256 hedgeFee;
  uint256 lastHedgeTimeStamp;
  struct BS.BSOptionParams parameters;
}
```

### D1

```solidity
function D1(int256 S, int256 K, int256 r, int256 sigma, int256 T) public pure returns (int256)
```

### D2

```solidity
function D2(int256 d1, int256 sigma, int256 T) public pure returns (int256)
```

### BS_CALL

```solidity
function BS_CALL(struct BS.BlackScholesInput _params) public pure returns (int256 C, int256 delta)
```

### c_BS_CALL

```solidity
function c_BS_CALL(struct BS.BlackScholesInput _params) public pure returns (int256 C)
```

### delta_BS_CALL

```solidity
function delta_BS_CALL(struct BS.BlackScholesInput _params) public pure returns (int256 delta)
```

### BS_PUT

```solidity
function BS_PUT(struct BS.BlackScholesInput _params) public pure returns (int256 C, int256 delta)
```

### c_BS_PUT

```solidity
function c_BS_PUT(struct BS.BlackScholesInput _params) public pure returns (int256 C)
```

### delta_BS_PUT

```solidity
function delta_BS_PUT(struct BS.BlackScholesInput _params) public pure returns (int256 delta)
```

## Complex

Huge thanks to the authors of the the mds1/solidity-trigonometry and prb/math repositories

### complex

```solidity
struct complex {
  int256 re;
  int256 im;
}
```

### add

```solidity
function add(int256 re, int256 im, int256 re1, int256 im1) public pure returns (int256, int256)
```

### sub

```solidity
function sub(int256 re, int256 im, int256 re1, int256 im1) public pure returns (int256, int256)
```

### mul

```solidity
function mul(int256 re, int256 im, int256 re1, int256 im1) public pure returns (int256, int256)
```

### div

```solidity
function div(int256 re, int256 im, int256 re1, int256 im1) public pure returns (int256, int256)
```

### r2

```solidity
function r2(int256 a, int256 b) public pure returns (int256)
```

### toPolar

```solidity
function toPolar(int256 re, int256 im) public pure returns (int256, int256)
```

### fromPolar

```solidity
function fromPolar(int256 r, int256 T) public pure returns (int256 re, int256 im)
```

### atan2

```solidity
function atan2(int256 y, int256 x) public pure returns (int256 T)
```

### p_atan2

```solidity
function p_atan2(int256 y, int256 x) public pure returns (int256 T)
```

### atan1to1

```solidity
function atan1to1(int256 x) public pure returns (int256)
```

### complexLN

```solidity
function complexLN(int256 re, int256 im) public pure returns (int256, int256)
```

### complexSQRT

```solidity
function complexSQRT(int256 re, int256 im) public pure returns (int256, int256)
```

### complexEXP

```solidity
function complexEXP(int256 re, int256 im) public pure returns (int256, int256)
```

### complexPOW

```solidity
function complexPOW(int256 re, int256 im, int256 n) public pure returns (int256, int256)
```

### gasTest

```solidity
function gasTest(int256 re, int256 im, int256 runs) public pure returns (int256, int256)
```

## HedgeMath

### calculatePerHedgeFee

```solidity
function calculatePerHedgeFee(int256 expiry, int256 fees, int256 perDay) public pure returns (int256)
```

### convertYeartoSeconds

```solidity
function convertYeartoSeconds(int256 YEAR) public pure returns (int256)
```

### convertSecondstoYear

```solidity
function convertSecondstoYear(int256 SECONDS) public pure returns (int256)
```

### getTimeStampInterval

```solidity
function getTimeStampInterval(uint256 perDay) public pure returns (uint256)
```

### calculatePreviousDelta

```solidity
function calculatePreviousDelta(uint256 tokenB_balance, uint256 amount) public pure returns (int256 previousDelta)
```

### minimum_Liquidity_Call

```solidity
function minimum_Liquidity_Call(uint256 amount, int256 delta, int256 price) public pure returns (uint256 minimum)
```

### minimum_Liquidity_Put

```solidity
function minimum_Liquidity_Put(uint256 amount, int256 delta) public pure returns (uint256 minimum)
```

## Heston

### iterations

```solidity
int256 iterations
```

### P

```solidity
int256 P
```

### maxNumber

```solidity
int256 maxNumber
```

### element

```solidity
struct element {
  int256 a;
  int256 b;
  int256 c;
  int256 d;
}
```

### Vals

```solidity
struct Heston.element Vals
```

### equation

```solidity
struct equation {
  int256 num1;
  int256 num2;
  int256 deno;
}
```

### hestonEq

```solidity
struct Heston.equation hestonEq
```

### tokenVals

```solidity
struct tokenVals {
  int256 rate;
  int256 sigma;
  int256 kappa;
  int256 theta;
  int256 volvol;
  int256 rho;
}
```

## JDM

### JDMOptionParams

```solidity
struct JDMOptionParams {
  int256 K;
  int256 T;
  int256 r;
  int256 sigma;
  int256 m;
  int256 v;
  int256 lam;
}
```

### MertonInput

```solidity
struct MertonInput {
  int256 S;
  int256 K;
  int256 T;
  int256 r;
  int256 sigma;
  int256 m;
  int256 v;
  int256 lam;
}
```

### JDM_params

```solidity
struct JDM_params {
  address tokenA;
  address tokenB;
  uint256 tokenA_balance;
  uint256 tokenB_balance;
  bool isCall;
  bool isLong;
  uint256 amount;
  uint256 expiry;
  uint256 fees;
  uint256 perDay;
  uint256 hedgeFee;
  uint256 lastHedgeTimeStamp;
  struct JDM.JDMOptionParams parameters;
}
```

### factorial

```solidity
function factorial(uint256 index) public pure returns (uint256)
```

### D1

```solidity
function D1(int256 S, int256 K, int256 r, int256 sigma, int256 T) public pure returns (int256)
```

### D2

```solidity
function D2(int256 d1, int256 sigma, int256 T) public pure returns (int256)
```

### BS_CALL

```solidity
function BS_CALL(int256 S, int256 K, int256 T, int256 r, int256 sigma) public pure returns (int256)
```

### BS_PUT

```solidity
function BS_PUT(int256 S, int256 K, int256 T, int256 r, int256 sigma) public pure returns (int256)
```

### delta_BS_CALL

```solidity
function delta_BS_CALL(int256 S, int256 K, int256 T, int256 r, int256 sigma) public pure returns (int256)
```

### delta_BS_PUT

```solidity
function delta_BS_PUT(int256 S, int256 K, int256 T, int256 r, int256 sigma) public pure returns (int256)
```

### RK

```solidity
function RK(int256 r, int256 lam, int256 m, int256 k, int256 T) public pure returns (int256)
```

### SIGMA_K

```solidity
function SIGMA_K(int256 sigma, int256 k, int256 v, int256 T) public pure returns (int256)
```

### MJCnum

```solidity
function MJCnum(int256 m, int256 lam, int256 T, int256 i, int256 k_fact) public pure returns (int256)
```

### MERTON_CALL

```solidity
function MERTON_CALL(struct JDM.MertonInput _params) public pure returns (int256 C, int256 delta)
```

### pMERTON_CALL

```solidity
function pMERTON_CALL(struct JDM.MertonInput _params) public pure returns (int256 C)
```

### delta_MERTON_CALL

```solidity
function delta_MERTON_CALL(struct JDM.MertonInput _params) public pure returns (int256 delta)
```

### MERTON_PUT

```solidity
function MERTON_PUT(struct JDM.MertonInput _params) public pure returns (int256 C, int256 delta)
```

### pMERTON_PUT

```solidity
function pMERTON_PUT(struct JDM.MertonInput _params) public pure returns (int256 C)
```

### delta_MERTON_PUT

```solidity
function delta_MERTON_PUT(struct JDM.MertonInput _params) public pure returns (int256 delta)
```

## OraclePriceConverter

### UNIto1e18

```solidity
function UNIto1e18(uint256 price) public pure returns (int256)
```

### LINKto1e18

```solidity
function LINKto1e18(int256 price) public pure returns (int256)
```

## Statistics

probability density function (pdf), cumulative distribution function (cdf), error function (erf)

_sourced from https://www.johndcook.com/blog/cpp_phi/
link: https://github.com/DeltaDex-Protocol/research/blob/1048345ba7b75634892f4312d4e7d043d753377b/cdf.cpp_

### a1

```solidity
int256 a1
```

### a2

```solidity
int256 a2
```

### a3

```solidity
int256 a3
```

### a4

```solidity
int256 a4
```

### a5

```solidity
int256 a5
```

### p

```solidity
int256 p
```

### SQRT_2

```solidity
int256 SQRT_2
```

### pdf

```solidity
function pdf(int256 x) public pure returns (int256 y)
```

### cdf

```solidity
function cdf(int256 x) public pure returns (int256 y)
```

### erf

```solidity
function erf(int256 x) public pure returns (int256 y)
```

## Trigonometry

Solidity library offering basic trigonometry functions where inputs and outputs are
integers. Inputs are specified in radians scaled by 1e18, and similarly outputs are scaled by 1e18.

This implementation is based off the Solidity trigonometry library written by Lefteris Karapetsas
which can be found here: https://github.com/Sikorkaio/sikorka/blob/e75c91925c914beaedf4841c0336a806f2b5f66d/contracts/trigonometry.sol

Compared to Lefteris' implementation, this version makes the following changes:
  - Uses a 32 bits instead of 16 bits for improved accuracy
  - Updated for Solidity 0.8.x
  - Various gas optimizations
  - Change inputs/outputs to standard trig format (scaled by 1e18) instead of requiring the
    integer format used by the algorithm

Lefertis' implementation is based off Dave Dribin's trigint C library
    http://www.dribin.org/dave/trigint/

Which in turn is based from a now deleted article which can be found in the Wayback Machine:
    http://web.archive.org/web/20120301144605/http://www.dattalo.com/technical/software/pic/picsine.html

### INDEX_WIDTH

```solidity
uint256 INDEX_WIDTH
```

### INTERP_WIDTH

```solidity
uint256 INTERP_WIDTH
```

### INDEX_OFFSET

```solidity
uint256 INDEX_OFFSET
```

### INTERP_OFFSET

```solidity
uint256 INTERP_OFFSET
```

### ANGLES_IN_CYCLE

```solidity
uint32 ANGLES_IN_CYCLE
```

### QUADRANT_HIGH_MASK

```solidity
uint32 QUADRANT_HIGH_MASK
```

### QUADRANT_LOW_MASK

```solidity
uint32 QUADRANT_LOW_MASK
```

### SINE_TABLE_SIZE

```solidity
uint256 SINE_TABLE_SIZE
```

### PI

```solidity
uint256 PI
```

### TWO_PI

```solidity
uint256 TWO_PI
```

### PI_OVER_TWO

```solidity
uint256 PI_OVER_TWO
```

### entry_bytes

```solidity
uint8 entry_bytes
```

### entry_mask

```solidity
uint256 entry_mask
```

### sin_table

```solidity
bytes sin_table
```

### sin

```solidity
function sin(uint256 _angle) internal pure returns (int256)
```

Return the sine of a value, specified in radians scaled by 1e18

_This algorithm for converting sine only uses integer values, and it works by dividing the
circle into 30 bit angles, i.e. there are 1,073,741,824 (2^30) angle units, instead of the
standard 360 degrees (2pi radians). From there, we get an output in range -2,147,483,647 to
2,147,483,647, (which is the max value of an int32) which is then converted back to the standard
range of -1 to 1, again scaled by 1e18_

| Name | Type | Description |
| ---- | ---- | ----------- |
| _angle | uint256 | Angle to convert |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | int256 | Result scaled by 1e18 |

### cos

```solidity
function cos(uint256 _angle) internal pure returns (int256)
```

Return the cosine of a value, specified in radians scaled by 1e18

_This is identical to the sin() method, and just computes the value by delegating to the
sin() method using the identity cos(x) = sin(x + pi/2)
Overflow when `angle + PI_OVER_TWO > type(uint256).max` is ok, results are still accurate_

| Name | Type | Description |
| ---- | ---- | ----------- |
| _angle | uint256 | Angle to convert |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | int256 | Result scaled by 1e18 |

## UniswapV3twap

Gets price of token0 in terms of token1 from Uniswap V3 twap oracle

_Warning: not tested with ERC20 tokens with non-base 1e18_

### _factory

```solidity
address _factory
```

### getPool

```solidity
function getPool(address token0, address token1, uint24 fee) internal view returns (address)
```

### estimateAmountOut

```solidity
function estimateAmountOut(address tokenIn, uint128 amountIn, uint32 secondsAgo, address tokenOut) public view returns (uint256 amountOut)
```

## BSCOptionMaker

This contract contains the main logic for initializing option replication positions

_Currently code composability is not optimal_

### getDelta

```solidity
function getDelta(bool isCall, struct BSC.CurvedInput input) internal pure returns (int256 delta)
```

### BSC_START_REPLICATION

```solidity
function BSC_START_REPLICATION(struct BSC.BSC_params _params) external returns (address pair, uint256 amountOut)
```

### BSC_Write_Position_to_Mapping

```solidity
function BSC_Write_Position_to_Mapping(address pair, uint256 ID, uint256 amountOut, struct BSC.BSC_params _params) internal returns (bool)
```

### BSC_edit_params

```solidity
function BSC_edit_params(address pair, uint256 ID, uint256 feeAmount, struct BSC.BSC_params _params) external returns (bool)
```

### BSC_Withdraw

```solidity
function BSC_Withdraw(address pair, uint256 ID) external returns (uint256, uint256)
```

## BSOptionMaker

This contract contains the main logic for initializing option replication positions

_Currently code composability is not optimal_

### getDelta

```solidity
function getDelta(bool isCall, struct BS.BlackScholesInput input) internal pure returns (int256 delta)
```

Get delta of option contract

_gets delta_

| Name | Type | Description |
| ---- | ---- | ----------- |
| delta | int256 | returns delta of option |

### BS_START_REPLICATION

```solidity
function BS_START_REPLICATION(struct BS.BS_params _params) external returns (address pair, uint256 amountOut)
```

Black Scholes Start Replication

_starts BS option replication_

| Name | Type | Description |
| ---- | ---- | ----------- |
| _params | struct BS.BS_params | Black Scholes params |

| Name | Type | Description |
| ---- | ---- | ----------- |
| pair | address | address pair, amountOut |
| amountOut | uint256 |  |

### BS_Write_Position_to_Mapping

```solidity
function BS_Write_Position_to_Mapping(address pair, uint256 ID, struct BS.BS_params _params) internal returns (bool)
```

### BS_edit_params

```solidity
function BS_edit_params(address pair, uint256 ID, uint256 feeAmount, struct BS.BS_params _params) external returns (bool)
```

### BS_Withdraw

```solidity
function BS_Withdraw(address pair, uint256 ID) external returns (uint256, uint256)
```

## JDMOptionMaker

This contract contains the main logic for initializing option replication positions

_Currently code composability is not optimal_

### getDelta

```solidity
function getDelta(bool isCall, struct JDM.MertonInput input) internal pure returns (int256 delta)
```

### JDM_START_REPLICATION

```solidity
function JDM_START_REPLICATION(struct JDM.JDM_params _params) external returns (address pair, uint256 amountOut)
```

### JDM_Write_Position_to_Mapping

```solidity
function JDM_Write_Position_to_Mapping(address pair, uint256 ID, struct JDM.JDM_params _params) internal returns (bool)
```

### JDM_edit_params

```solidity
function JDM_edit_params(address pair, uint256 ID, uint256 feeAmount, struct JDM.JDM_params _params) external returns (bool)
```

### JDM_Withdraw

```solidity
function JDM_Withdraw(address pair, uint256 ID) external returns (uint256, uint256)
```

