pragma solidity ^0.5.0;

import "./external/Clone.sol";
import "./external/Owned.sol";
import "./AddressListLib.sol";
import "./Interfaces.sol";

contract AddressList is IAddressList, Owned, Clone {

    using AddressListLib for AddressListLib.AddressList;

    AddressListLib.AddressList list;

    function initialize (address _owner) public requireNotInitialized {
        owner = _owner;
    }

    function add (address item) public onlyOwner returns (bool) {
        return list.add(item);
    }

    function remove (address item) public onlyOwner returns (bool) {
        return list.remove(item);
    }

    function contains (address item) public view returns (bool) {
        return list.contains(item);
    }

    function getValueAt (uint i) public view returns (address) {
        return list.getValueAt(i);
    }

    function getIndexOf (address item) public view returns (uint){
        return list.getIndexOf(item);
    }

    function getList () public view returns (address[] memory) {
        return list.array;
    }

    function getLength () public view returns (uint) {
        return list.getLength();
    }

}

contract AddressListFactory is IAddressListFactory, CloneFactory {

    AddressList public Blueprint;

    constructor (AddressList _Blueprint) public {
        Blueprint = _Blueprint;
    }

    function create (address owner) public returns (IAddressList) {
        AddressList list = AddressList(createClone(address(Blueprint)));
        list.initialize(owner);
        emit Create_event (list);
        return list;
    }

    event Create_event (AddressList list);

}
