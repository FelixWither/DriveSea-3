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
		TitleBar()
		VStack{
			Spacer()
			AccountField()
				.environmentObject(VM)
			Spacer()
			Divider()
			Buttons()
				.environmentObject(VM)
		}
	}
}

struct Buttons: View {
	@EnvironmentObject var VM: LoginViewModel
	
	var body: some View {
		HStack{
			Button(LocalizedStringKey("Login"), action: VM.login)
				.buttonStyle(.borderedProminent)
			Button(LocalizedStringKey("Cancel"), role: .destructive, action: cancel)
		}.padding(.bottom, 8.0)
	}
}

struct AccountField: View {
	@EnvironmentObject var VM: LoginViewModel
	
	var body: some View {
		HStack{
			Spacer()
			VStack(alignment: .center){
				HStack{
					Text(LocalizedStringKey("Input_Account_Prompt"))
						.frame(minWidth: 50)
					TextField(LocalizedStringKey("Input_Account"), text: $VM.username)
						.frame(width: 300)
				}
				HStack {
					Text(LocalizedStringKey("Input_Password_Prompt"))
						.frame(minWidth: 50)
					SecureField(LocalizedStringKey("Input_Password"), text: $VM.password).frame(width: 300)
				}
				Text(VM.loginStatus)
			}
				.padding()
				.frame(minHeight: 100)
			Spacer()
		}
	}
}

struct TitleBar: View {
	var body: some View {
		ZStack{
			VStack{
				Color(cgColor: .white)
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
		}.frame(height: 60)
	}
}
	
func cancel () {
	NSApp.keyWindow?.close()
}


#Preview {
	LoginView()
}
