//
//  DriveSea_3App.swift
//  DriveSea 3
//
//  Created by FelixWither on 2024/12/29.
//

import SwiftUI

@main
struct DriveSea_3App: App {
	let persistenceController = PersistenceController.shared
	@State private var window: NSWindow?
	
	var body: some Scene {
		WindowGroup {
			LoginView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
				.onAppear {
					// Get the window and set its initial size and constraints
					if let window = NSApp.keyWindow {
						window.setContentSize(NSSize(width: 500, height: 250)) // Set the initial size
//						window.minSize = NSSize(width: 500, height: 200)
						if let screen = window.screen {
							let screenFrame = screen.frame
							let windowWidth = window.frame.width
							let windowHeight = window.frame.height

							// Calculate the new window origin to center it
							let newOriginX = (screenFrame.width - windowWidth) / 2
							let newOriginY = (screenFrame.height - windowHeight) / 2

							// Set the window's position at the center of the screen
//							window.setFrameOrigin(NSPoint(x: newOriginX, y: newOriginY))
							window.setFrame(NSRect(x: newOriginX, y: newOriginY, width: 500, height: 250), display: true)
						}
//						self.window = window // Optional: keep a reference to the window
				}
			}
		}
	}
}
