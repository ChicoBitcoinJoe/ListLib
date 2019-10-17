// Artifacts

const AddressList = artifacts.require("AddressList");
const AddressListLib = artifacts.require("AddressListLib");
const AddressListFactory = artifacts.require("AddressListFactory");

module.exports = async function(deployer) {
    deployer.deploy(AddressListLib, {overwrite: false});
    deployer.link(AddressListLib, [AddressList]);
    await deployer.deploy(AddressList);
    let Blueprint = await AddressList.deployed();
    await Blueprint.initialize('0x0000000000000000000000000000000000000000');
    deployer.deploy(AddressListFactory, AddressList.address);
};
