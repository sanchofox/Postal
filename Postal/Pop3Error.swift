//
//  Pop3Error.swift
//  Postal
//
//  Created by Gennaro Stanzione on 26/08/2019.
//  Copyright © 2019 Bit4id. All rights reserved.
//

import Foundation
import libetpan

enum Pop3Error {
    case undefined
    case connection
    case login(description: String)
    case certificate
    case unsupported
}

extension Pop3Error: PostalErrorType {
    var asPostalError: PostalError {
        switch self {
        case .undefined: return .undefined
        case .connection: return .connection
        case .login(let description): return .login(description: description)
//        case .parse: return .parse
        case .certificate: return .certificate
//        case .nonExistantFolder: return .nonExistantFolder
        case .unsupported: return .unsupported
        }
    }
}

extension Pop3Error {
    func enrich(_ f: () -> Pop3Error) -> Pop3Error {
        if case .undefined = self {
            return f()
        }
        return self
    }
}

extension Int {
    
    var toPop3Error: Pop3Error? {
        switch self {
        case MAILPOP3_NO_ERROR:
            return nil
        case MAILPOP3_ERROR_STREAM:
            return .connection
        case MAILPOP3_ERROR_BAD_USER, MAILPOP3_ERROR_BAD_PASSWORD:
            return .login(description: "")

            
        case MAILPOP3_ERROR_SSL:
            return .undefined
        case MAILPOP3_ERROR_DENIED:
            return .undefined
        case MAILPOP3_ERROR_MEMORY:
            return .undefined
        case MAILPOP3_ERROR_BAD_STATE:
            return .undefined
        case MAILPOP3_ERROR_CANT_LIST:
            return .undefined
        case MAILPOP3_ERROR_QUIT_FAILED:
            return .undefined
        case MAILPOP3_ERROR_UNAUTHORIZED:
            return .undefined
        case MAILPOP3_ERROR_NO_SUCH_MESSAGE:
            return .undefined
        case MAILPOP3_ERROR_APOP_NOT_SUPPORTED:
            return .undefined
        case MAILPOP3_ERROR_CAPA_NOT_SUPPORTED:
            return .undefined
        case MAILPOP3_ERROR_CONNECTION_REFUSED:
            return .undefined
        case MAILPOP3_ERROR_STLS_NOT_SUPPORTED:
            return .undefined
        default:
            return .undefined
        }

    }
}

extension Int32 {
    var toPop3Error: Pop3Error? {
        return Int(self).toPop3Error
    }
}
