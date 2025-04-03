//
//  main.swift
//  XPCService
//
//  Created by FelixWither on 2025/4/4.
//

import Foundation

// NOTE: Expression are allowed on top level since the name of file is "main"
let xpcService = XPCService()
xpcService.start()

dispatchMain()
