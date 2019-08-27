//
//  Protocols.swift
//  Postal
//
//  Created by Gennaro Stanzione on 26/08/2019.
//  Copyright © 2019 Bit4id. All rights reserved.
//

import libetpan

public protocol Configuration {
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

public protocol Session {
    var configuration: Configuration { get }
    var session: Any { get }
    var logger: Logger? { get set }
    
    func connect(timeout: TimeInterval) throws
    func login() throws
    func configure() throws
}

extension Session {
    func checkCertificateIfNeeded(with stream: UnsafeMutablePointer<mailstream>) -> Bool {
        guard configuration.checkCertificateEnabled else { return true }
        guard checkCertificate(stream, hostname: configuration.hostname) else {
            return false
        }
        return true
    }
}

protocol FolderHandler {
    
    /// Retrieve list folders on the server
    func listFolders() throws -> [Folder]
    
    /// Delete a folder
    ///
    /// - Parameters:
    ///   - folderName: the folder name.
    func delete(folderNamed folderName: String) throws
    
    /// Create a folder
    ///
    /// - Parameters:
    ///   - folderName: the folder name.
    func create(folderNamed folderName: String) throws
    
    /// Rename a folder
    ///
    /// - Parameters:
    ///   - folderName: the folder name that will be rename.
    ///   - to: the new folder name.
    func rename(folderNamed fromFolderName: String, to toFolderName: String) throws
    
    /// Subscribe a folder
    ///
    /// - Parameters:
    ///   - folderName: the folder name to be subcribed.
    func subscribe(folderNamed folderName: String) throws
    
    /// Unsubscribe a folder
    ///
    /// - Parameters:
    ///   - folderName: the folder name to unsubscribe.
    func unsubscribe(folderNamed folderName: String) throws
    
    /// Expunge a folder
    ///
    /// - Parameters:
    ///   - folderName: the folder name to expunge
    func expunge(folderNamed folderName: String) throws
    
    /// Move messages from a given folder to another folder.
    ///
    /// - parameters:
    ///     - fromFolder: The folder where the messages are.
    ///     - toFolder: The folder where messages will be move.
    ///     - uids: The message uids to be moved.0
    ///         with the mapping between uids inside the previous folder and the new folder.
    func moveMessages(fromFolder: String, toFolder: String, uids: IndexSet) throws -> [Int: Int]
}

protocol Finder {
    /// Search emails for a given filter. Retrieve an indexset of uids.
    ///
    /// - parameters:
    ///     - folder: The folder where the search will be performed.
    ///     - filter: The filter
    func search(_ folder: String, filter: SearchKind) throws -> IndexSet
    
    /// Search emails for a given filter. Retrieve an indexset of uids.
    ///
    /// - parameters:
    ///     - folder: The folder where the search will be performed.
    ///     - filter: The filter
    func search(_ folder: String, filter: SearchFilter) throws -> IndexSet
}

protocol Fetcher {
    /// Fetch a given number of last emails in a given folder
    ///
    /// - parameters:
    ///     - folder: The folder where the search will be performed.
    ///     - last: The number of last mail that should be fetch.
    ///     - flags: The kind of information you want to retrieve.
    ///     - extraHeaders: A set of extra headers for the request
    ///     - handler: The completion handler called when a new message is received.
    func fetchLast(_ folder: String, last: UInt, flags: FetchFlag, extraHeaders: Set<String>, handler: @escaping (FetchResult) -> Void) throws
    
    /// Fetch emails by uids in a given folder
    ///
    /// - parameters:
    ///     - folder: The folder where the search will be performed.
    ///     - uids: The uids of the emails that you want to retrieve.
    ///     - flags: The kind of information you want to retrieve.
    ///     - extraHeaders: A set of extra headers for the request
    ///     - onMessage: The completion handler called when a new message is received.
    func fetchMessages(_ folder: String, uids: IndexSet, flags: FetchFlag, extraHeaders: Set<String>, onMessage: @escaping (FetchResult) -> Void) throws
    
    
    /// Fetch attachments of an email for a given partID in a given folder
    ///
    /// - parameters:
    ///     - folder: The folder where the search will be performed.
    ///     - uid: The uid of the email where there is the attachment
    ///     - partId: The partId you want to fetch
    ///     - handler: The completion handler called when an attachment was found.
    func fetchParts(_ folder: String, uid: UInt, partId: String, handler: @escaping (MailData) -> Void) throws
}

extension Fetcher {
    func fetchLast(_ folder: String, last: UInt, flags: FetchFlag, handler: @escaping (FetchResult) -> Void) throws {
        try fetchLast(folder, last: last, flags: flags, extraHeaders: [], handler: handler)
    }
    
    func fetchMessages(_ folder: String, uids: IndexSet, flags: FetchFlag, onMessage: @escaping (FetchResult) -> Void) throws {
        try fetchMessages(folder, uids: uids, flags: flags, extraHeaders: [], onMessage: onMessage)
    }
}






