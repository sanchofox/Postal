//
//  Pop3Configuration.swift
//  Postal-iOS
//
//  Created by Gennaro Stanzione on 26/08/2019.
//  Copyright © 2019 Bit4id. All rights reserved.
//

/// The configuration of the connection
public struct Pop3Configuration: Configuration {
    
    public private(set) var hostname: String
    
    public private(set) var port: UInt16
    
    public private(set) var login: String
    
    public private(set) var connectionType: ConnectionType
    
    public private(set) var checkCertificateEnabled: Bool
    
    public private(set) var batchSize: Int
    
    public let password: String
    
    init(hostname: String, port: UInt16, login: String, password: String, connectionType: ConnectionType, checkCertificateEnabled: Bool, batchSize: Int) {
        self.hostname = hostname
        self.port = port
        self.login = login
        self.password = password
        self.connectionType = connectionType
        self.checkCertificateEnabled = checkCertificateEnabled
        self.batchSize = batchSize
    }

}

extension Pop3Configuration {
    /// Retrieve pre-configured configuration for Gmail.
    ///
    /// - parameters:
    ///     - login: The login of the user.
    ///     - password: The credential of the connection.
    public static func gmail(login: String, password: String) -> Pop3Configuration {
        return Pop3Configuration(hostname: "pop.gmail.com", port: 995, login: login,  password: password, connectionType: .startTLS, checkCertificateEnabled: true, batchSize: 1000)
    }
}

extension Pop3Configuration: CustomStringConvertible {
    public var description: String {
        return "\(login)@\(hostname)"
    }
}
