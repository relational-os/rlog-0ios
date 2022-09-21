//
//  EthereumManager.swift
//  Log (iOS)
//
//  Created by CJ Pais on 7/14/22.
//

import Foundation
import GenericJSON
import web3

struct MessageStruct: Codable {
    var from: String
    var to: String
    var value: UInt
    var gas: UInt
    var timestamp: UInt
    var data: String
}

struct DomainStruct: Codable {
    var name: String
    var version: String
    var chainId: UInt
    var verifyingContract: String
}


func getSignedMessage(message: String) -> (TypedData?, String?) {
    let encoder = ABIFunctionEncoder("create")
    try? encoder.encode(message)
    let encoded = try! encoder.encoded()
    let encodedHexData = (String(hexFromBytes: encoded.web3.bytes))
    let account = keychain.account!
    
    do {
        let msg = MessageStruct(
            from: account.address.toChecksumAddress(),
            to: mumbaiLogAddr.toChecksumAddress(),
            value: 0,
            gas: 1000000,
            timestamp: UInt(Date().timeIntervalSince1970),
            data: encodedHexData)
        
        let jsonMessage: JSON = try! JSON(encodable: msg)
        let typedData = getTypedData(message: jsonMessage)
        print("message", typedData)

        let signedMessage = try account.signMessage(message: typedData)
        print(signedMessage)
        
        return (typedData, signedMessage)
        
        // TODO take that signed message and send to forwarder.
    } catch  {
        print("ERROR: \(error)")
    }
    
    return (nil, nil)
}

func getDomain() -> JSON {
    let domain = DomainStruct(
        name: "PASSPORT",
        version: "0.0.1",
        chainId: 80001,
        verifyingContract: UserDefaults.standard.string(forKey: "contractAddr")!
    )
    let jsonDomain: JSON = try! JSON(encodable: domain)
    return jsonDomain
}

func getTypedData(message: JSON) -> TypedData {
    return TypedData(types:
                        ["ForwardRequest":
                            [
                                TypedVariable(name: "from", type: "address"),
                                TypedVariable(name: "to", type: "address"),
                                TypedVariable(name: "value", type: "uint256"),
                                TypedVariable(name: "gas", type: "uint256"),
                                TypedVariable(name: "timestamp", type: "uint256"),
                                TypedVariable(name: "data", type: "bytes"),
                            ]
                        ,
                         "EIP712Domain": [
                            TypedVariable(name: "name", type: "string"),
                            TypedVariable(name: "version", type: "string"),
                            TypedVariable(name: "chainId", type: "uint256"),
                            TypedVariable(name: "verifyingContract", type: "address"),
                         ]
                        ],
                    primaryType: "ForwardRequest",
                    domain: getDomain(),
                    message: message
    )
}
