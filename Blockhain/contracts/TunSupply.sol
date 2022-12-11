// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../node_modules/@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./SupplyChainAccess.sol";
import "./Transfer2Factor.sol";

contract TunSupply is SupplyChainAccess, ERC1155, Transfer2Factor {
    uint256 public counter;
    string public name = "TunSupply";
    event itemIssued(address manufacturer, uint256 itemId, string _uri);
    event itemProduced(address manufacturer, uint256 itemId, uint256 amount);
    event itemSold(address vendor, uint256 itemId, uint256 amount);
    mapping(uint256 => string) private uriOf;

    constructor() ERC1155("") SupplyChainAccess() {}

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(ERC1155, AccessControlEnumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function produce(
        uint256 itemId,
        uint256 amount,
        bytes memory data
    ) public onlyManufacturerOf(itemId) {
        _mint(_msgSender(), itemId, amount, data);
        emit itemProduced(_msgSender(), itemId, amount);
    }

    function initiateTransfer(
        uint256 itemId,
        uint256 quantity,
        address to
    ) public {
        require(
            balanceOf(_msgSender(), itemId) - tokenApprovals[itemId] >=
                quantity,
            "Not enough quantity"
        );
        require(
            hasRole(Vendor, to) || hasRole(Transporter, to),
            "Can only transfer to vendor or transporter"
        );
        _addApproval(itemId, quantity, _msgSender(), to);
    }

    function uri(uint256 itemId) public view override returns (string memory) {
        return uriOf[itemId];
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public override {
        _removeApproval(id, amount, from, to);
        _safeTransferFrom(from, to, id, amount, data);
    }

    function issueItem(
        string memory _uri
    ) public onlyRole(Manufacturer) returns (uint256) {
        uint256 tokenId = counter;
        counter++;
        _addManufacturerToItem(_msgSender(), tokenId);
        _setItemUri(_uri, tokenId);
        emit itemIssued(_msgSender(), tokenId, _uri);
        return tokenId;
    }

    function soldItem(uint256 itemId, uint256 amount) public onlyRole(Vendor) {
        _burn(_msgSender(), itemId, amount);
        emit itemSold(_msgSender(), itemId, amount);
    }

    function updateItemDetails(
        string memory _uri,
        uint256 item
    ) public onlyRole(Manufacturer) onlyManufacturerOf(item) {
        _setItemUri(_uri, item);
    }

    function _setItemUri(string memory _uri, uint256 item) internal {
        uriOf[item] = _uri;
    }

    function getCounter() public view returns (uint256) {
        return counter;
    }
}
