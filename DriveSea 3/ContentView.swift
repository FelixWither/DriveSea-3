//
//  ContentView.swift
//  DriveSea 3
//
//  Created by FelixWither on 2024/12/29.
//

import SwiftUI
import CoreData

struct ContentView: View {
	
	@State var account: String = ""
	@State var password: String = ""
	
	var body: some View {
		ZStack{
			VStack{
				Color(cgColor: .white)
					.frame(height: 60)
				Divider()
					.padding(.top, -8.0)
			}
			HStack{
				Text(LocalizedStringKey("App_Title"))
					.padding(.bottom, 8)
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
					Text(LocalizedStringKey("Input_Account_Prompt"))
					TextField(LocalizedStringKey("Input_Account"), text: $account).frame(width: 300)
				}
				HStack {
					Text(LocalizedStringKey("Input_Password_Prompt"))
					TextField(LocalizedStringKey("Input_Password"), text: $password).frame(width: 300)
				}
			}.padding()
			Spacer()
//			#### Comment this out only for ease of previewing
			Divider()
			HStack{
				Button(LocalizedStringKey("Login"), action: login)
					.buttonStyle(.borderedProminent)
				Button(LocalizedStringKey("Cancel"), role: .destructive, action: cancel)
			}.padding(.bottom, 8.0)
		}
	}
}

func login () {
	
}
	
func cancel () {
	NSApp.keyWindow?.close()
}


#Preview {
	ContentView()
}
