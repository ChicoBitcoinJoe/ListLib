pragma solidity ^0.5.0;

contract IAddressList {
    function add (address value) public returns (bool success);
    function remove (address value) public returns (bool success);
    function contains (address value) public view returns (bool);
    function getValueAt (uint i) public view returns (address);
    function getIndexOf (address value) public view returns (uint);
    function getList () public view returns (address[] memory);
    function getLength () public view returns (uint);
}

contract IAddressListFactory {
    function create (address owner) public returns (IAddressList);
}
