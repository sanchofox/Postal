//
//  Pop3Session.swift
//  Postal-iOS
//
//  Created by Gennaro Stanzione on 26/08/2019.
//  Copyright © 2019 Bit4id. All rights reserved.
//

import Swift
import libetpan

final class Pop3Session: Session {
    var session: Any
    var configuration: Configuration
    
    var logger: Logger? {
        didSet {
            if logger != nil {
                mailpop3_set_logger(pop3, _logger, Unmanaged.passRetained(self).toOpaque())
            } else {
                mailpop3_set_logger(pop3, nil, nil)
            }
        }
    }
    
    private var pop3: UnsafeMutablePointer<mailpop3> {
        get {
            return session as! UnsafeMutablePointer<mailpop3>
        }
    }
    
    private var pop3Configuration: Pop3Configuration {
        get {
            return configuration as! Pop3Configuration
        }
    }
    
    private init(configuration: Configuration) {
        self.session = mailpop3_new(0, nil) as Any
        self.configuration = configuration
        
        let _bodyProgress: Progress = { _,_,_  in }
        mailpop3_set_progress_callback(pop3, _bodyProgress, nil)
    }
    
    convenience init(pop3configuration: Pop3Configuration) {
        self.init(configuration: pop3configuration)
    }
    
    deinit {
        if let stream = pop3.pointee.pop3_stream {
            mailstream_close(stream)
            pop3.pointee.pop3_stream = nil
        }
        mailpop3_free(pop3)
    }

    func connect(timeout: TimeInterval) throws {
        mailpop3_set_timeout(pop3, Int(timeout))

        switch configuration.connectionType {
        case .clear:
            try mailpop3_socket_connect(pop3, configuration.hostname, configuration.port).toPop3Error?.check()
            
        case .tls:
            try mailpop3_ssl_connect(pop3, configuration.hostname, configuration.port).toPop3Error?.check()
            
            try checkCertificateIfNeeded()
            
        case .startTLS:
            try mailpop3_socket_connect(pop3, configuration.hostname, configuration.port).toPop3Error?.check()
            
            try mailpop3_socket_starttls(pop3).toPop3Error?.check()
            
            try checkCertificateIfNeeded()
            
        }
        
        let low = mailstream_get_low(pop3.pointee.pop3_stream)
        
        let identifier = "\(configuration.login)@\(configuration.hostname):\(configuration.port)"
        mailstream_low_set_identifier(low, identifier.unreleasedUTF8CString)
    }
    
    func login() throws {
        let result: Int32 = mailpop3_login(pop3, configuration.login, pop3Configuration.password)
        
        try result.toPop3Error?.enrich { return .login(description: String(cString: pop3.pointee.pop3_response)) }.check()
    }
    
    func configure() throws {
        // Nothing to do.
    }
    
    // MARK: - Utils
    
    fileprivate let _logger: Pop3Logger = { (_: UnsafeMutablePointer<mailpop3>?, logType: Int32, buffer: UnsafePointer<CChar>?, size: Int, context: UnsafeMutableRawPointer?) in
        guard
            size > 0,
            let context = context,
            let logType = ConnectionLogType(rawType: logType),
            let buffer = buffer
            else { return }
        
        let session = Unmanaged<Pop3Session>.fromOpaque(context).takeUnretainedValue()
        
        let data = Data(bytesNoCopy: UnsafeMutableRawPointer(mutating: buffer), count: size, deallocator: .none)
        
        if let str = String(data: data, encoding: .utf8), !str.isEmpty {
            session.logger?("\(logType): \(str)")
        } else {
            session.logger?("\(logType)")
        }
    }
    
    fileprivate func checkCertificateIfNeeded() throws{
        guard configuration.checkCertificateEnabled else { return }
        guard checkCertificate(pop3.pointee.pop3_stream, hostname: configuration.hostname) else {
            throw Pop3Error.certificate.asPostalError
        }
    }

}
