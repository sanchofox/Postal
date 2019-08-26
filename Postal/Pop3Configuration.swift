//
//  Pop3Configuration.swift
//  Postal-iOS
//
//  Created by Gennaro Stanzione on 26/08/2019.
//  Copyright © 2019 Bit4id. All rights reserved.
//

/// The configuration of the connection
public struct Pop3Configuration {
    /// The hostname of the POP3 server
    public let hostname: String
    /// The port of the POP3 server
    public let port: UInt16
    /// The login name
    public let login: String
    /// The password or the token of the connection
    public let password: String
    
}
