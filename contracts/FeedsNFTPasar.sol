// SPDX-License-Identifier: MIT

pragma solidity =0.7.6;
pragma abicoder v2;

/**
 * @dev ERC1155TokenReceiver interface of the ERC1155 standard as defined in the EIP.
 * @dev The ERC-165 identifier for this interface is 0x4e2312e0
 */
interface IERC1155TokenReceiver {
    /**
     * @notice Handle the receipt of a single ERC1155 token type.
     * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
     * This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.
     * This function MUST revert if it rejects the transfer.
     * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
     * @param _operator  The address which initiated the transfer (i.e. msg.sender)
     * @param _from      The address which previously owned the token
     * @param _id        The ID of the token being transferred
     * @param _value     The amount of tokens being transferred
     * @param _data      Additional data with no specified format
     * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
     */
    function onERC1155Received(
        address _operator,
        address _from,
        uint256 _id,
        uint256 _value,
        bytes calldata _data
    ) external returns (bytes4);

    /**
     * @notice Handle the receipt of multiple ERC1155 token types.
     * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
     * This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).
     * This function MUST revert if it rejects the transfer(s).
     * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
     * @param _operator  The address which initiated the batch transfer (i.e. msg.sender)
     * @param _from      The address which previously owned the token
     * @param _ids       An array containing ids of each token being transferred (order and length must match _values array)
     * @param _values    An array containing amounts of each token being transferred (order and length must match _ids array)
     * @param _data      Additional data with no specified format
     * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
     */
    function onERC1155BatchReceived(
        address _operator,
        address _from,
        uint256[] calldata _ids,
        uint256[] calldata _values,
        bytes calldata _data
    ) external returns (bytes4);
}

/**
 * @dev Interface of the ERC165 standard as defined in the EIP.
 */
interface IERC165 {
    /**
     * @notice Query if a contract implements an interface
     * @param interfaceID The interface identifier, as specified in ERC-165
     * @dev Interface identification is specified in ERC-165. This function
     * uses less than 30,000 gas.
     * @return `true` if the contract implements `interfaceID` and
     * `interfaceID` is not 0xffffffff, `false` otherwise
     */
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

/**
 * @dev Interface for proxiable logic contracts.
 * @dev The ERC-165 identifier for this interface is 0xc1fdc5a0
 */
interface IFeedsContractProxiable {
    /**
     * @dev Emit when the logic contract is updated
     */
    event CodeUpdated(address indexed _codeAddress);

    /**
     * @dev upgrade the logic contract to one on the new code address
     * @param _newAddress New code address of the upgraded logic contract
     */
    function updateCodeAddress(address _newAddress) external;

    /**
     * @dev get the code address of the current logic contract
     * @return Logic contract address
     */
    function getCodeAddress() external view returns (address);
}

/**
 * @dev Token interface of the ERC1155 standard as defined in the EIP.
 * @dev With support of custom token royalty methods
 */
interface IERC1155WithRoyalty {
    /**
     * @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
     * The `_operator` argument MUST be the address of an account/contract that is approved to make the transfer (SHOULD be msg.sender).
     * The `_from` argument MUST be the address of the holder whose balance is decreased.
     * The `_to` argument MUST be the address of the recipient whose balance is increased.
     * The `_id` argument MUST be the token type being transferred.
     * The `_value` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.
     * When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
     * When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
     */
    event TransferSingle(
        address indexed _operator,
        address indexed _from,
        address indexed _to,
        uint256 _id,
        uint256 _value
    );

    /**
     * @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
     * The `_operator` argument MUST be the address of an account/contract that is approved to make the transfer (SHOULD be msg.sender).
     * The `_from` argument MUST be the address of the holder whose balance is decreased.
     * The `_to` argument MUST be the address of the recipient whose balance is increased.
     * The `_ids` argument MUST be the list of tokens being transferred.
     * The `_values` argument MUST be the list of number of tokens (matching the list and order of tokens specified in _ids) the holder balance is decreased by and match what the recipient balance is increased by.
     * When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
     * When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
     */
    event TransferBatch(
        address indexed _operator,
        address indexed _from,
        address indexed _to,
        uint256[] _ids,
        uint256[] _values
    );

    /**
     * @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absence of an event assumes disabled).
     */
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    /**
     * @dev MUST emit when the URI is updated for a token ID.
     * URIs are defined in RFC 3986.
     * The URI MUST point to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
     */
    event URI(string _value, uint256 indexed _id);

    /**
     * @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
     * @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
     * MUST revert if `_to` is the zero address.
     * MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
     * MUST revert on any other error.
     * MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
     * After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
     * @param _from    Source address
     * @param _to      Target address
     * @param _id      ID of the token type
     * @param _value   Transfer amount
     * @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
     */
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _id,
        uint256 _value,
        bytes calldata _data
    ) external;

    /**
     * @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
     * @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
     * MUST revert if `_to` is the zero address.
     * MUST revert if length of `_ids` is not the same as length of `_values`.
     * MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
     * MUST revert on any other error.
     * MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
     * Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
     * After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
     * @param _from    Source address
     * @param _to      Target address
     * @param _ids     IDs of each token type (order and length must match _values array)
     * @param _values  Transfer amounts per token type (order and length must match _ids array)
     * @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
     */
    function safeBatchTransferFrom(
        address _from,
        address _to,
        uint256[] calldata _ids,
        uint256[] calldata _values,
        bytes calldata _data
    ) external;

    /**
     * @notice Get the balance of an account's tokens.
     * @param _owner  The address of the token holder
     * @param _id     ID of the token
     * @return        The _owner's balance of the token type requested
     */
    function balanceOf(address _owner, uint256 _id) external view returns (uint256);

    /**
     * @notice Get the balance of multiple account/token pairs
     * @param _owners The addresses of the token holders
     * @param _ids    ID of the tokens
     * @return        The _owner's balance of the token types requested (i.e. balance for each (owner, id) pair)
     */
    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids)
        external
        view
        returns (uint256[] memory);

    /**
     * @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
     * @dev MUST emit the ApprovalForAll event on success.
     * @param _operator  Address to add to the set of authorized operators
     * @param _approved  True if the operator is approved, false to revoke approval
     */
    function setApprovalForAll(address _operator, bool _approved) external;

    /**
     * @notice Queries the approval status of an operator for a given owner.
     * @param _owner     The owner of the tokens
     * @param _operator  Address of authorized operator
     * @return           True if the operator is approved, false if not
     */
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);

    /**
     * @notice Get the royalty owner address of a given token type
     * @param _id The token identifier of a given token type
     * @return The royalty owner address
     */
    function tokenRoyaltyOwner(uint256 _id) external view returns (address);

    /**
     * @notice Get the royalty owner address of multiple token types
     * @param _ids The token identifiers of the token types
     * @return The royalty owner addresses
     */
    function tokenRoyaltyOwnerBatch(uint256[] calldata _ids) external view returns (address[] memory);

    /**
     * @notice Get the royalty fee rate of a given token type
     * @param _id The token identifier of a given token type
     * @return The royalty fee rate in terms of parts per million
     */
    function tokenRoyaltyFee(uint256 _id) external view returns (uint256);

    /**
     * @notice Get the royalty fee rate of multiple token types
     * @param _ids The token identifiers of the token types
     * @return The royalty fee rates in terms of parts per million
     */
    function tokenRoyaltyFeeBatch(uint256[] calldata _ids) external view returns (uint256[] memory);
}

interface IPasarDataAndEvents {
    /**
     * @dev Order info data structure
     * @param orderId The identifier of the order, incrementing uint256 starting from 0
     * @param orderType The type of the order, 1 is sale order, 2 is auction order, 3 is splittable order
     * @param orderState The state of the order, 1 is open, 2 is filled, 3 is cancelled
     * @param tokenId The token type placed in the order
     * @param amount The amount of token placed in the order
     * @param price The price asked for the order (minimum bidding price for auction order)
     * @param endTime The end time of the auction (only meaningful for auction order)
     * @param sellerAddr The address of the seller that created the order
     * @param buyerAddr The address of the buyer of the order
     * @param bids The number of bids placed on the order (only meaningful for auction orders)
     * @param lastBidder The address of the last bidder that bids on the order (only meaningful for auction orders)
     * @param lastBid The last bid price on the order (only meaningful for auction orders)
     * @param filled The filled price of the order (only meaningful for filled orders)
     * @param royaltyOwner The address of the royalty owner for the token type placed in the order
     * @param royaltyFee The royalty fee associated with the order (only meaningful for filled orders)
     * @param createTime The timestamp of the order creation
     * @param updateTime The timestamp of last order info update
     */
    struct OrderInfo {
        uint256 orderId;
        uint256 orderType;
        uint256 orderState;
        uint256 tokenId;
        uint256 amount;
        uint256 price;
        uint256 endTime;
        address sellerAddr;
        address buyerAddr;
        uint256 bids;
        address lastBidder;
        uint256 lastBid;
        uint256 filled;
        address royaltyOwner;
        uint256 royaltyFee;
        uint256 createTime;
        uint256 updateTime;
    }

    /**
     * @dev Seller info data structure
     * @param index The index of the seller, incrementing uint256 starting from 0
     * @param sellerAddr The address of the seller
     * @param orderCount The number of orders created by the seller
     * @param openCount The number of currently open orders created by the seller
     * @param earned The total amount of revenue earned by the seller
     * @param royalty The total amount of royalty fee associated with orders created by the seller
     * @param joinTime The timestamp when the seller first creates an order in Pasar
     * @param lastActionTime The timestamp of the sellerʻs last action in Pasar
     * @param platformFee The total amount of platform fee associated with orders created by the seller
     */
    struct SellerInfo {
        uint256 index;
        address sellerAddr;
        uint256 orderCount;
        uint256 openCount;
        uint256 earned;
        uint256 royalty;
        uint256 joinTime;
        uint256 lastActionTime;
        uint256 platformFee;
    }

    /**
     * @dev Buyer info data structure
     * @param index The index of the buyer, incrementing uint256 starting from 0
     * @param buyerAddr The address of the buyer
     * @param orderCount The number of orders the buyer participated to buy or bid on
     * @param filledCount The number of orders filled by the buyer
     * @param paid The total amount of cost paid by the buyer
     * @param royalty The total amount of royalty fee associated with orders filled by the buyer
     * @param joinTime The timestamp when the buyer first participated to buy or bid on an order in Pasar
     * @param lastActionTime The timestamp of the buyerʻs last action in Pasar
     * @param platformFee The total amount of platform fee associated with orders filled by the seller
     */
    struct BuyerInfo {
        uint256 index;
        address buyerAddr;
        uint256 orderCount;
        uint256 filledCount;
        uint256 paid;
        uint256 royalty;
        uint256 joinTime;
        uint256 lastActionTime;
        uint256 platformFee;
    }

    /**
     * @dev Data structure for partially filled orders
     * @param buyerAddr The address of the buyer
     * @param value The value of the partially filled order
     * @param amount The token amount of the partially filled order
     * @param royaltyOwner The address of the royalty owner for the token type associated with the partially filled order
     * @param royaltyFee The royalty fee associated with the partially filled order
     * @param platformAddr The platform wallet address that collects the partially filled orderʻs platform fee
     * @param platformFee The platform fee paid with the partially filled order
     * @param fillTime The timestamp of the partially filled order
     * @param buyerUri DID URI of the partially filled orderʻs buyer
     */
    struct PartialFillInfo {
        address buyerAddr;
        uint256 value;
        uint256 amount;
        address royaltyOwner;
        uint256 royaltyFee;
        address platformAddr;
        uint256 platformFee;
        uint256 fillTime;
        string buyerUri;
    }

    /**
     * @dev Order extra info data structure
     * @param sellerUri DID URI of the orderʻs seller
     * @param buyerUri DID URI of the orderʻs buyer
     * @param platformAddr The platform wallet address that collects the orderʻs platform fee
     * @param platformFee The platform fee paid with the order
     * @param partialFills Array of partially filled orders (only meaningful for splittable orders)
     * @param priceLeft The price for the tokens left after partially filled orders (only meaningful for splittable orders)
     * @param amountLeft The amount of tokens left after partially filled orders (only meaningful for splittable orders)
     */
    struct OrderExtraInfo {
        string sellerUri;
        string buyerUri;
        address platformAddr;
        uint256 platformFee;
        PartialFillInfo[] partialFills;
        uint256 priceLeft;
        uint256 amountLeft;
    }

    /**
     * @dev MUST emit when the contract receives a single ERC1155 token type.
     */
    event ERC1155Received(
        address indexed _operator,
        address indexed _from,
        uint256 indexed _id,
        uint256 _value,
        bytes _data
    );

    /**
     * @dev MUST emit when the contract receives multiple ERC1155 token types.
     */
    event ERC1155BatchReceived(
        address indexed _operator,
        address indexed _from,
        uint256[] _ids,
        uint256[] _values,
        bytes _data
    );

    /**
     * @dev MUST emit when a new sale order is created in Pasar.
     * The `_seller` argument MUST be the address of the seller who created the order.
     * The `_orderId` argument MUST be the id of the order created.
     * The `_tokenId` argument MUST be the token type placed on sale.
     * The `_amount` argument MUST be the amount of token placed on sale.
     * The `_price` argument MUST be the fixed price asked for the sale order.
     */
    event OrderForSale(
        address indexed _seller,
        uint256 indexed _orderId,
        uint256 indexed _tokenId,
        uint256 _amount,
        uint256 _price
    );

    /**
     * @dev MUST emit when a new auction order is created in Pasar.
     * The `_seller` argument MUST be the address of the seller who created the order.
     * The `_orderId` argument MUST be the id of the order created.
     * The `_tokenId` argument MUST be the token type placed on auction.
     * The `_amount` argument MUST be the amount of token placed on auction.
     * The `_minPrice` argument MUST be the minimum starting price for the auction bids.
     * The `endTime` argument MUST be the time for ending the auction.
     */
    event OrderForAuction(
        address indexed _seller,
        uint256 indexed _orderId,
        uint256 indexed _tokenId,
        uint256 _amount,
        uint256 _minPrice,
        uint256 _endTime
    );

    /**
     * @dev MUST emit when a bid is placed on an auction order.
     * The `_seller` argument MUST be the address of the seller who created the order.
     * The `_buyer` argument MUST be the address of the buyer who made the bid.
     * The `_orderId` argument MUST be the id of the order been bid on.
     * The `_price` argument MUST be the price of the bid.
     */
    event OrderBid(address indexed _seller, address indexed _buyer, uint256 indexed _orderId, uint256 _price);

    /**
     * @dev MUST emit when an order is filled.
     * The `_seller` argument MUST be the address of the seller who created the order.
     * The `_buyer` argument MUST be the address of the buyer in the fulfilled order.
     * The `_orderId` argument MUST be the id of the order fulfilled.
     * The `_royaltyOwner` argument MUST be the address of the royalty owner of the token sold in the order.
     * The `_price` argument MUST be the price of the fulfilled order.
     * The `_royalty` argument MUST be the royalty paid for the fulfilled order.
     */
    event OrderFilled(
        address indexed _seller,
        address indexed _buyer,
        uint256 indexed _orderId,
        address _royaltyOwner,
        uint256 _price,
        uint256 _royalty
    );

    /**
     * @dev MUST emit when an order is canceled.
     * @dev Only an open sale order or an auction order with no bid yet can be canceled
     * The `_seller` argument MUST be the address of the seller who created the order.
     * The `_orderId` argument MUST be the id of the order canceled.
     */
    event OrderCanceled(address indexed _seller, uint256 indexed _orderId);

    /**
     * @dev MUST emit when an order has its price changed.
     * @dev Only an open sale order or an auction order with no bid yet can have its price changed.
     * @dev For sale orders, the fixed price asked for the order is changed.
     * @dev for auction orders, the minimum starting price for the bids is changed.
     * The `_seller` argument MUST be the address of the seller who created the order.
     * The `_orderId` argument MUST be the id of the order with the price change.
     * The `_oldPrice` argument MUST be the original price of the order before the price change.
     * The `_newPrice` argument MUST be the new price of the order after the price change.
     */
    event OrderPriceChanged(address indexed _seller, uint256 indexed _orderId, uint256 _oldPrice, uint256 _newPrice);

    /**
     * @dev MUST emit when the DID URIs related to an order is updated.
     */
    event OrderDIDURI(
        string _sellerUri,
        string _buyerUri,
        address indexed _seller,
        address indexed _buyer,
        uint256 indexed _orderId
    );

    /**
     * @dev MUST emit with the platform fee information when an order is fulfilled
     */
    event OrderPlatformFee(
        address _platformAddress,
        uint256 _platformFee,
        address indexed _seller,
        address indexed _buyer,
        uint256 indexed _orderId
    );

    /**
     * @dev MUST emit when a new splittable order is created in Pasar.
     * The `_seller` argument MUST be the address of the seller who created the order.
     * The `_orderId` argument MUST be the id of the order created.
     * The `_tokenId` argument MUST be the token type placed on sale.
     * The `_amount` argument MUST be the amount of token placed on sale.
     * The `_price` argument MUST be the fixed total price asked for the splittable order.
     */
    event OrderSplittable(
        address indexed _seller,
        uint256 indexed _orderId,
        uint256 indexed _tokenId,
        uint256 _amount,
        uint256 _price
    );

    /**
     * @dev MUST emit when a splittable order is (partially) filled.
     * The `_seller` argument MUST be the address of the seller who created the order.
     * The `_buyer` argument MUST be the buyer in the (partially) fulfilled order.
     * The `_orderId` argument MUST be the id of the order (partially) fulfilled.
     * The `_royaltyOwner` argument MUST be the address of the royalty owner of the token sold in the order.
     * The `_price` argument MUST be the price paid for the (partially) fulfilled order.
     * The `_amount` argument MUST be the amount of tokens purchased in the (partially) fulfilled order
     * The `_priceLeft` argument MUST be the price for the tokens left in the splittable order after this (partial) purchase
     * The `_amountLeft` argument MUST be the amount of tokens left in the splittable order after this (partial) purchase
     * The `_royalty` argument MUST be the royalty paid for the (partially) fulfilled order.
     */
    event PartialFilled(
        address indexed _seller,
        address indexed _buyer,
        uint256 indexed _orderId,
        address _royaltyOwner,
        uint256 _price,
        uint256 _amount,
        uint256 _priceLeft,
        uint256 _amountLeft,
        uint256 _royalty
    );

    /**
     * @dev MUST emit when a splittable order is canceled.
     * The `_seller` argument MUST be the address of the seller who created the order.
     * The `_orderId` argument MUST be the id of the order partially fulfilled.
     * The `_priceLeft` argument MUST be the price for the tokens left in the splittable order when it's canceled
     * The `_amountLeft` argument MUST be the amount of tokens left in the splittable order when it's canceled
     */
    event PartialCanceled(address indexed _seller, uint256 indexed _orderId, uint256 _priceLeft, uint256 _amountLeft);

    /**
     * @dev Emit when the library logic contract is updated
     */
    event LibraryLogicContract(address indexed _codeAddress);
}

/**
 * @dev Interface for trading orders in Pasar.
 */
interface IPasarOrder {
    /**
     * @notice Create a new order for sale at a fixed price
     * @param _tokenId The token type placed on sale
     * @param _amount The amount of token placed on sale
     * @param _price The fixed price asked for the sale order
     * @param _didUri DID URI of the seller
     */
    function createOrderForSale(
        uint256 _tokenId,
        uint256 _amount,
        uint256 _price,
        string calldata _didUri
    ) external;

    /**
     * @notice Create a new order for auction
     * @param _tokenId The token type placed on auction
     * @param _amount The amount of token placed on auction
     * @param _minPrice The minimum starting price for bidding on the auction
     * @param _endTime The time for ending the auction
     * @param _didUri DID URI of the seller
     */
    function createOrderForAuction(
        uint256 _tokenId,
        uint256 _amount,
        uint256 _minPrice,
        uint256 _endTime,
        string calldata _didUri
    ) external;

    /**
     * @notice Buy a sale order with fixed price
     * @dev The value of the transaction must equal to the fixed price asked for the order
     * @param _orderId The id of the fixed price sale order
     * @param _didUri DID URI of the buyer
     */
    function buyOrder(uint256 _orderId, string calldata _didUri) external payable;

    /**
     * @notice Bid on an auction order
     * @dev The value of the transaction must be greater than or equal to the minimum starting price of the oder
     * @dev If the order has past bid(s), the value of the transaction must be greater than the last bid
     * @param _orderId The id of the auction order
     * @param _didUri DID URI of the buyer
     */
    function bidForOrder(uint256 _orderId, string calldata _didUri) external payable;

    /**
     * @notice Cancel an order
     * @dev Only an open sale order or an auction order with no bid yet can be canceled
     * @dev Only an order's seller can cancel the order
     * @param _orderId The id of the order to be canceled
     */
    function cancelOrder(uint256 _orderId) external;

    /**
     * @notice Settle an auction
     * @dev Only an auction order past its end time can be settled
     * @dev Anyone can settle an auction
     * @param _orderId The id of the order to be settled
     */
    function settleAuctionOrder(uint256 _orderId) external;

    /**
     * @notice Change the price of an order
     * @dev Only an open sale order or an auction order with no bid yet can have its price changed.
     * @dev For sale orders, the fixed price asked for the order is changed.
     * @dev for auction orders, the minimum starting price for the bids is changed.
     * @dev Only an order's seller can change its price
     * @param _orderId The id of the order with its price to be changed
     * @param _price The new price of the order
     */
    function changeOrderPrice(uint256 _orderId, uint256 _price) external;
}

interface IPasarInfo is IPasarDataAndEvents {
    /**
     * @notice Get the NFT token address accepted by the Pasar
     * @return The NFT token address
     */
    function getTokenAddress() external view returns (address);

    /**
     * @notice Get the total number of orders ever created in the Pasar
     * @return The number of orders
     */
    function getOrderCount() external view returns (uint256);

    /**
     * @notice Get order information of a given order
     * @param _orderId The id of the order, should be less than `getOrderCount`
     * @return Order information
     */
    function getOrderById(uint256 _orderId) external view returns (OrderInfo memory);

    /**
     * @notice Get order information of multiple orders
     * @param _orderIds The ids of the orders
     * @return Array of multiple order information
     */
    function getOrderByIdBatch(uint256[] calldata _orderIds) external view returns (OrderInfo[] memory);

    /**
     * @notice Get the number of open orders currently in the Pasar
     * @return The number of open orders
     */
    function getOpenOrderCount() external view returns (uint256);

    /**
     * @notice Enumerate order information of an open order
     * @param _index A counter less than `getOpenOrderCount`
     * @return Order information
     */
    function getOpenOrderByIndex(uint256 _index) external view returns (OrderInfo memory);

    /**
     * @notice Enumerate order information for multiple indexes
     * @param _indexes An array of counters less than `getOpenOrderCount`
     * @return Array of multiple order information
     */
    function getOpenOrderByIndexBatch(uint256[] calldata _indexes) external view returns (OrderInfo[] memory);

    /**
     * @notice Get the total number of sellers participated in the Pasar
     * @return The number of sellers
     */
    function getSellerCount() external view returns (uint256);

    /**
     * @notice Get seller information of a given seller
     * @param _seller The address of the seller
     * @return Seller information
     */
    function getSellerByAddr(address _seller) external view returns (SellerInfo memory);

    /**
     * @notice Enumerate seller information of a given seller
     * @param _index A counter less than `getSellerCount`
     * @return Seller information
     */
    function getSellerByIndex(uint256 _index) external view returns (SellerInfo memory);

    /**
     * @notice Enumerate seller information for multiple indexes
     * @param _indexes An array of counters less than `getSellerCount`
     * @return Array of multiple seller information
     */
    function getSellerByIndexBatch(uint256[] calldata _indexes) external view returns (SellerInfo[] memory);

    /**
     * @notice Enumerate order information created by a given seller
     * @param _seller A seller address
     * @param _index A counter less than `orderCount` of a given seller
     * @return Order information
     */
    function getSellerOrderByIndex(address _seller, uint256 _index) external view returns (OrderInfo memory);

    /**
     * @notice Enumerate order information for multiple indexes created by a given seller
     * @param _seller A seller address
     * @param _indexes An array of counters less than `orderCount` of a given seller
     * @return Array of multiple order information
     */
    function getSellerOrderByIndexBatch(address _seller, uint256[] calldata _indexes)
        external
        view
        returns (OrderInfo[] memory);

    /**
     * @notice Enumerate open order information created by a given seller
     * @param _seller A seller address
     * @param _index A counter less than `openCount` of a given seller
     * @return Order information
     */
    function getSellerOpenByIndex(address _seller, uint256 _index) external view returns (OrderInfo memory);

    /**
     * @notice Enumerate open order information for multiple indexes created by a given seller
     * @param _seller A seller address
     * @param _indexes An array of counters less than `openCount` of a given seller
     * @return Array of multiple order information
     */
    function getSellerOpenByIndexBatch(address _seller, uint256[] calldata _indexes)
        external
        view
        returns (OrderInfo[] memory);

    /**
     * @notice Get the total number of buyers participated in the Pasar
     * @return The number of buyers
     */
    function getBuyerCount() external view returns (uint256);

    /**
     * @notice Get buyer information of a given buyer
     * @param _buyer The address of the buyer
     * @return Buyer information
     */
    function getBuyerByAddr(address _buyer) external view returns (BuyerInfo memory);

    /**
     * @notice Enumerate buyer information of a given buyer
     * @param _index A counter less than `getBuyerCount`
     * @return Buyer information
     */
    function getBuyerByIndex(uint256 _index) external view returns (BuyerInfo memory);

    /**
     * @notice Enumerate buyer information for multiple indexes
     * @param _indexes An array of counters less than `getBuyerCount`
     * @return Array of multiple buyer information
     */
    function getBuyerByIndexBatch(uint256[] calldata _indexes) external view returns (BuyerInfo[] memory);

    /**
     * @notice Enumerate order information a given buyer has participated
     * @param _buyer A buyer address
     * @param _index A counter less than `orderCount` of a given buyer
     * @return Order information
     */
    function getBuyerOrderByIndex(address _buyer, uint256 _index) external view returns (OrderInfo memory);

    /**
     * @notice Enumerate order information for multiple indexes a given buyer has participated
     * @param _buyer A buyer address
     * @param _indexes An array of counters less than `orderCount` of a given buyer
     * @return Array of multiple order information
     */
    function getBuyerOrderByIndexBatch(address _buyer, uint256[] calldata _indexes)
        external
        view
        returns (OrderInfo[] memory);

    /**
     * @notice Enumerate filled order information a given buyer has bought
     * @param _buyer A buyer address
     * @param _index A counter less than `filledCount` of a given buyer
     * @return Order information
     */
    function getBuyerFilledByIndex(address _buyer, uint256 _index) external view returns (OrderInfo memory);

    /**
     * @notice Enumerate filled order information for multiple indexes a given buyer has bought
     * @param _buyer A buyer address
     * @param _indexes An array of counters less than `filledCount` of a given buyer
     * @return Array of multiple order information
     */
    function getBuyerFilledByIndexBatch(address _buyer, uint256[] calldata _indexes)
        external
        view
        returns (OrderInfo[] memory);
}

interface IVersion {
    function getVersion() external view returns (string memory);

    function getMagic() external view returns (string memory);
}

/**
 * @dev Interface for extra Pasar information added in Pasar upgrades
 */
interface IPasarUpgraded is IPasarDataAndEvents {
    /**
     * @notice Get extra order information for a given order from upgraded Pasar contract
     * @param _orderId The order identifier
     * @return The extra order information from upgraded Pasar contract
     */
    function getOrderExtraById(uint256 _orderId) external view returns (OrderExtraInfo memory);

    /**
     * @notice Get extra order information for multiple orders from upgraded Pasar contract
     * @param _orderIds The order identifiers
     * @return The extra order information array from upgraded Pasar contract
     */
    function getOrderExtraByIdBatch(uint256[] calldata _orderIds) external view returns (OrderExtraInfo[] memory);

    /**
     * @notice Set the platform fee rate charged for each trade and the platform address to receive the fees
     * @param _platformAddress the platform address
     * @param _platformFeeRate The platform fee rate in terms of parts per million
     */
    function setPlatformFee(address _platformAddress, uint256 _platformFeeRate) external;

    /**
     * @notice Get the current platform fee parameters
     * @return _platformAddress the current platform address
     * @return _platformFeeRate the current platform fee rate
     */
    function getPlatformFee() external view returns (address _platformAddress, uint256 _platformFeeRate);

    /**
     * @notice Create a new splittable order for sale at a fixed price
     * @param _tokenId The token type placed on sale
     * @param _amount The amount of token placed on sale
     * @param _price The fixed total price asked for the splittable order
     * @param _didUri DID URI of the seller
     */
    function createSplittableOrder(
        uint256 _tokenId,
        uint256 _amount,
        uint256 _price,
        string calldata _didUri
    ) external;

    /**
     * @notice Buy a splittable order with fixed price
     * @dev The value of the transaction must equal to the price corresponding to the amount to be purchased
     * @param _orderId The id of the fixed price splittable order
     * @param _amount The amount to be purchased, must be less than or equal to `amountLeft` of the order
     * @param _didUri DID URI of the buyer
     */
    function buySplittableOrder(
        uint256 _orderId,
        uint256 _amount,
        string calldata _didUri
    ) external payable;
}

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }

        c = a * b;
        require(c / a == b, "SafeMath mul failed");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath sub failed");
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        require(c >= a, "SafeMath add failed");
        return c;
    }
}

library AddressUtils {
    function isContract(address _addr) internal view returns (bool) {
        uint256 size;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            size := extcodesize(_addr)
        }
        return size > 0;
    }
}

/**
 * @dev Base contract for some basic common functionalities
 */
abstract contract BaseUtils is IFeedsContractProxiable {
    bytes4 internal constant ERC1155_ACCEPTED = 0xf23a6e61;
    bytes4 internal constant ERC1155_BATCH_ACCEPTED = 0xbc197c81;
    bytes4 internal constant INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
    bytes4 internal constant INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
    bytes4 internal constant INTERFACE_SIGNATURE_ERC1155TokenReceiver = 0x4e2312e0;
    bytes4 internal constant INTERFACE_SIGNATURE_TokenRoyalty = 0x96f7b536;
    bytes4 internal constant INTERFACE_SIGNATURE_FeedsContractProxiable = 0xc1fdc5a0;

    bytes internal constant PASAR_DATA_MAGIC = bytes("Feeds NFT Pasar");

    /**
     * @dev Fee rates are calculated with a base of 1/1000000
     */
    uint256 internal constant RATE_BASE = 1000000;

    uint256 private guard;
    uint256 private constant GUARD_PASS = 1;
    uint256 private constant GUARD_BLOCK = 2;

    /**
     * @dev Proxied contracts cannot use contructor but must be intialized manually
     */
    address public owner = address(0x1);
    bool public initialized = false;

    function _initialize() internal {
        require(!initialized, "Contract already initialized");
        require(owner == address(0x0), "Logic contract cannot be initialized");
        initialized = true;
        guard = GUARD_PASS;
        owner = msg.sender;
    }

    function initialize() external virtual {
        _initialize();
    }

    modifier inited() {
        require(initialized, "Contract not initialized");
        _;
    }

    /**
     * @dev Mutex to guard against re-entrancy exploits
     */
    modifier reentrancyGuard() {
        require(guard != GUARD_BLOCK, "Reentrancy blocked");
        guard = GUARD_BLOCK;
        _;
        guard = GUARD_PASS;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Sender must be owner");
        _;
    }

    function transferOwnership(address _owner) external inited onlyOwner {
        owner = _owner;
    }

    /**
     * @notice Upgrade the logic contract to one on the new code address
     * @dev Code position in storage is
     * keccak256("PROXIABLE") = "0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7"
     * @param _newAddress New code address of the upgraded logic contract
     */
    function updateCodeAddress(address _newAddress) external override inited onlyOwner {
        require(IERC165(_newAddress).supportsInterface(0xc1fdc5a0), "Contract address not proxiable");

        // solium-disable-next-line security/no-inline-assembly
        assembly {
            sstore(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7, _newAddress)
        }

        emit CodeUpdated(_newAddress);
    }

    /**
     * @notice get the code address of the current logic contract
     * @dev Code position in storage is
     * keccak256("PROXIABLE") = "0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7"
     * @return _codeAddress Logic contract address
     */
    function getCodeAddress() external view override returns (address _codeAddress) {
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            _codeAddress := sload(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7)
        }
    }
}

/**
 * @dev The storage declaration contract for Pasar
 */

abstract contract FeedsNFTPasarStorage is IPasarDataAndEvents, BaseUtils {
    address internal tokenAddress;
    IERC1155WithRoyalty internal token;

    OrderInfo[] internal orders;
    uint256[] internal openOrders;
    mapping(uint256 => uint256) internal openOrderToIndex;

    mapping(address => SellerInfo) internal addrToSeller;
    mapping(address => BuyerInfo) internal addrToBuyer;
    address[] internal sellers;
    address[] internal buyers;

    mapping(address => uint256[]) internal sellerOrders;
    mapping(address => uint256[]) internal sellerOpenOrders;
    mapping(address => mapping(uint256 => uint256)) internal sellerOpenToIndex;

    mapping(address => uint256[]) internal buyerOrders;
    mapping(address => uint256[]) internal buyerFilledOrders;
    mapping(address => mapping(uint256 => bool)) internal buyerOrderParticipated;

    mapping(uint256 => OrderExtraInfo) internal orderIdToExtraInfo;
    address internal platformAddress;
    uint256 internal platformFeeRate;

    mapping(address => mapping(uint256 => bool)) internal buyerOrderPartialFilled;
}

/**
 * @notice The implementation of the Pasar market contract for trading Feeds sticker art tokens
 */
contract FeedsNFTPasar is
    IERC165,
    IERC1155TokenReceiver,
    IPasarOrder,
    IPasarInfo,
    IVersion,
    IPasarUpgraded,
    FeedsNFTPasarStorage
{
    using SafeMath for uint256;
    using AddressUtils for address;

    string internal constant contractName = "Feeds NFT Pasar";
    string internal constant version = "v0.1";
    string internal constant magic = "20210801";

    /**
     * @dev Set address for library logic contract
     * @param _codeAddress The address of the library logic contract
     * @dev Code position in storage is
     * keccak256("PASAR_LIBRARY_LOGIC") = "0x8decb83e16232115210946013564c85a5b770f53d127a96cbb4db17de226ddf6"
     */
    function setLibraryLogicContract(address _codeAddress) external inited onlyOwner {
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            sstore(0x8decb83e16232115210946013564c85a5b770f53d127a96cbb4db17de226ddf6, _codeAddress)
        }

        emit LibraryLogicContract(_codeAddress);
    }

    /**
     * @dev Call functions in the library logic contract
     * @dev Code position in storage is
     * keccak256("PASAR_LIBRARY_LOGIC") = "0x8decb83e16232115210946013564c85a5b770f53d127a96cbb4db17de226ddf6"
     * @param _data The ABI encoded data to call the library logic contract with
     */
    function callLibraryLogicContract(bytes memory _data) internal returns (bool _success, bytes memory _returnData) {
        address codeAddress;

        // solium-disable-next-line security/no-inline-assembly
        assembly {
            codeAddress := sload(0x8decb83e16232115210946013564c85a5b770f53d127a96cbb4db17de226ddf6)
        }

        require(codeAddress != address(0x0), "Library contract not set");

        (_success, _returnData) = codeAddress.delegatecall(_data);

        if (_success == false) {
            assembly {
                let ptr := mload(0x40)
                let size := returndatasize()
                returndatacopy(ptr, 0, size)
                revert(ptr, size)
            }
        }
    }

    /**
     * @notice get the code address of the library logic contract
     * @dev Code position in storage is
     * keccak256("PASAR_LIBRARY_LOGIC") = "0x8decb83e16232115210946013564c85a5b770f53d127a96cbb4db17de226ddf6"
     * @return _codeAddress Library logic contract address
     */
    function getLibraryLogicContract() external view returns (address _codeAddress) {
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            _codeAddress := sload(0x8decb83e16232115210946013564c85a5b770f53d127a96cbb4db17de226ddf6)
        }
    }

    function supportsInterface(bytes4 _interfaceId) public pure override returns (bool) {
        return
            _interfaceId == INTERFACE_SIGNATURE_ERC165 ||
            _interfaceId == INTERFACE_SIGNATURE_ERC1155TokenReceiver ||
            _interfaceId == INTERFACE_SIGNATURE_FeedsContractProxiable;
    }

    function initialize() external pure override {
        revert("Do not use this method");
    }

    function initialize(address _tokenAddress) external {
        _initialize();

        require(
            IERC165(_tokenAddress).supportsInterface(INTERFACE_SIGNATURE_ERC1155) &&
                IERC165(_tokenAddress).supportsInterface(INTERFACE_SIGNATURE_TokenRoyalty),
            "Token must be ERC1155 compliant with TokenRoyalty extension"
        );
        tokenAddress = _tokenAddress;
        token = IERC1155WithRoyalty(_tokenAddress);
    }

    /**
     * @notice Handle the receipt of a single ERC1155 token type.
     * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
     * This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.
     * This function MUST revert if it rejects the transfer.
     * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
     * @param _operator  The address which initiated the transfer (i.e. msg.sender)
     * @param _from      The address which previously owned the token
     * @param _id        The ID of the token being transferred
     * @param _value     The amount of tokens being transferred
     * @param _data      Additional data with no specified format
     * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
     */
    function onERC1155Received(
        address _operator,
        address _from,
        uint256 _id,
        uint256 _value,
        bytes calldata _data
    ) external override inited returns (bytes4) {
        emit ERC1155Received(_operator, _from, _id, _value, _data);
        return ERC1155_ACCEPTED;
    }

    /**
     * @notice Handle the receipt of multiple ERC1155 token types.
     * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
     * This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).
     * This function MUST revert if it rejects the transfer(s).
     * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
     * @param _operator  The address which initiated the batch transfer (i.e. msg.sender)
     * @param _from      The address which previously owned the token
     * @param _ids       An array containing ids of each token being transferred (order and length must match _values array)
     * @param _values    An array containing amounts of each token being transferred (order and length must match _ids array)
     * @param _data      Additional data with no specified format
     * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
     */
    function onERC1155BatchReceived(
        address _operator,
        address _from,
        uint256[] calldata _ids,
        uint256[] calldata _values,
        bytes calldata _data
    ) external override inited returns (bytes4) {
        emit ERC1155BatchReceived(_operator, _from, _ids, _values, _data);
        return ERC1155_BATCH_ACCEPTED;
    }

    /**
     * @notice Create a new order for sale at a fixed price
     * @param _tokenId The token type placed on sale
     * @param _amount The amount of token placed on sale
     * @param _price The fixed price asked for the sale order
     * @param _didUri DID URI of the seller
     */
    function createOrderForSale(
        uint256 _tokenId,
        uint256 _amount,
        uint256 _price,
        string calldata _didUri
    ) external override inited reentrancyGuard {
        require(token.isApprovedForAll(msg.sender, address(this)), "Contract is not approved");
        require(_amount > 0 && _price > 0, "Amount and price cannot be zero");
        require(token.tokenRoyaltyFee(_tokenId).add(platformFeeRate) <= RATE_BASE, "Total fee rate exceeds 100%");

        token.safeTransferFrom(msg.sender, address(this), _tokenId, _amount, PASAR_DATA_MAGIC);

        OrderInfo memory newOrder;
        newOrder.orderId = orders.length;
        newOrder.orderType = 1;
        newOrder.orderState = 1;
        newOrder.tokenId = _tokenId;
        newOrder.amount = _amount;
        newOrder.price = _price;
        newOrder.sellerAddr = msg.sender;
        newOrder.createTime = block.timestamp;
        newOrder.updateTime = block.timestamp;
        orders.push(newOrder);

        openOrderToIndex[newOrder.orderId] = openOrders.length;
        openOrders.push(newOrder.orderId);

        callLibraryLogicContract(
            abi.encodeWithSignature("_newOrderSeller(address,uint256)", msg.sender, newOrder.orderId)
        );

        emit OrderForSale(msg.sender, newOrder.orderId, _tokenId, _amount, _price);

        orderIdToExtraInfo[newOrder.orderId].sellerUri = _didUri;
        emit OrderDIDURI(_didUri, "", msg.sender, address(0x0), newOrder.orderId);
    }

    /**
     * @notice Create a new order for auction
     * @param _tokenId The token type placed on auction
     * @param _amount The amount of token placed on auction
     * @param _minPrice The minimum starting price for bidding on the auction
     * @param _endTime The time for ending the auction
     * @param _didUri DID URI of the seller
     */
    function createOrderForAuction(
        uint256 _tokenId,
        uint256 _amount,
        uint256 _minPrice,
        uint256 _endTime,
        string calldata _didUri
    ) external override inited reentrancyGuard {
        require(token.isApprovedForAll(msg.sender, address(this)), "Contract is not approved");
        require(_amount > 0 && _minPrice > 0, "Amount and price cannot be zero");
        require(_endTime > block.timestamp, "End time cannot be in the past");
        require(token.tokenRoyaltyFee(_tokenId).add(platformFeeRate) <= RATE_BASE, "Total fee rate exceeds 100%");

        token.safeTransferFrom(msg.sender, address(this), _tokenId, _amount, PASAR_DATA_MAGIC);

        OrderInfo memory newOrder;
        newOrder.orderId = orders.length;
        newOrder.orderType = 2;
        newOrder.orderState = 1;
        newOrder.tokenId = _tokenId;
        newOrder.amount = _amount;
        newOrder.price = _minPrice;
        newOrder.endTime = _endTime;
        newOrder.sellerAddr = msg.sender;
        newOrder.createTime = block.timestamp;
        newOrder.updateTime = block.timestamp;
        orders.push(newOrder);

        openOrderToIndex[newOrder.orderId] = openOrders.length;
        openOrders.push(newOrder.orderId);

        callLibraryLogicContract(
            abi.encodeWithSignature("_newOrderSeller(address,uint256)", msg.sender, newOrder.orderId)
        );

        emit OrderForAuction(msg.sender, newOrder.orderId, _tokenId, _amount, _minPrice, _endTime);

        orderIdToExtraInfo[newOrder.orderId].sellerUri = _didUri;
        emit OrderDIDURI(_didUri, "", msg.sender, address(0x0), newOrder.orderId);
    }

    /**
     * @notice Buy a sale order with fixed price
     * @dev The value of the transaction must equal to the fixed price asked for the order
     * @param _orderId The id of the fixed price sale order
     * @param _didUri DID URI of the buyer
     */
    function buyOrder(uint256 _orderId, string calldata _didUri) external payable override inited reentrancyGuard {
        require(orders[_orderId].orderType == 1 && orders[_orderId].orderState == 1, "Invalid order ID");
        require(msg.value == orders[_orderId].price, "Must pay the exact price for order");

        callLibraryLogicContract(abi.encodeWithSignature("_newOrderBuyer(address,uint256)", msg.sender, _orderId));
        callLibraryLogicContract(
            abi.encodeWithSignature("_fillOrder(address,uint256,uint256)", msg.sender, _orderId, msg.value)
        );

        orderIdToExtraInfo[_orderId].buyerUri = _didUri;
        emit OrderDIDURI(
            orderIdToExtraInfo[_orderId].sellerUri,
            _didUri,
            orders[_orderId].sellerAddr,
            msg.sender,
            _orderId
        );
    }

    /**
     * @notice Bid on an auction order
     * @dev The value of the transaction must be greater than or equal to the minimum starting price of the oder
     * @dev If the order has past bid(s), the value of the transaction must be greater than the last bid
     * @param _orderId The id of the auction order
     * @param _didUri DID URI of the buyer
     */
    function bidForOrder(uint256 _orderId, string calldata _didUri) external payable override inited reentrancyGuard {
        require(orders[_orderId].orderType == 2 && orders[_orderId].orderState == 1, "Invalid order ID");
        if (orders[_orderId].endTime < block.timestamp) {
            callLibraryLogicContract(abi.encodeWithSignature("_settleAuction(uint256)", _orderId));
            return;
        }

        require(msg.value >= orders[_orderId].price && msg.value > orders[_orderId].lastBid, "Invalid bid");

        callLibraryLogicContract(abi.encodeWithSignature("_newOrderBuyer(address,uint256)", msg.sender, _orderId));
        if (orders[_orderId].lastBidder != address(0x0)) {
            (bool success, ) = payable(orders[_orderId].lastBidder).call{value: orders[_orderId].lastBid}("");
            require(success || orders[_orderId].lastBidder.isContract(), "Something is wrong in auction");
        }
        orders[_orderId].lastBidder = msg.sender;
        orders[_orderId].lastBid = msg.value;
        orders[_orderId].bids = orders[_orderId].bids.add(1);
        orders[_orderId].updateTime = block.timestamp;
        emit OrderBid(orders[_orderId].sellerAddr, msg.sender, _orderId, msg.value);

        orderIdToExtraInfo[_orderId].buyerUri = _didUri;
        emit OrderDIDURI(
            orderIdToExtraInfo[_orderId].sellerUri,
            _didUri,
            orders[_orderId].sellerAddr,
            msg.sender,
            _orderId
        );
    }

    /**
     * @notice Cancel an order
     * @dev Only an open sale order or an auction order with no bid yet can be canceled
     * @dev Only an order's seller can cancel the order
     * @param _orderId The id of the order to be canceled
     */
    function cancelOrder(uint256 _orderId) external override inited reentrancyGuard {
        require(orders[_orderId].orderState == 1, "Invalid order state");
        require(msg.sender == orders[_orderId].sellerAddr, "Only seller can cancel own order");

        if (orders[_orderId].orderType == 2) {
            if (orders[_orderId].endTime < block.timestamp) {
                callLibraryLogicContract(abi.encodeWithSignature("_settleAuction(uint256)", _orderId));
                return;
            }
            require(orders[_orderId].lastBidder == address(0x0), "Cannot cancel auction with valid bid");
        }
        callLibraryLogicContract(abi.encodeWithSignature("_cancelOrder(uint256)", _orderId));
        addrToSeller[msg.sender].lastActionTime = block.timestamp;
    }

    /**
     * @notice Settle an auction
     * @dev Only an auction order past its end time can be settled
     * @dev Anyone can settle an auction
     * @param _orderId The id of the order to be settled
     */
    function settleAuctionOrder(uint256 _orderId) external override inited reentrancyGuard {
        require(orders[_orderId].orderType == 2 && orders[_orderId].endTime < block.timestamp, "Invalid order ID");

        callLibraryLogicContract(abi.encodeWithSignature("_settleAuction(uint256)", _orderId));
    }

    /**
     * @notice Change the price of an order
     * @dev Only an open sale order or an auction order with no bid yet can have its price changed.
     * @dev For sale orders, the fixed price asked for the order is changed.
     * @dev for auction orders, the minimum starting price for the bids is changed.
     * @dev Only an order's seller can change its price
     * @param _orderId The id of the order with its price to be changed
     */
    function changeOrderPrice(uint256 _orderId, uint256 _price) external override inited reentrancyGuard {
        require(orders[_orderId].orderState == 1, "Invalid order state");
        require(msg.sender == orders[_orderId].sellerAddr, "Only seller can change own order price");

        if (orders[_orderId].orderType == 3) {
            require(
                orderIdToExtraInfo[_orderId].priceLeft == orders[_orderId].price,
                "Partially filled orders cannot change price"
            );
        }

        if (orders[_orderId].orderType == 2) {
            if (orders[_orderId].endTime < block.timestamp) {
                callLibraryLogicContract(abi.encodeWithSignature("_settleAuction(uint256)", _orderId));
                return;
            }
            require(orders[_orderId].lastBidder == address(0x0), "Cannot change auction price with valid bid");
        }

        uint256 oldPrice = orders[_orderId].price;
        orders[_orderId].price = _price;
        orders[_orderId].updateTime = block.timestamp;

        addrToSeller[msg.sender].lastActionTime = block.timestamp;

        emit OrderPriceChanged(msg.sender, _orderId, oldPrice, _price);
    }

    /**
     * @notice Get the NFT token address accepted by the Pasar
     * @return The NFT token address
     */
    function getTokenAddress() external view override returns (address) {
        return tokenAddress;
    }

    /**
     * @notice Get the total number of orders ever created in the Pasar
     * @return The number of orders
     */
    function getOrderCount() external view override returns (uint256) {
        return orders.length;
    }

    /**
     * @notice Get order information of a given order
     * @param _orderId The id of the order, should be less than `getOrderCount`
     * @return Order information
     */
    function getOrderById(uint256 _orderId) external view override returns (OrderInfo memory) {
        return orders[_orderId];
    }

    /**
     * @notice Get order information of multiple orders
     * @param _orderIds The ids of the orders
     * @return Array of multiple order information
     */
    function getOrderByIdBatch(uint256[] calldata _orderIds) external view override returns (OrderInfo[] memory) {
        OrderInfo[] memory _orders = new OrderInfo[](_orderIds.length);

        for (uint256 i = 0; i < _orderIds.length; ++i) {
            _orders[i] = orders[_orderIds[i]];
        }

        return _orders;
    }

    /**
     * @notice Get the number of open orders currently in the Pasar
     * @return The number of open orders
     */
    function getOpenOrderCount() external view override returns (uint256) {
        return openOrders.length;
    }

    /**
     * @notice Enumerate order information of an open order
     * @param _index A counter less than `getOpenOrderCount`
     * @return Order information
     */
    function getOpenOrderByIndex(uint256 _index) external view override returns (OrderInfo memory) {
        return orders[openOrders[_index]];
    }

    /**
     * @notice Enumerate order information for multiple indexes
     * @param _indexes An array of counters less than `getOpenOrderCount`
     * @return Array of multiple order information
     */
    function getOpenOrderByIndexBatch(uint256[] calldata _indexes)
        external
        view
        override
        returns (OrderInfo[] memory)
    {
        OrderInfo[] memory _orders = new OrderInfo[](_indexes.length);

        for (uint256 i = 0; i < _indexes.length; ++i) {
            _orders[i] = orders[openOrders[_indexes[i]]];
        }

        return _orders;
    }

    /**
     * @notice Get the total number of sellers participated in the Pasar
     * @return The number of sellers
     */
    function getSellerCount() external view override returns (uint256) {
        return sellers.length;
    }

    /**
     * @notice Get seller information of a given seller
     * @param _seller The address of the seller
     * @return Seller information
     */
    function getSellerByAddr(address _seller) external view override returns (SellerInfo memory) {
        return addrToSeller[_seller];
    }

    /**
     * @notice Enumerate seller information of a given seller
     * @param _index A counter less than `getSellerCount`
     * @return Seller information
     */
    function getSellerByIndex(uint256 _index) external view override returns (SellerInfo memory) {
        return addrToSeller[sellers[_index]];
    }

    /**
     * @notice Enumerate seller information for multiple indexes
     * @param _indexes An array of counters less than `getSellerCount`
     * @return Array of multiple seller information
     */
    function getSellerByIndexBatch(uint256[] calldata _indexes) external view override returns (SellerInfo[] memory) {
        SellerInfo[] memory _sellers = new SellerInfo[](_indexes.length);

        for (uint256 i = 0; i < _indexes.length; ++i) {
            _sellers[i] = addrToSeller[sellers[_indexes[i]]];
        }

        return _sellers;
    }

    /**
     * @notice Enumerate order information created by a given seller
     * @param _seller A seller address
     * @param _index A counter less than `orderCount` of a given seller
     * @return Order information
     */
    function getSellerOrderByIndex(address _seller, uint256 _index)
        external
        view
        override
        returns (OrderInfo memory)
    {
        return orders[sellerOrders[_seller][_index]];
    }

    /**
     * @notice Enumerate order information for multiple indexes created by a given seller
     * @param _seller A seller address
     * @param _indexes An array of counters less than `orderCount` of a given seller
     * @return Array of multiple order information
     */
    function getSellerOrderByIndexBatch(address _seller, uint256[] calldata _indexes)
        external
        view
        override
        returns (OrderInfo[] memory)
    {
        OrderInfo[] memory _orders = new OrderInfo[](_indexes.length);

        for (uint256 i = 0; i < _indexes.length; ++i) {
            _orders[i] = orders[sellerOrders[_seller][_indexes[i]]];
        }

        return _orders;
    }

    /**
     * @notice Enumerate open order information created by a given seller
     * @param _seller A seller address
     * @param _index A counter less than `openCount` of a given seller
     * @return Order information
     */
    function getSellerOpenByIndex(address _seller, uint256 _index) external view override returns (OrderInfo memory) {
        return orders[sellerOpenOrders[_seller][_index]];
    }

    /**
     * @notice Enumerate open order information for multiple indexes created by a given seller
     * @param _seller A seller address
     * @param _indexes An array of counters less than `openCount` of a given seller
     * @return Array of multiple order information
     */
    function getSellerOpenByIndexBatch(address _seller, uint256[] calldata _indexes)
        external
        view
        override
        returns (OrderInfo[] memory)
    {
        OrderInfo[] memory _orders = new OrderInfo[](_indexes.length);

        for (uint256 i = 0; i < _indexes.length; ++i) {
            _orders[i] = orders[sellerOpenOrders[_seller][_indexes[i]]];
        }

        return _orders;
    }

    /**
     * @notice Get the total number of buyers participated in the Pasar
     * @return The number of buyers
     */
    function getBuyerCount() external view override returns (uint256) {
        return buyers.length;
    }

    /**
     * @notice Get buyer information of a given buyer
     * @param _buyer The address of the buyer
     * @return Buyer information
     */
    function getBuyerByAddr(address _buyer) external view override returns (BuyerInfo memory) {
        return addrToBuyer[_buyer];
    }

    /**
     * @notice Enumerate buyer information of a given buyer
     * @param _index A counter less than `getBuyerCount`
     * @return Buyer information
     */
    function getBuyerByIndex(uint256 _index) external view override returns (BuyerInfo memory) {
        return addrToBuyer[buyers[_index]];
    }

    /**
     * @notice Enumerate buyer information for multiple indexes
     * @param _indexes An array of counters less than `getBuyerCount`
     * @return Array of multiple buyer information
     */
    function getBuyerByIndexBatch(uint256[] calldata _indexes) external view override returns (BuyerInfo[] memory) {
        BuyerInfo[] memory _buyers = new BuyerInfo[](_indexes.length);

        for (uint256 i = 0; i < _indexes.length; ++i) {
            _buyers[i] = addrToBuyer[buyers[_indexes[i]]];
        }

        return _buyers;
    }

    /**
     * @notice Enumerate order information a given buyer has participated
     * @param _buyer A buyer address
     * @param _index A counter less than `orderCount` of a given buyer
     * @return Order information
     */
    function getBuyerOrderByIndex(address _buyer, uint256 _index) external view override returns (OrderInfo memory) {
        return orders[buyerOrders[_buyer][_index]];
    }

    /**
     * @notice Enumerate order information for multiple indexes a given buyer has participated
     * @param _buyer A buyer address
     * @param _indexes An array of counters less than `orderCount` of a given buyer
     * @return Array of multiple order information
     */
    function getBuyerOrderByIndexBatch(address _buyer, uint256[] calldata _indexes)
        external
        view
        override
        returns (OrderInfo[] memory)
    {
        OrderInfo[] memory _orders = new OrderInfo[](_indexes.length);

        for (uint256 i = 0; i < _indexes.length; ++i) {
            _orders[i] = orders[buyerOrders[_buyer][_indexes[i]]];
        }

        return _orders;
    }

    /**
     * @notice Enumerate filled order information a given buyer has bought
     * @param _buyer A buyer address
     * @param _index A counter less than `filledCount` of a given buyer
     * @return Order information
     */
    function getBuyerFilledByIndex(address _buyer, uint256 _index) external view override returns (OrderInfo memory) {
        return orders[buyerFilledOrders[_buyer][_index]];
    }

    /**
     * @notice Enumerate filled order information for multiple indexes a given buyer has bought
     * @param _buyer A buyer address
     * @param _indexes An array of counters less than `filledCount` of a given buyer
     * @return Array of multiple order information
     */
    function getBuyerFilledByIndexBatch(address _buyer, uint256[] calldata _indexes)
        external
        view
        override
        returns (OrderInfo[] memory)
    {
        OrderInfo[] memory _orders = new OrderInfo[](_indexes.length);

        for (uint256 i = 0; i < _indexes.length; ++i) {
            _orders[i] = orders[buyerFilledOrders[_buyer][_indexes[i]]];
        }

        return _orders;
    }

    function getVersion() external pure override returns (string memory) {
        return version;
    }

    function getMagic() external pure override returns (string memory) {
        return magic;
    }

    /**
     * @notice Get extra order information for a given order from upgraded Pasar contract
     * @param _orderId The order identifier
     * @return The extra order information from upgraded Pasar contract
     */
    function getOrderExtraById(uint256 _orderId) external view override returns (OrderExtraInfo memory) {
        return orderIdToExtraInfo[_orderId];
    }

    /**
     * @notice Get extra order information for multiple orders from upgraded Pasar contract
     * @param _orderIds The order identifiers
     * @return The extra order information array from upgraded Pasar contract
     */
    function getOrderExtraByIdBatch(uint256[] calldata _orderIds)
        external
        view
        override
        returns (OrderExtraInfo[] memory)
    {
        OrderExtraInfo[] memory _extras = new OrderExtraInfo[](_orderIds.length);

        for (uint256 i = 0; i < _orderIds.length; ++i) {
            _extras[i] = orderIdToExtraInfo[_orderIds[i]];
        }

        return _extras;
    }

    /**
     * @notice Set the platform fee rate charged for each trade and the platform address to receive the fees
     * @param _platformAddress the platform address
     * @param _platformFeeRate The platform fee rate in terms of parts per million
     */
    function setPlatformFee(address _platformAddress, uint256 _platformFeeRate) external override inited onlyOwner {
        require(_platformFeeRate <= RATE_BASE, "Fee rate error");
        platformAddress = _platformAddress;
        platformFeeRate = _platformFeeRate;
    }

    /**
     * @notice Get the current platform fee parameters
     * @return _platformAddress the current platform address
     * @return _platformFeeRate the current platform fee rate
     */
    function getPlatformFee() external view override returns (address _platformAddress, uint256 _platformFeeRate) {
        _platformAddress = platformAddress;
        _platformFeeRate = platformFeeRate;
    }

    /**
     * @notice Create a new splittable order for sale at a fixed price
     * @param _tokenId The token type placed on sale
     * @param _amount The amount of token placed on sale
     * @param _price The fixed price asked for the sale order
     * @param _didUri DID URI of the seller
     */
    function createSplittableOrder(
        uint256 _tokenId,
        uint256 _amount,
        uint256 _price,
        string calldata _didUri
    ) external override inited reentrancyGuard {
        require(token.isApprovedForAll(msg.sender, address(this)), "Contract is not approved");
        require(_amount > 0 && _price > 0, "Amount and price cannot be zero");
        require(token.tokenRoyaltyFee(_tokenId).add(platformFeeRate) <= RATE_BASE, "Total fee rate exceeds 100%");

        token.safeTransferFrom(msg.sender, address(this), _tokenId, _amount, PASAR_DATA_MAGIC);

        OrderInfo memory newOrder;
        newOrder.orderId = orders.length;
        newOrder.orderType = 3;
        newOrder.orderState = 1;
        newOrder.tokenId = _tokenId;
        newOrder.amount = _amount;
        newOrder.price = _price;
        newOrder.sellerAddr = msg.sender;
        newOrder.createTime = block.timestamp;
        newOrder.updateTime = block.timestamp;
        orders.push(newOrder);

        openOrderToIndex[newOrder.orderId] = openOrders.length;
        openOrders.push(newOrder.orderId);

        callLibraryLogicContract(
            abi.encodeWithSignature("_newOrderSeller(address,uint256)", msg.sender, newOrder.orderId)
        );

        emit OrderSplittable(msg.sender, newOrder.orderId, _tokenId, _amount, _price);

        orderIdToExtraInfo[newOrder.orderId].sellerUri = _didUri;
        orderIdToExtraInfo[newOrder.orderId].priceLeft = _price;
        orderIdToExtraInfo[newOrder.orderId].amountLeft = _amount;
        emit OrderDIDURI(_didUri, "", msg.sender, address(0x0), newOrder.orderId);
    }

    /**
     * @notice Buy a splittable order with fixed price
     * @dev The value of the transaction must equal to the price corresponding to the amount to be purchased
     * @param _orderId The id of the fixed price splittable order
     * @param _amount The amount to be purchased, must be less than or equal to `amountLeft` of the order
     * @param _didUri DID URI of the buyer
     */
    function buySplittableOrder(
        uint256 _orderId,
        uint256 _amount,
        string calldata _didUri
    ) external payable override inited reentrancyGuard {
        require(orders[_orderId].orderType == 3 && orders[_orderId].orderState == 1, "Invalid order ID");
        require(_amount <= orderIdToExtraInfo[_orderId].amountLeft, "Not enough token amount left in the order");
        uint256 buyPrice = orderIdToExtraInfo[_orderId].priceLeft.mul(_amount).div(
            orderIdToExtraInfo[_orderId].amountLeft
        );
        require(msg.value == buyPrice, "Must pay the exact price for the order amount");

        callLibraryLogicContract(abi.encodeWithSignature("_newOrderBuyer(address,uint256)", msg.sender, _orderId));
        callLibraryLogicContract(
            abi.encodeWithSignature(
                "_partialFill(address,string,uint256,uint256,uint256)",
                msg.sender,
                _didUri,
                _orderId,
                msg.value,
                _amount
            )
        );

        orderIdToExtraInfo[_orderId].buyerUri = _didUri;
        emit OrderDIDURI(
            orderIdToExtraInfo[_orderId].sellerUri,
            _didUri,
            orders[_orderId].sellerAddr,
            msg.sender,
            _orderId
        );
    }
}

/**
 * @dev Library logic contract for Pasar
 * @dev Split internal library code logic to avoid reaching the max code size limit for the Pasar contract
 */
contract FeedsNFTPasarLibrary is FeedsNFTPasarStorage {
    using SafeMath for uint256;

    function _newOrderSeller(address _seller, uint256 _id) public payable inited {
        if (addrToSeller[_seller].sellerAddr == address(0x0)) {
            addrToSeller[_seller].index = sellers.length;
            addrToSeller[_seller].sellerAddr = _seller;
            addrToSeller[_seller].joinTime = block.timestamp;
            sellers.push(_seller);
        }
        addrToSeller[_seller].lastActionTime = block.timestamp;

        sellerOpenToIndex[_seller][_id] = sellerOpenOrders[_seller].length;
        sellerOrders[_seller].push(_id);
        sellerOpenOrders[_seller].push(_id);

        addrToSeller[_seller].orderCount = sellerOrders[_seller].length;
        addrToSeller[_seller].openCount = sellerOpenOrders[_seller].length;
    }

    function _newOrderBuyer(address _buyer, uint256 _id) public payable inited {
        if (addrToBuyer[_buyer].buyerAddr == address(0x0)) {
            addrToBuyer[_buyer].index = buyers.length;
            addrToBuyer[_buyer].buyerAddr = _buyer;
            addrToBuyer[_buyer].joinTime = block.timestamp;
            buyers.push(_buyer);
        }
        addrToBuyer[_buyer].lastActionTime = block.timestamp;

        if (!buyerOrderParticipated[_buyer][_id]) {
            buyerOrderParticipated[_buyer][_id] = true;
            buyerOrders[_buyer].push(_id);
            addrToBuyer[_buyer].orderCount = buyerOrders[_buyer].length;
        }
    }

    function _fillOrder(
        address _buyer,
        uint256 _id,
        uint256 _value
    ) public payable inited {
        orders[_id].orderState = 2;
        orders[_id].buyerAddr = _buyer;
        orders[_id].filled = _value;
        orders[_id].royaltyOwner = token.tokenRoyaltyOwner(orders[_id].tokenId);
        orders[_id].royaltyFee = _value.mul(token.tokenRoyaltyFee(orders[_id].tokenId)).div(RATE_BASE);
        orderIdToExtraInfo[_id].platformAddr = platformAddress;
        orderIdToExtraInfo[_id].platformFee = _value.mul(platformFeeRate).div(RATE_BASE);
        orders[_id].updateTime = block.timestamp;

        if (openOrderToIndex[_id] != openOrders.length.sub(1)) {
            uint256 index = openOrderToIndex[_id];
            openOrders[index] = openOrders[openOrders.length.sub(1)];
            openOrderToIndex[openOrders[index]] = index;
        }
        openOrderToIndex[_id] = 0;
        openOrders.pop();

        address seller = orders[_id].sellerAddr;
        if (sellerOpenToIndex[seller][_id] != sellerOpenOrders[seller].length.sub(1)) {
            uint256 index = sellerOpenToIndex[seller][_id];
            sellerOpenOrders[seller][index] = sellerOpenOrders[seller][sellerOpenOrders[seller].length.sub(1)];
            sellerOpenToIndex[seller][sellerOpenOrders[seller][index]] = index;
        }
        sellerOpenToIndex[seller][_id] = 0;
        sellerOpenOrders[seller].pop();
        addrToSeller[seller].openCount = sellerOpenOrders[seller].length;
        addrToSeller[seller].earned = _value.sub(orders[_id].royaltyFee).sub(orderIdToExtraInfo[_id].platformFee).add(
            addrToSeller[seller].earned
        );
        addrToSeller[seller].royalty = orders[_id].royaltyFee.add(addrToSeller[seller].royalty);
        addrToSeller[seller].platformFee = orderIdToExtraInfo[_id].platformFee.add(addrToSeller[seller].platformFee);

        buyerFilledOrders[_buyer].push(_id);
        addrToBuyer[_buyer].filledCount = buyerFilledOrders[_buyer].length;
        addrToBuyer[_buyer].paid = _value.add(addrToBuyer[_buyer].paid);
        addrToBuyer[_buyer].royalty = orders[_id].royaltyFee.add(addrToBuyer[_buyer].royalty);
        addrToBuyer[_buyer].platformFee = orderIdToExtraInfo[_id].platformFee.add(addrToBuyer[_buyer].platformFee);

        token.safeTransferFrom(address(this), _buyer, orders[_id].tokenId, orders[_id].amount, PASAR_DATA_MAGIC);
        bool success;
        if (orders[_id].royaltyFee > 0) {
            (success, ) = payable(orders[_id].royaltyOwner).call{value: orders[_id].royaltyFee}("");
            require(success, "Royalty transfer failed");
        }
        if (orderIdToExtraInfo[_id].platformFee > 0) {
            (success, ) = payable(orderIdToExtraInfo[_id].platformAddr).call{
                value: orderIdToExtraInfo[_id].platformFee
            }("");
            require(success, "Platform fee transfer failed");
        }
        (success, ) = payable(seller).call{
            value: orders[_id].filled.sub(orders[_id].royaltyFee).sub(orderIdToExtraInfo[_id].platformFee)
        }("");
        require(success, "Payment transfer failed");

        emit OrderFilled(seller, _buyer, _id, orders[_id].royaltyOwner, _value, orders[_id].royaltyFee);
        emit OrderPlatformFee(
            orderIdToExtraInfo[_id].platformAddr,
            orderIdToExtraInfo[_id].platformFee,
            seller,
            _buyer,
            _id
        );
    }

    function _partialFill(
        address _buyer,
        string memory _buyerUri,
        uint256 _id,
        uint256 _value,
        uint256 _amount
    ) public payable inited {
        PartialFillInfo memory newPartialFill;
        newPartialFill.buyerAddr = _buyer;
        newPartialFill.buyerUri = _buyerUri;
        newPartialFill.value = _value;
        newPartialFill.amount = _amount;
        newPartialFill.fillTime = block.timestamp;
        newPartialFill.royaltyOwner = token.tokenRoyaltyOwner(orders[_id].tokenId);
        newPartialFill.royaltyFee = _value.mul(token.tokenRoyaltyFee(orders[_id].tokenId)).div(RATE_BASE);
        newPartialFill.platformAddr = platformAddress;
        newPartialFill.platformFee = _value.mul(platformFeeRate).div(RATE_BASE);
        orderIdToExtraInfo[_id].partialFills.push(newPartialFill);

        orders[_id].buyerAddr = _buyer;
        orders[_id].filled = orders[_id].filled.add(_value);
        orders[_id].royaltyOwner = token.tokenRoyaltyOwner(orders[_id].tokenId);
        orders[_id].royaltyFee = orders[_id].royaltyFee.add(newPartialFill.royaltyFee);
        orderIdToExtraInfo[_id].platformAddr = platformAddress;
        orderIdToExtraInfo[_id].platformFee = orderIdToExtraInfo[_id].platformFee.add(newPartialFill.platformFee);
        orders[_id].updateTime = block.timestamp;

        orderIdToExtraInfo[_id].priceLeft = orderIdToExtraInfo[_id].priceLeft.sub(_value);
        orderIdToExtraInfo[_id].amountLeft = orderIdToExtraInfo[_id].amountLeft.sub(_amount);

        require(
            orderIdToExtraInfo[_id].priceLeft.mul(orderIdToExtraInfo[_id].amountLeft) == 0
                ? orderIdToExtraInfo[_id].priceLeft.add(orderIdToExtraInfo[_id].amountLeft) == 0
                : true,
            "Should not happen with splittable order"
        );

        address seller = orders[_id].sellerAddr;

        if (orderIdToExtraInfo[_id].amountLeft == 0) {
            orders[_id].orderState = 2;
            if (openOrderToIndex[_id] != openOrders.length.sub(1)) {
                uint256 index = openOrderToIndex[_id];
                openOrders[index] = openOrders[openOrders.length.sub(1)];
                openOrderToIndex[openOrders[index]] = index;
            }
            openOrderToIndex[_id] = 0;
            openOrders.pop();

            if (sellerOpenToIndex[seller][_id] != sellerOpenOrders[seller].length.sub(1)) {
                uint256 index = sellerOpenToIndex[seller][_id];
                sellerOpenOrders[seller][index] = sellerOpenOrders[seller][sellerOpenOrders[seller].length.sub(1)];
                sellerOpenToIndex[seller][sellerOpenOrders[seller][index]] = index;
            }
            sellerOpenToIndex[seller][_id] = 0;
            sellerOpenOrders[seller].pop();
            addrToSeller[seller].openCount = sellerOpenOrders[seller].length;
        }

        addrToSeller[seller].earned = _value.sub(newPartialFill.royaltyFee).sub(newPartialFill.platformFee).add(
            addrToSeller[seller].earned
        );
        addrToSeller[seller].royalty = newPartialFill.royaltyFee.add(addrToSeller[seller].royalty);
        addrToSeller[seller].platformFee = newPartialFill.platformFee.add(addrToSeller[seller].platformFee);

        if (!buyerOrderPartialFilled[_buyer][_id]) {
            buyerOrderPartialFilled[_buyer][_id] = true;
            buyerFilledOrders[_buyer].push(_id);
            addrToBuyer[_buyer].filledCount = buyerFilledOrders[_buyer].length;
        }
        addrToBuyer[_buyer].paid = _value.add(addrToBuyer[_buyer].paid);
        addrToBuyer[_buyer].royalty = newPartialFill.royaltyFee.add(addrToBuyer[_buyer].royalty);
        addrToBuyer[_buyer].platformFee = newPartialFill.platformFee.add(addrToBuyer[_buyer].platformFee);

        token.safeTransferFrom(address(this), _buyer, orders[_id].tokenId, _amount, PASAR_DATA_MAGIC);
        bool success;
        if (newPartialFill.royaltyFee > 0) {
            (success, ) = payable(newPartialFill.royaltyOwner).call{value: newPartialFill.royaltyFee}("");
            require(success, "Royalty transfer failed");
        }
        if (newPartialFill.platformFee > 0) {
            (success, ) = payable(newPartialFill.platformAddr).call{value: newPartialFill.platformFee}("");
            require(success, "Platform fee transfer failed");
        }
        (success, ) = payable(seller).call{
            value: _value.sub(newPartialFill.royaltyFee).sub(newPartialFill.platformFee)
        }("");
        require(success, "Payment transfer failed");

        emit PartialFilled(
            seller,
            _buyer,
            _id,
            newPartialFill.royaltyOwner,
            _value,
            _amount,
            orderIdToExtraInfo[_id].priceLeft,
            orderIdToExtraInfo[_id].amountLeft,
            newPartialFill.royaltyFee
        );
        emit OrderFilled(seller, _buyer, _id, newPartialFill.royaltyOwner, _value, newPartialFill.royaltyFee);
        emit OrderPlatformFee(newPartialFill.platformAddr, newPartialFill.platformFee, seller, _buyer, _id);
    }

    function _settleAuction(uint256 _id) public payable inited {
        if (msg.value > 0) {
            (bool success, ) = msg.sender.call{value: msg.value}("");
            require(success, "Refund failed in settleAuction");
        }
        if (orders[_id].lastBidder == address(0x0)) {
            _cancelOrder(_id);
        } else {
            _fillOrder(orders[_id].lastBidder, _id, orders[_id].lastBid);
        }
    }

    function _cancelOrder(uint256 _id) public payable inited {
        orders[_id].orderState = 3;
        orders[_id].updateTime = block.timestamp;

        if (openOrderToIndex[_id] != openOrders.length.sub(1)) {
            uint256 index = openOrderToIndex[_id];
            openOrders[index] = openOrders[openOrders.length.sub(1)];
            openOrderToIndex[openOrders[index]] = index;
        }
        openOrderToIndex[_id] = 0;
        openOrders.pop();

        address seller = orders[_id].sellerAddr;
        if (sellerOpenToIndex[seller][_id] != sellerOpenOrders[seller].length.sub(1)) {
            uint256 index = sellerOpenToIndex[seller][_id];
            sellerOpenOrders[seller][index] = sellerOpenOrders[seller][sellerOpenOrders[seller].length.sub(1)];
            sellerOpenToIndex[seller][sellerOpenOrders[seller][index]] = index;
        }
        sellerOpenToIndex[seller][_id] = 0;
        sellerOpenOrders[seller].pop();
        addrToSeller[seller].openCount = sellerOpenOrders[seller].length;

        if (orders[_id].orderType == 3) {
            token.safeTransferFrom(
                address(this),
                seller,
                orders[_id].tokenId,
                orderIdToExtraInfo[_id].amountLeft,
                PASAR_DATA_MAGIC
            );
            emit PartialCanceled(seller, _id, orderIdToExtraInfo[_id].priceLeft, orderIdToExtraInfo[_id].amountLeft);
        } else {
            token.safeTransferFrom(address(this), seller, orders[_id].tokenId, orders[_id].amount, PASAR_DATA_MAGIC);
        }

        emit OrderCanceled(seller, _id);
    }
}
