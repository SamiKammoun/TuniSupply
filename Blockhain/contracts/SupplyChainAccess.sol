// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../node_modules/@openzeppelin/contracts/access/AccessControlEnumerable.sol";

contract SupplyChainAccess is AccessControlEnumerable {
    bytes32 public constant Government = 0x00;
    bytes32 public constant Manufacturer = bytes32(uint256(1));
    bytes32 public constant Vendor = bytes32(uint256(2));
    bytes32 public constant Transporter = bytes32(uint256(3));

    mapping(uint256 => address[]) public ManufacturersOf;
    mapping(address => mapping(uint256 => bool)) public isManufacturerOf;

    modifier onlyManufacturerOf(uint256 itemId) {
        require(hasRole(Manufacturer, _msgSender()));
        require(isManufacturerOf[_msgSender()][itemId]);
        _;
    }

    constructor() {
        _setupRole(Government, _msgSender());
    }

    function getManufacturers(
        uint256 _item
    ) public view returns (address[] memory) {
        return ManufacturersOf[_item];
    }

    function _addManufacturerToItem(
        address _manufacturer,
        uint256 item
    ) internal {
        require(
            hasRole(Manufacturer, _manufacturer),
            "Address is not a manufacturer"
        );
        require(
            !isManufacturerOf[_manufacturer][item],
            "Address is already a manufacturer of this item"
        );
        isManufacturerOf[_manufacturer][item] = true;
        ManufacturersOf[item].push(_manufacturer);
    }

    function _removeManufacturerOfItem(
        address _manufacturer,
        uint256 item,
        uint256 index
    ) internal {
        require(
            isManufacturerOf[_manufacturer][item],
            "Address is not a manufacturer of this item"
        );
        require(ManufacturersOf[item][index] == _manufacturer, "Invalid index");
        isManufacturerOf[_manufacturer][item] = false;
        delete ManufacturersOf[item][index];
    }
}
