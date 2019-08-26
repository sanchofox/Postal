//
//  Logger+Pop3.swift
//  Postal
//
//  Created by Gennaro Stanzione on 26/08/2019.
//  Copyright © 2019 Bit4id. All rights reserved.
//

import Foundation
import libetpan

typealias Pop3Logger = @convention(c) (UnsafeMutablePointer<mailpop3>?, Int32, UnsafePointer<CChar>?, Int, UnsafeMutableRawPointer?) -> Void
