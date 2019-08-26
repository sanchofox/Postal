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
//    case connection
    case login(description: String)
//    case parse
    case certificate
//    case nonExistantFolder
}

extension Pop3Error: PostalErrorType {
    var asPostalError: PostalError {
        switch self {
        case .undefined: return .undefined
//        case .connection: return .connection
        case .login(let description): return .login(description: description)
//        case .parse: return .parse
        case .certificate: return .certificate
//        case .nonExistantFolder: return .nonExistantFolder
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
        //TODO: Inserire errori POp3
        switch self {
        case MAILIMAP_NO_ERROR, MAILIMAP_NO_ERROR_AUTHENTICATED, MAILIMAP_NO_ERROR_NON_AUTHENTICATED: return nil
        case MAILIMAP_ERROR_STREAM: return .undefined //.connection
        case MAILIMAP_ERROR_PARSE: return .undefined //.parse
        default: return .undefined
        }
    }
}

extension Int32 {
    var toPop3Error: Pop3Error? {
        return Int(self).toPop3Error
    }
}
