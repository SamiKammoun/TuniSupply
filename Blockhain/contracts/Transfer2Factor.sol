// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Transfer2Factor {
    mapping(uint256 => uint256) public tokenApprovals;
    mapping(uint256 => mapping(address => mapping(address => uint256))) supplyApprovalOf;

    function _removeApproval(
        uint256 itemId,
        uint256 transferedquantity,
        address from,
        address to
    ) internal {
        require(supplyApprovalOf[itemId][from][to] >= transferedquantity);
        supplyApprovalOf[itemId][from][to] -= transferedquantity;
        tokenApprovals[itemId] -= transferedquantity;
    }

    function _addApproval(
        uint256 itemId,
        uint256 quantity,
        address from,
        address to
    ) internal {
        supplyApprovalOf[itemId][from][to] += quantity;
        tokenApprovals[itemId] += quantity;
    }
}
