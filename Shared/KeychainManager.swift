//
//  KeychainManager.swift
//  Log (iOS)
//
//  Created by CJ Pais on 7/14/22.
//

import Foundation
import Security
import web3

// TODO: really this should store the public key in user preferences, then use that
// as the way to query into the keychain

enum KeychainError: Error {
    case noKeyFound
}

public class KeychainManager: EthereumKeyStorageProtocol {
    
    private let PASSWORD = "password"
    private let keychain = KeychainSwift()
    public var account: EthereumAccount? = nil
    
    public init() {
        // TODO change to guard let
        let key = keychain.getData("private key")
        
        if keychain.set("test", forKey: "test") {
            print("success!")
        } else {
            print(SecCopyErrorMessageString(keychain.lastResultCode, nil))
        }
        print("get test", keychain.get("test"))
        
        if (key == nil) {
            print("adding key")
            account = try? EthereumAccount.create(keyStorage: self, keystorePassword: PASSWORD)
            print(account?.address)
        } else {
            account = try? EthereumAccount(keyStorage: self, keystorePassword: PASSWORD)
        }
        
    }
    
    public func storePrivateKey(key: Data) throws {
        print("called store private key", key)
        keychain.set(key, forKey: "private key")
    }

    public func loadPrivateKey() throws -> Data {
        print("trying to load private key")
        let key = keychain.getData("private key")
        if (key == nil) {
            print("threw error")
            throw KeychainError.noKeyFound
        }
        return key!
    }
}

let keychain = KeychainManager()

