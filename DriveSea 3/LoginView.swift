//
//  ContentView.swift
//  DriveSea 3
//
//  Created by FelixWither on 2024/12/29.
//

import SwiftUI
import CoreData

struct LoginView: View {
	
	@StateObject private var VM = LoginViewModel()
	
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
					TextField(LocalizedStringKey("Input_Account"), text: $VM.username).frame(width: 300)
				}
				HStack {
					Text(LocalizedStringKey("Input_Password_Prompt"))
					SecureField(LocalizedStringKey("Input_Password"), text: $VM.password).frame(width: 300)
				}
				Text(VM.loginStatus)
					.foregroundColor(VM.loginStatus.contains("successful") ? .green : .red)
					.padding()
			}.padding()
			Spacer()
//			#### Comment this out only for ease of previewing
			Divider()
			HStack{
				Button(LocalizedStringKey("Login"), action: VM.login)
					.buttonStyle(.borderedProminent)
				Button(LocalizedStringKey("Cancel"), role: .destructive, action: cancel)
			}.padding(.bottom, 8.0)
		}
	}
}
	
func cancel () {
	NSApp.keyWindow?.close()
}


#Preview {
	LoginView()
}
