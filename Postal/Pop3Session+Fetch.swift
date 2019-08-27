//
//  Pop3Session+Fetch.swift
//  Postal
//
//  Created by Gennaro Stanzione on 27/08/2019.
//  Copyright © 2019 Bit4id. All rights reserved.
//

import Foundation
import libetpan

extension Pop3Session: Fetcher {

    func fetchLast(_ folder: String, last: UInt, flags: FetchFlag, extraHeaders: Set<String>, handler: @escaping (FetchResult) -> Void) throws {
        
    }
    
    func fetchMessages(_ folder: String, uids: IndexSet, flags: FetchFlag, extraHeaders: Set<String>, onMessage: @escaping (FetchResult) -> Void) throws {
        
        try connect(timeout: 10)
        try login()
        
        var msgList: UnsafeMutablePointer<carray>?

        try mailpop3_list(pop3, &msgList).toPop3Error?.check()
        
        print("message count: \(carray_count(msgList))")
        
                
    }
    
    func fetchParts(_ folder: String, uid: UInt, partId: String, handler: @escaping (MailData) -> Void) throws {
        
    }
    
    
}
