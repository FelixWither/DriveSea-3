//
//  XPC.swift
//  DriveSea 3
//
//  Created by FelixWither on 2025/1/16.
//

/*
  Note by Author :
 
  Created by Jeff Spooner

  Please note, we're using Grand Central Dispatch for our run loop and not RunLoop
  because we have previously set the Info.plist value for RunLoopType to be
  dispatch_main, with the other option being NSRunLoop. The value specified in the
  Info.plist must match the method called at the end of the XPC service's main file

*/

import Foundation

// NOTE: Expression are allowed on top level since the name of file is "main"
let xpcService = XPCService()
xpcService.start()

dispatchMain()
