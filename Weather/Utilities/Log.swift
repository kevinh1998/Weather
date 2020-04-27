//
//  Log.swift
//  Delta
//
//  Created by Kevin Huijzendveld on 22/01/2019.
//  Copyright © 2019 Kevin Huijzendveld. All rights reserved.
//

import Foundation

public func DLog(_ object: Any, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
    #if DEBUG
    let className = (fileName as NSString).lastPathComponent
    let thread = Thread.isMainThread ? "MAIN" : "OTHER"
    
    print("[\(thread)] <\(className)#\(lineNumber)> \(functionName) | \(object)")
    #endif
}
