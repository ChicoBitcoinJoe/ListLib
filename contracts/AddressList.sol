pragma solidity ^0.5.0;

import "./external/CloneFactory.sol";
import "./external/Owned.sol";

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
    function createEmptyList (address owner) public returns (IAddressList);
    function createFromList (address owner, address[] memory items) public returns (IAddressList);
}

/// @dev A library for a simple unordered list that stores unique values.
library AddressListLib {

    struct AddressList {
        address[] array; // An unordered list of unique values
        mapping (address => bool) exists; // Tracks if a given value exists in the list
        mapping (address => uint) index; // Tracks the index of a value
    }

    /// @notice Called when a address value is added to 'list'
    /// @param list The storage that holds the list
    /// @param value The value to add to 'list'
    /// @return True if the 'value' is added, false if it already exists in the list
    function add (AddressList storage list, address value) public returns (bool success) {
        // Only add 'value' if it does not exist in the list
        if(list.exists[value])
            return false;

        list.index[value] = list.array.length;
        list.exists[value] = true;
        list.array.push(value);

        return true;
    }

    /// @notice Called when a address value is removed from 'list'
    /// @param list The storage that holds the list
    /// @param value The value to remove from 'list'
    /// @return True if the 'value' is removed, false if the 'value' did not exists in the list
    function remove (AddressList storage list, address value) public returns (bool success) {
        // Only remove 'value' if it exists in the list
        if(!list.exists[value])
            return false;

        uint indexBeingRemoved = list.index[value]; // The index of 'value'
        address replacement = list.array[list.array.length-1]; // The last value in the list

        // Move the replacement value to the index of 'value'
        list.array[indexBeingRemoved] = replacement;
        list.index[replacement] = indexBeingRemoved;
        list.array.length--;

        // clean up
        delete(list.exists[value]);
        delete(list.index[value]);

        return true;
    }

    /// @notice Fetches the length of the list
    /// @param list The storage that holds the list
    /// @param value The value to search for
    /// @return True if the value exists in the list
    function contains (AddressList storage list, address value) public view returns (bool) {
        return list.exists[value];
    }

    /// @notice Fetches the address of a given index
    /// @param list The storage that holds the list
    /// @param i The index to fetch
    /// @return The address at index 'i'
    function getValueAt (AddressList storage list, uint i) public view returns (address) {
        if(i >= getLength(list)) return address(0x0);
        return list.array[i];
    }

    /// @notice Fetches the index of a given address
    /// @param list The storage that holds the list
    /// @param value The address to fetch the index of
    /// @return The index of 'value'
    function getIndexOf (AddressList storage list, address value) public view returns (uint) {
        return list.index[value];
    }

    /// @notice Fetches the list of addresses
    /// @param list The storage that holds the list
    /// @return The list of addresses
    function getList (AddressList storage list) public view returns (address[] memory) {
        return list.array;
    }

    /// @notice Fetches the length of the list
    /// @param list The storage that holds the list
    /// @return The length of the 'list'
    function getLength (AddressList storage list) public view returns (uint) {
        return list.array.length;
    }

}

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

    function createEmptyList (address owner) public returns (IAddressList) {
        AddressList List = AddressList(createClone(address(Blueprint)));
        List.initialize(owner);
        emit Create_event (owner, List);
        return List;
    }

    function createFromList (address owner, address[] memory items) public returns (IAddressList) {
        AddressList List = AddressList(createClone(address(Blueprint)));
        List.initialize(address(this));
        for(uint i = 0; i < items.length; i++) {
            List.add(items[i]);
        }
        List.transferOwnership(owner);
        emit Create_event (owner, List);
        return List;
    }

    event Create_event (address owner, AddressList list);

}
