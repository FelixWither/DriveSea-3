//
//  NSError+POSIX.swift
//  DriveSea 3
//
//  Created by FelixWither on 2026/4/7.
//

import Foundation

extension NSError {
	convenience init(posixErrorCode err: Int32) {
		self.init(domain: NSPOSIXErrorDomain, code: Int(err), userInfo: [NSLocalizedDescriptionKey: String(cString: strerror(err))])
	}
}
