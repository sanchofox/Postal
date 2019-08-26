//
//  Pop3Session.swift
//  Postal-iOS
//
//  Created by Gennaro Stanzione on 26/08/2019.
//  Copyright © 2019 Bit4id. All rights reserved.
//

import Swift
import libetpan

final class Pop3Session {
    public func fake() {
        /*
        mailpop3
        mailpop3_capa
        mailpop3_free(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>)
        mailpop3_new(<#T##pop3_progr_rate: Int##Int#>, <#T##pop3_progr_fun: ((Int, Int) -> Void)!##((Int, Int) -> Void)!##(Int, Int) -> Void#>)
        mailpop3_noop(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>)
        mailpop3_quit(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>)
        mailpop3_rset(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>)
        mailpop3_stls(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>)
        mailpop3_capa(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>, <#T##result: UnsafeMutablePointer<UnsafeMutablePointer<clist>?>!##UnsafeMutablePointer<UnsafeMutablePointer<clist>?>!#>)
        mailpop3_dele(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>, <#T##indx: UInt32##UInt32#>)
        mailpop3_list(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>, <#T##result: UnsafeMutablePointer<UnsafeMutablePointer<carray>?>!##UnsafeMutablePointer<UnsafeMutablePointer<carray>?>!#>)
        mailpop3_msg_info
        mailpop3_pass(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>, <#T##password: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>)
        mailpop3_stat(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>, <#T##result: UnsafeMutablePointer<UnsafeMutablePointer<mailpop3_stat_response>?>!##UnsafeMutablePointer<UnsafeMutablePointer<mailpop3_stat_response>?>!#>)
        mailpop3_user(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>, <#T##user: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>)
        mailpop3_apop(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>, <#T##user: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>, <#T##password: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>)
        mailpop3_login(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>, <#T##user: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>, <#T##password: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>)
        mailpop3_retr(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>, <#T##indx: UInt32##UInt32#>, <#T##result: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>!##UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>!#>, <#T##result_len: UnsafeMutablePointer<Int>!##UnsafeMutablePointer<Int>!#>)
        mailpop3_top(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>, <#T##indx: UInt32##UInt32#>, <#T##count: UInt32##UInt32#>, <#T##result: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>!##UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>!#>, <#T##result_len: UnsafeMutablePointer<Int>!##UnsafeMutablePointer<Int>!#>)
        mailpop3_connect(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>, <#T##s: UnsafeMutablePointer<mailstream>!##UnsafeMutablePointer<mailstream>!#>)
        mailpop3_top_free(<#T##str: UnsafeMutablePointer<Int8>!##UnsafeMutablePointer<Int8>!#>)
        mailpop3_header(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>, <#T##indx: UInt32##UInt32#>, <#T##result: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>!##UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>!#>, <#T##result_len: UnsafeMutablePointer<Int>!##UnsafeMutablePointer<Int>!#>)
        mailpop3_retr_free(<#T##str: UnsafeMutablePointer<Int8>!##UnsafeMutablePointer<Int8>!#>)
        mailpop3_stat_response
        mailpop3_get_timeout(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>)
        mailpop3_header_free(<#T##str: UnsafeMutablePointer<Int8>!##UnsafeMutablePointer<Int8>!#>)
        mailpop3_auth(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>, <#T##auth_type: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>, <#T##server_fqdn: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>, <#T##local_ip_port: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>, <#T##remote_ip_port: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>, <#T##login: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>, <#T##auth_name: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>, <#T##password: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>, <#T##realm: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>)
        mailpop3_login_apop(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>, <#T##user: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>, <#T##password: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>)
        mailpop3_set_logger(<#T##session: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>, <#T##logger: ((UnsafeMutablePointer<mailpop3>?, Int32, UnsafePointer<Int8>?, Int, UnsafeMutableRawPointer?) -> Void)!##((UnsafeMutablePointer<mailpop3>?, Int32, UnsafePointer<Int8>?, Int, UnsafeMutableRawPointer?) -> Void)!##(UnsafeMutablePointer<mailpop3>?, Int32, UnsafePointer<Int8>?, Int, UnsafeMutableRawPointer?) -> Void#>, <#T##logger_context: UnsafeMutableRawPointer!##UnsafeMutableRawPointer!#>)
        mailpop3_set_timeout(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>, <#T##timeout: time_t##time_t#>)
        mailpop3_ssl_connect(<#T##f: UnsafeMutablePointer<mailpop3>!##UnsafeMutablePointer<mailpop3>!#>, <#T##server: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>, <#T##port: UInt16##UInt16#>)
        mailpop3_capa_resp_free(<#T##capa_list: UnsafeMutablePointer<clist>!##UnsafeMutablePointer<clist>!#>)
        */
    }
}
