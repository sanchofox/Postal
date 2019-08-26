//
//  The MIT License (MIT)
//
//  Copyright (c) 2017 Snips
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

/// The representation of the credential of the user
public enum PasswordType {
    /// Classic password
    case plain(String)
    /// OAuth2 token
    case accessToken(String)
}

/// The configuration of the connection
public struct ImapConfiguration: Configuration {
    /// The hostname of the IMAP server
    public private(set) var hostname: String
    /// The port of the IMAP server
    public private(set) var port: UInt16
    /// The login name
    public private(set) var login: String
    /// The password or the token of the connection
    public let password: PasswordType
    /// The connection type (secured or not)
    public private(set) var connectionType: ConnectionType
    /// Check if the certificate is enabled
    public private(set) var checkCertificateEnabled: Bool
    /// The batch size of heavy requests
    public private(set) var batchSize: Int
    /// The spam folder name
    public let spamFolderName: String
    
    /// Initialize a new configuration
    public init(hostname: String,
         port: UInt16,
         login: String,
         password: PasswordType,
         connectionType: ConnectionType,
         checkCertificateEnabled: Bool,
         batchSize: Int = Int.max,
         spamFolderName: String = "Junk") {
        self.hostname = hostname
        self.port = port
        self.login = login
        self.password = password
        self.connectionType = connectionType
        self.checkCertificateEnabled = checkCertificateEnabled
        self.batchSize = batchSize
        self.spamFolderName = spamFolderName
    }
}

extension ImapConfiguration {
    /// Retrieve pre-configured configuration for Gmail.
    ///
    /// - parameters:
    ///     - login: The login of the user.
    ///     - password: The credential of the connection.
    public static func gmail(login: String, password: PasswordType) -> ImapConfiguration {
        return ImapConfiguration(
            hostname: "imap.gmail.com",
            port: 993,
            login: login,
            password: password,
            connectionType: .tls,
            checkCertificateEnabled: true,
            batchSize: 1000,
            spamFolderName: "$Phishing")
    }
}

extension ImapConfiguration {
    /// Retrieve pre-configured configuration for Yahoo.
    ///
    /// - parameters:
    ///     - login: The login of the user.
    ///     - password: The credential of the connection.
    public static func yahoo(login: String, password: PasswordType) -> ImapConfiguration {
        return ImapConfiguration(
            hostname: "imap.mail.yahoo.com",
            port: 993,
            login: login,
            password: password,
            connectionType: .tls,
            checkCertificateEnabled: true,
            batchSize: 1000,
            spamFolderName: "$Junk")
    }
}

extension ImapConfiguration {
    /// Retrieve pre-configured configuration for iCloud.
    ///
    /// - parameters:
    ///     - login: The login of the user.
    ///     - password: The credential of the connection.
    public static func icloud(login: String, password: String) -> ImapConfiguration {
        return ImapConfiguration(
            hostname: "imap.mail.me.com",
            port: 993,
            login: login,
            password: .plain(password),
            connectionType: .tls,
            checkCertificateEnabled: true,
            batchSize: 500,
            spamFolderName: "Junk")
    }
}

extension ImapConfiguration {
    /// Retrieve pre-configured configuration for Outlook.
    ///
    /// - parameters:
    ///     - login: The login of the user.
    ///     - password: The credential of the connection.
    public static func outlook(login: String, password: String) -> ImapConfiguration {
        return ImapConfiguration(
            hostname: "imap-mail.outlook.com",
            port: 993,
            login: login,
            password: .plain(password),
            connectionType: .tls,
            checkCertificateEnabled: true,
            batchSize: 1000,
            spamFolderName: "Junk")
    }
}

extension ImapConfiguration {
    /// Retrieve pre-configured configuration for Aol.
    ///
    /// - parameters:
    ///     - login: The login of the user.
    ///     - password: The credential of the connection.
    public static func aol(login: String, password: String) -> ImapConfiguration {
        return ImapConfiguration(
            hostname: "imap.aol.com",
            port: 993,
            login: login,
            password: .plain(password),
            connectionType: .tls,
            checkCertificateEnabled: true,
            batchSize: 1000,
            spamFolderName: "Junk")
    }
}

extension ImapConfiguration: CustomStringConvertible {
    public var description: String {
        return "\(login)@\(hostname)"
    }
}
