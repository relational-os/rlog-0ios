//
//  Types.swift
//  Log (iOS)
//
//  Created by CJ Pais on 7/14/22.
//

import Foundation
import web3

struct JSONMessage: Encodable {
    let contractAddr: String
    let data: TypedData
    let signature: String
}
