//
//  XPCServiceProtocol.swift
//  XPCService
//
//  Created by FelixWither on 2025/4/4.
//

import Foundation

let xpcServiceLabel = "com.felixwither.DriveSea-3"

// A protocol declaring the exposed methods of the XPC service
@objc protocol XPCExposedProtocols{
	
}

// A protocol declaring the exposed methods of the client application
@objc protocol ClientExposedProtocols {
	func doSomething()
}
