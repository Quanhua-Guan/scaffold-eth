// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @title DEX Template
 * @author stevepham.eth and m00npapi.eth
 * @notice Empty DEX.sol that just outlines what features could be part of the challenge (up to you!)
 * @dev We want to create an automatic market where our contract will hold reserves of both ETH and 🎈 Balloons. These reserves will provide liquidity that allows anyone to swap between the assets.
 * NOTE: functions outlined here are what work with the front end of this branch/repo. Also return variable names that may need to be specified exactly may be referenced (if you are confused, see solutions folder in this repo and/or cross reference with front-end code).
 */
contract DEX {
    /* ========== GLOBAL VARIABLES ========== */

    using SafeMath for uint256; //outlines use of SafeMath for uint256 variables
    IERC20 token; //instantiates the imported contract

    uint256 public totalLiquidity; // total liquidity (ether)
    mapping(address => uint256) public liquidity; // liquidity for each user

    /* ========== EVENTS ========== */

    /**
     * @notice Emitted when ethToToken() swap transacted
     */
    event EthToTokenSwap(
        address indexed sender,
        string msg,
        uint256 ethAmount,
        uint256 tokenAmount
    );

    /**
     * @notice Emitted when tokenToEth() swap transacted
     */
    event TokenToEthSwap(
        address indexed sender,
        string msg,
        uint256 ethAmount,
        uint256 tokenAmount
    );

    /**
     * @notice Emitted when liquidity provided to DEX and mints LPTs.
     */
    event LiquidityProvided(
        address indexed sender,
        string msg,
        uint256 ethAmount,
        uint256 tokenAmount
    );

    /**
     * @notice Emitted when liquidity removed from DEX and decreases LPT count within DEX.
     */
    event LiquidityRemoved(
        address indexed sender,
        uint256 liquidity,
        uint256 ethAmount,
        uint256 tokenAmount
    );

    /* ========== CONSTRUCTOR ========== */

    constructor(address token_addr) public {
        // specifies the token address that will hook into the interface and be used through
        // the variable 'token'
        token = IERC20(token_addr);
    }

    /* ========== MUTATIVE FUNCTIONS ========== */

    /**
     * @notice initializes amount of tokens that will be transferred to the DEX itself from the erc20 
     * contract mintee (and only them based on how Balloons.sol is written). Loads contract up with both
       ETH and Balloons.
     * @param tokenAmount amount to be transferred to DEX
     * @return totalLiquidity is the number of LPTs minting as a result of deposits made to DEX contract
     * NOTE: since ratio is 1:1, this is fine to initialize the totalLiquidity (wrt to balloons) 
       as equal to eth balance of contract.
     */
    function init(uint256 tokenAmount) public payable returns (uint256) {
        // init can only be called once
        uint256 balance = address(this).balance;
        require(totalLiquidity == 0, "DEX: INIT - already has liquidity");
        // ETH : BAL = 1 : 1
        require(
            balance == tokenAmount,
            "DEX: INIT - ETH : BAL not equal 1 : 1"
        );
        // update totalLiquidity
        totalLiquidity = tokenAmount;
        // update liquidity for msg.sender
        liquidity[msg.sender] = totalLiquidity;
        // transfer BAL from msg.sender to this contract
        require(
            token.transferFrom(msg.sender, address(this), tokenAmount),
            "DEX: INIT - transfer failed"
        );

        // return total liquidity
        return totalLiquidity;
    }

    /**
     * @notice returns yOutput, or yDelta for xInput (or xDelta)
     * @dev Follow along with the [original tutorial] (https://medium.com/@austin_48503/%EF%B8%8F-minimum-viable-exchange-d84f30bd0c90)
     Price section for an understanding of the DEX's pricing model and for a price function to add to
     your contract. You may need to update the Solidity syntax (e.g. use + instead of .add, * instead
      of .mul, etc). Deploy when you are done.
     */
    function price(
        uint256 dx, // dx: your willing to pay dx amount TokenX (X and Y for the two tokens)
        uint256 x, // x: the reserves of TokenX
        uint256 y // y: the reserves of TokenY
    )
        public
        pure
        returns (
            uint256 dy // dy: your will receive dy amount TokenY
        )
    {
        // The price keep unchanged until next time someone add liquidity
        // price: xReserves for yReserves
        /*
            // No fee:
            xy = k
            (x + dx)(y - dy) = k

            // With fee, 0.003 of dx :
            xy = k
            (x + (dx * 0.997))(y - dy) = k
            
            we can get:

            (x + (dx * 0.997))(y - dy) = xy 
            =>
            xy - xdy + (dx * 0.997)y - (dx * 0.997)dy = xy
            =>
            (dx * 0.997)y = xdy + (dx * 0.997)dy = (x + (dx * 0.997))dy
            
            finally:

            dy = (dx * 0.997)y / (x + (dx * 0.997))
         
            more readable:

                    (dx * 997) * y
            dy = ------------------------------------
                    (x * 1000) + (dx * 997)
        */

        // uint256 xInputWithFee = xInput.mul(997);
        // uint256 numerator = xInputWithFee.mul(yReserves);
        // uint256 denominator = (xReserves.mul(1000)).add(xInputWithFee);
        // return (numerator / denominator);

        uint256 dxWithFee = dx * 997;
        uint256 numerator = dxWithFee * y;
        uint256 denominator = x * 1000 + dxWithFee;
        return numerator / denominator;
    }

    /**
     * @notice returns liquidity for a user. Note this is not needed typically due to the `liquidity()`
      mapping variable being public and having a getter as a result. This is left though as it is used
       within the front end code (App.jsx).
     * if you are using a mapping liquidity, then you can use `return liquidity[lp]` to get the liquidity
      for a user.
     *
     */
    function getLiquidity(address lp) public view returns (uint256) {}

    /**
     * @notice sends Ether to DEX in exchange for $BAL
     */
    function ethToToken() public payable returns (uint256 tokenOutput) {
        require(msg.value > 0, "DEX - ETH2BAL : invalid ether amount");

        uint256 ethInput = msg.value;
        uint256 ethReserves = address(this).balance - ethInput;
        uint256 tokenReserves = token.balanceOf(address(this));
        tokenOutput = price(ethInput, ethReserves, tokenReserves);

        require(
            // use transfer, because the contract is transferring the BAL reserves token
            // of its own (BAL stored in the contract)
            token.transfer(msg.sender, tokenOutput),
            "DEX - ETH2BAL : fail to transfer BAL"
        );

        emit EthToTokenSwap(
            msg.sender,
            "Eth to Balloons",
            ethInput,
            tokenOutput
        );
    }

    /**
     * @notice sends $BAL tokens to DEX in exchange for Ether
     */
    function tokenToEth(uint256 tokenInput) public returns (uint256 ethOutput) {
        require(tokenInput > 0, "DEX - BAL2ETH : invalid BAL amount");

        uint256 ethReserves = address(this).balance;
        uint256 tokenReserves = token.balanceOf(address(this));
        ethOutput = price(tokenInput, tokenReserves, ethReserves);

        require(
            // use transferFrom, because the contract is trasferring the sender's BAL from
            // the sender's address to the contract. the contract should be approved by the
            // sender before the code run, or it will fail.
            token.transferFrom(msg.sender, address(this), tokenInput),
            "DEX - BAL2ETH : fail to transfer BAL"
        );

        (bool sent, ) = payable(msg.sender).call{value: ethOutput}("");
        require(sent, "DEX - BAL2ETH : fail to transfer ETH");

        emit TokenToEthSwap(
            msg.sender,
            "Balloons to ETH",
            ethOutput,
            tokenInput
        );
    }

    /**
     * @notice allows deposits of $BAL and $ETH to liquidity pool
     * NOTE: parameter is the msg.value sent with this function call. That amount is used to determine
      the amount of $BAL needed as well and taken from the depositor.
     * NOTE: user has to make sure to give DEX approval to spend their tokens on their behalf by calling
      approve function prior to this function call.
     * NOTE: Equal parts of both assets will be removed from the user's wallet with respect to the price
      outlined by the AMM.
     */
    function deposit() public payable returns (uint256 tokenDeposited) {
        uint256 ethDeposited = msg.value;
        uint256 ethReserves = address(this).balance - ethDeposited;
        uint256 tokenReserves = token.balanceOf(address(this));

        /*
            ethReserves     ethDeposited
            ------------- = --------------
            tokenReserves   tokenDeposited
        */
        // add 1 wei, prevent tokenDeposited from being 0
        tokenDeposited = (tokenReserves * ethDeposited) / ethReserves + 1;

        uint256 liquidityMinted = (ethDeposited * totalLiquidity) / ethReserves;
        liquidity[msg.sender] += liquidityMinted;
        totalLiquidity += liquidityMinted;

        require(
            token.transferFrom(msg.sender, address(this), tokenDeposited),
            "DEX - DEPOSIT : fail to transfer BAL"
        );

        emit LiquidityProvided(
            msg.sender,
            "DEPOSIT",
            ethDeposited,
            tokenDeposited
        );
    }

    /**
     * @notice allows withdrawal of $BAL and $ETH from liquidity pool
     * NOTE: with this current code, the msg caller could end up getting very little back if the 
     liquidity is super low in the pool. I guess they could see that with the UI.
     */
    function withdraw(uint256 liquidityAmount)
        public
        returns (uint256 ethWithdraw, uint256 tokenWithdraw)
    {
        require(
            liquidity[msg.sender] >= liquidityAmount,
            "DEX - WITHDRAW : no enough liquidity to withdraw"
        );

        uint256 ethReserves = address(this).balance;
        uint256 tokenReserves = token.balanceOf(address(this));

        ethWithdraw = (liquidityAmount * ethReserves) / totalLiquidity;
        tokenWithdraw = (liquidityAmount * tokenReserves) / totalLiquidity;

        totalLiquidity -= liquidityAmount;
        liquidity[msg.sender] -= liquidityAmount;

        (bool sent, ) = payable(msg.sender).call{value: ethWithdraw}("");
        require(sent, "DEX - WITHDRAW : fail to withdraw ETH");

        require(
            token.transfer(msg.sender, tokenWithdraw),
            "DEX - WITHDRAW : fail to width BAL"
        );

        emit LiquidityRemoved(
            msg.sender,
            liquidityAmount,
            ethWithdraw,
            tokenWithdraw
        );
    }
}
