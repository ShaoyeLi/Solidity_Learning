
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract VDR {
    struct DIDDoc {
        string did;
        address pk;
        string methodType;
        string[] context;
    }
    struct validDID {
        bool exist;
        address pk;
    }
    struct validIssuer {
        bool exist;
        string methodType;
        string pk;
        string[] revocationList;
    }
    string[] context = [
        "https://www.w3.org/ns/did/v1",
        "https://identity.foundation/EcdsaSecp256k1RecoverySignature2020/lds-ecdsa-secp256k1-recovery2020-0.0.jsonld"
    ];
    string methodType = "Ed25519VerificationKey2020";
    mapping(string => validDID) public DIDs;
    mapping(string => validIssuer) public issuerData;

    function registerDID(string memory did) public {
        require(!DIDs[did].exist, "The DID is already created!");
        validDID memory newDID = validDID(true, msg.sender);
        DIDs[did] = newDID;
    }

    function getDID(string calldata did) public view returns (DIDDoc memory) {
        require(DIDs[did].exist, "There is no such a DID!");
        DIDDoc memory result = DIDDoc(did, DIDs[did].pk, methodType, context);
        return result;
    }

    function registerIssuer(
        string calldata did,
        string calldata _methodType,
        string calldata pk
    ) public {
        require(DIDs[did].exist, "There is no such a DID!");
        require(msg.sender == DIDs[did].pk, "You have no right!");
        validIssuer memory newIssuer = validIssuer(
            true,
            _methodType,
            pk,
            new string[](0)
        );
        issuerData[did] = newIssuer;
    }

    function getIssuer(
        string calldata did
    ) public view returns (validIssuer memory) {
        require(issuerData[did].exist, "There is no such a issuer!");
        return issuerData[did];
    }

    function removeIssuer(string calldata did) public {
        require(issuerData[did].exist, "There is no such a issuer!");
        require(msg.sender == DIDs[did].pk, "You have no right!");
        delete issuerData[did];
    }

    function checkRevocation(
        string calldata issuer_did,
        string calldata cred_id
    ) public view returns (bool) {
        require(issuerData[issuer_did].exist, "There is no such a issuer!");
        for (uint i; i < issuerData[issuer_did].revocationList.length; i++) {
            if (
                keccak256(
                    abi.encode(issuerData[issuer_did].revocationList[i])
                ) == keccak256(abi.encode(cred_id))
            ) return true;
        }
        return false;
    }

    function revoke(string calldata did, string calldata cred_id) public {
        require(issuerData[did].exist, "There is no such a issuer!");
        require(msg.sender == DIDs[did].pk, "You have no right!");
        issuerData[did].revocationList.push(cred_id);
    }
}
