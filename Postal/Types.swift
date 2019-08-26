//
//  Types.swift
//  Postal
//
//  Created by Gennaro Stanzione on 26/08/2019.
//  Copyright © 2019 Bit4id. All rights reserved.
//

/// The connection type on the server
public enum ConnectionType {
    /// Communication not encryptet
    case clear
    /// Encrypted communication
    case tls
    /// Take an existing insecure connection and upgrade it to a secure one.
    case startTLS
}

public typealias Progress = @convention(c) (Int, Int, UnsafeMutableRawPointer?) -> Void

public typealias ProgressHandler = (_ current: Int, _ maximum: Int) -> ()
