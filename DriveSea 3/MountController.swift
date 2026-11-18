//
//  MountController.swift
//  DriveSea 3
//
//  Created by FelixWither on 2026/11/17.
//

import Foundation
import AppKit

final class MountController {
	static let shared = MountController()      // Singleton
	private var volume: GMUserFileSystem?
	private var fs: SeafFS?
	
	private init(){
		NotificationCenter.default.addObserver(forName: NSApplication.willTerminateNotification,
											   object: nil,
											   queue: .main,
											   using: {_ in MountController.shared.unmount()})
		
	}
	
	func unmount(){
		volume?.unmount()
	}

	func mount(at path: String) {
		guard volume == nil else {
			NSLog("[DriveSea] already mounted, skip")
			return
		}
		let fs = SeafFS()                       // Minimun implementation
		let vol = GMUserFileSystem(delegate: fs, isThreadSafe: true)
		// ObjC: -mountAtPath:withOptions:shouldForeground:detachNewThread:
		vol.mount(atPath: path,
				  withOptions: ["volname=DriveSea", "local", "auto_xattr", "debug"],
				  shouldForeground: true,
				  detachNewThread: true)
		self.volume = vol
		self.fs = fs
		
		// Unmount is asynchronous: pending FUSE requests are still dispatched to
		// the delegate while the loop is winding down, so release lazily here.
		
		NotificationCenter.default.addObserver(forName: Notification.Name(kGMUserFileSystemDidUnmount),
											   object: self.volume,
											   queue: .main) {_ in
													self.volume = nil
													self.fs = nil
													NSLog("[DriveSea] unmount finished, references released")
											}
	}
}
