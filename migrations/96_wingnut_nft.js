var OblivionBasicNft = artifacts.require("OblivionBasicNft");

module.exports = async function (deployer) {
    await deployer.deploy(OblivionBasicNft, "Testnet 1", "TEST1");
    
    const nft1 = await OblivionBasicNft.deployed();    
    await nft1.setTokenURI("ipfs://QmerCbRgMJMMyzeQEcbpJoajsrfMUv5fWLFkkFD6zmvVRK/");
    await nft1.whitelistAdmin("0x964805Bb614285b451dca872e6245F86F833AB24", true);

    console.log("NFT1: " + nft1.address);
};
