// Artifacts

const AddressListArtifact = artifacts.require("AddressList");
const AddressListFactoryArtifact = artifacts.require("AddressListFactory");

contract("AddressList", async (accounts) => {

    let nullAddress = '0x0000000000000000000000000000000000000000';

    let Blueprint;
    let Factory;
    let AddressList;

    let owner = accounts[9];
    let addressA = accounts[8];
    let addressB = accounts[7];
    let addressC = accounts[6];
    let addressD = accounts[5];

    it("deploy address list", async () => {
        Blueprint = await AddressListArtifact.new();
        Factory = await AddressListFactoryArtifact.new(Blueprint.address);
        let tx = await Factory.create(owner);
        AddressList = await AddressListArtifact.at(tx.logs[0].args.list);
    });

    it("add addresses to list", async () => {
        await AddressList.add(addressA, {from: owner});
        await AddressList.add(addressB, {from: owner});
        await AddressList.add(addressC, {from: owner});
        await AddressList.add(addressD, {from: owner});
        let length = await AddressList.getLength();
        let current = await AddressList.getList();
        let expected = [addressA, addressB, addressC, addressD];
        assert(current.toString() == expected.toString(), "current list does not match expected");
        assert(length == 4, "invalid length: should be 4");
        assert(await AddressList.contains(addressA), "should contain: " + addressA);
        assert(await AddressList.contains(addressB), "should contain: " + addressB);
        assert(await AddressList.contains(addressC), "should contain: " + addressC);
        assert(await AddressList.contains(addressD), "should contain: " + addressD);
        assert(await AddressList.getIndexOf(addressA) == 0, "incorrect index for: " + addressA);
        assert(await AddressList.getIndexOf(addressB) == 1, "incorrect index for: " + addressB);
        assert(await AddressList.getIndexOf(addressC) == 2, "incorrect index for: " + addressC);
        assert(await AddressList.getIndexOf(addressD) == 3, "incorrect index for: " + addressD);
        assert(await AddressList.getValueAt(0) == addressA, "incorrect value index 0");
        assert(await AddressList.getValueAt(1) == addressB, "incorrect value index 1");
        assert(await AddressList.getValueAt(2) == addressC, "incorrect value index 2");
        assert(await AddressList.getValueAt(3) == addressD, "incorrect value index 3");
    });

    it("remove addresses from list", async () => {
        await AddressList.remove(addressA, {from: owner});
        assert(await AddressList.getValueAt(0) == addressD, "incorrect value index 0");
        assert(await AddressList.getValueAt(1) == addressB, "incorrect value index 1");
        assert(await AddressList.getValueAt(2) == addressC, "incorrect value index 2");
        assert(await AddressList.getValueAt(3) == nullAddress, "incorrect value index 3");
        await AddressList.remove(addressB, {from: owner});
        assert(await AddressList.getValueAt(0) == addressD, "incorrect value index 0");
        assert(await AddressList.getValueAt(1) == addressC, "incorrect value index 1");
        assert(await AddressList.getValueAt(2) == nullAddress, "incorrect value index 2");
        assert(await AddressList.getValueAt(3) == nullAddress, "incorrect value index 3");
        await AddressList.remove(addressC, {from: owner});
        assert(await AddressList.getValueAt(0) == addressD, "incorrect value index 0");
        assert(await AddressList.getValueAt(1) == nullAddress, "incorrect value index 1");
        assert(await AddressList.getValueAt(2) == nullAddress, "incorrect value index 2");
        assert(await AddressList.getValueAt(3) == nullAddress, "incorrect value index 3");
        await AddressList.remove(addressD, {from: owner});
        assert(await AddressList.getValueAt(0) == nullAddress, "incorrect value index 0");
        assert(await AddressList.getValueAt(1) == nullAddress, "incorrect value index 1");
        assert(await AddressList.getValueAt(2) == nullAddress, "incorrect value index 2");
        assert(await AddressList.getValueAt(3) == nullAddress, "incorrect value index 3");
        let length = await AddressList.getLength();
        let current = await AddressList.getList();
        let expected = [];
        assert(current.toString() == expected.toString(), "current list does not match expected");
        assert(length == 0, "invalid length: should be zero");
        assert(await AddressList.contains(addressA) == false, "should not contain: " + addressA);
        assert(await AddressList.contains(addressB) == false, "should not contain: " + addressB);
        assert(await AddressList.contains(addressC) == false, "should not contain: " + addressC);
        assert(await AddressList.contains(addressD) == false, "should not contain: " + addressD);
    });

    function random (min, max) {
        return min + Math.floor(Math.random() * (max - min));
    }

});
