@_private(sourceFile: "ContentView.swift") import DriveSea_3
import func SwiftUI.__designTimeBoolean
import func SwiftUI.__designTimeInteger
import protocol SwiftUI.PreviewProvider
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeFloat
import struct SwiftUI.EmptyView
import protocol SwiftUI.View
import CoreData
import SwiftUI

@_dynamicReplacement(for: cancel()) private func __preview__cancel() {
#sourceLocation(file: "/Volumes/RamDisk/DriveSea-3/DriveSea 3/ContentView.swift", line: 63)
	NSApp.keyWindow?.close()

#sourceLocation()
}

@_dynamicReplacement(for: login()) private func __preview__login() {
#sourceLocation(file: "/Volumes/RamDisk/DriveSea-3/DriveSea 3/ContentView.swift", line: 59)

#sourceLocation()
}

extension ContentView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Volumes/RamDisk/DriveSea-3/DriveSea 3/ContentView.swift", line: 17)
		ZStack{
			VStack{
				Color(cgColor: .white)
					.frame(height: __designTimeInteger("#7948.[2].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[0].modifier[0].arg[0].value", fallback: 60))
				Divider()
					.padding(.top, __designTimeFloat("#7948.[2].[2].property.[0].[0].arg[0].value.[0].arg[0].value.[1].modifier[0].arg[1].value", fallback: -8.0))
			}
			HStack{
				Text(LocalizedStringKey(__designTimeString("#7948.[2].[2].property.[0].[0].arg[0].value.[1].arg[0].value.[0].arg[0].value.arg[0].value", fallback: "App_Title")))
					.padding(.bottom, __designTimeInteger("#7948.[2].[2].property.[0].[0].arg[0].value.[1].arg[0].value.[0].modifier[0].arg[1].value", fallback: 8))
					.padding(.leading)
					.foregroundStyle(.blue)
					.font(.largeTitle)
				Spacer()
			}
		}
		
		Spacer()
		Group{
			VStack(alignment: .trailing){
				HStack{
					Text(LocalizedStringKey(__designTimeString("#7948.[2].[2].property.[0].[2].arg[0].value.[0].arg[1].value.[0].arg[0].value.[0].arg[0].value.arg[0].value", fallback: "Input_Account_Prompt")))
					TextField(LocalizedStringKey(__designTimeString("#7948.[2].[2].property.[0].[2].arg[0].value.[0].arg[1].value.[0].arg[0].value.[1].arg[0].value.arg[0].value", fallback: "Input_Account")), text: $account).frame(width: __designTimeInteger("#7948.[2].[2].property.[0].[2].arg[0].value.[0].arg[1].value.[0].arg[0].value.[1].modifier[0].arg[0].value", fallback: 300))
				}
				HStack {
					Text(LocalizedStringKey(__designTimeString("#7948.[2].[2].property.[0].[2].arg[0].value.[0].arg[1].value.[1].arg[0].value.[0].arg[0].value.arg[0].value", fallback: "Input_Password_Prompt")))
					TextField(LocalizedStringKey(__designTimeString("#7948.[2].[2].property.[0].[2].arg[0].value.[0].arg[1].value.[1].arg[0].value.[1].arg[0].value.arg[0].value", fallback: "Input_Password")), text: $password).frame(width: __designTimeInteger("#7948.[2].[2].property.[0].[2].arg[0].value.[0].arg[1].value.[1].arg[0].value.[1].modifier[0].arg[0].value", fallback: 300))
				}
			}.padding()
			Spacer()
//			#### Comment this out only for ease of previewing
			Divider()
			HStack{
				Button(LocalizedStringKey(__designTimeString("#7948.[2].[2].property.[0].[2].arg[0].value.[3].arg[0].value.[0].arg[0].value.arg[0].value", fallback: "Login")), action: login)
					.buttonStyle(.borderedProminent)
				Button(LocalizedStringKey(__designTimeString("#7948.[2].[2].property.[0].[2].arg[0].value.[3].arg[0].value.[1].arg[0].value.arg[0].value", fallback: "Cancel")), role: .destructive, action: cancel)
			}.padding(.bottom, __designTimeFloat("#7948.[2].[2].property.[0].[2].arg[0].value.[3].modifier[0].arg[1].value", fallback: 8.0))
		}
	
#sourceLocation()
    }
}

import struct DriveSea_3.ContentView
#Preview {
	ContentView()
}

// Support for back-deployment.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, visionOS 1.0, watchOS 6.0, *)
struct RegistryCompatibilityProvider_line_72: SwiftUI.PreviewProvider {
    static var previews: some SwiftUI.View {
        #if os(macOS)
        let __makePreview: () -> any SwiftUI.View = {
        	ContentView()
        }
        SwiftUI.VStack {
            SwiftUI.AnyView(__makePreview())
        }
        #else
        // The preview is not available.
        SwiftUI.EmptyView()
        #endif
    }
}




