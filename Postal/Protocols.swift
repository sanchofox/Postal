//
//  Protocols.swift
//  Postal
//
//  Created by Gennaro Stanzione on 26/08/2019.
//  Copyright © 2019 Bit4id. All rights reserved.
//

protocol Configuration {
    /// The hostname of the POP3 server
    var hostname: String { get }
    /// The port of the POP3 server
    var port: UInt16 { get }
    /// The login name
    var login: String { get }
    ///
    // auth type??
    /// The connection type (secured or not)
    var connectionType: ConnectionType { get }
    /// Check if the certificate is enabled
    var checkCertificateEnabled: Bool { get }
    /// The batch size of heavy requests
    var batchSize: Int { get }
}

protocol Session {
    var configuration: Configuration { get }
    var session: Any { get }
    var logger: Logger? { get }
    
    func connect(timeout: TimeInterval) throws
    func login() throws
    func configure() throws
}
