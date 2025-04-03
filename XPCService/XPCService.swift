//
//  XPCService.swift
//  XPCService
//
//  Created by FelixWither on 2025/4/4.
//

import Foundation

class XPCService: NSObject, NSXPCListenerDelegate, XPCExposedProtocols{
	
	// The XPC Service must maintain an XPC listener to manage incoming XPC connections
	let listener: NSXPCListener
	
	// Maintain a reference to the XPC connection for communicating with the client application
	var connection : NSXPCConnection?
	
	override init(){
		listener = NSXPCListener(machServiceName: xpcServiceLabel)
		super.init()
		listener.delegate = self
	}
	
	func start() {
		listener.resume()
	}
	
	func stop() {
		listener.suspend()
	}
	
	// Here comes the main APP
	var clientAPP: ClientExposedProtocols {
		connection!.remoteObjectProxyWithErrorHandler{ err in
			print(err)
		} as! ClientExposedProtocols
	}
	
	// MARK: - NSXPCListenerDelegate
	
	func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
		// Export here have a meaning close to "Expose"
		// Expose this delegate
		newConnection.exportedObject = self
		
		// The remote one (main APP) have these protocols
		newConnection.remoteObjectInterface = NSXPCInterface(with: ClientExposedProtocols.self)
		
		// These protocols are exposed by the delegate
		newConnection.exportedInterface = NSXPCInterface(with: XPCExposedProtocols.self)
		
		// Start the connection
		newConnection.resume()
		
		// Return ture here to accept connection, return false will invalidate.
		return true
	}
	
	// MARK: - Implement XPC Protocol here
	func doSomething() {
		
	}
}
