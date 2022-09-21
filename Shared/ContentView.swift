//
//  ContentView.swift
//  Shared
//
//  Created by CJ Pais on 7/8/22.
//


import SwiftUI

struct ContentView: View {
    
    @State var contractAddr: String = UserDefaults.standard.string(forKey: "contractAddr") ?? ""
    @State var addrInput: String = ""
    @State var submitted: Bool = false
    
    var body: some View {
        if (contractAddr.count != 42 && !submitted) {
            VStack(spacing: 3) {
                Text("Your Wallet Address")
                    .bold()
                Text("Long press to copy and set on your contract")
                    .font(.caption)
                Text(keychain.account?.address.value ?? "0x")
                    .textSelection(.enabled)
                    .font(.footnote)
                    .padding(.bottom, 10)
                Text("Input Contract Address")
                    .bold()
                TextField("0x....", text: $addrInput)
                    .padding()
                    .font(.footnote)
                    .background(
                        RoundedRectangle(cornerRadius: 16.0)
                            .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
                    )
                Button(action: {
                    print("submitted")
                    UserDefaults.standard.set(addrInput, forKey: "contractAddr")
                    submitted = true
                }) {
                    Text("Set Address")
                        .padding(11)
//                            .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 16.0)
                                .fill(Color.gray)
                        )
                }
                .disabled(addrInput.count != 42)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16.0)
                    .fill(.purple)
            )
            .padding(7.0)
        } else {
            VStack {
                LogListView()
                Spacer()
                LogInputView()
                    .padding(.bottom, 4).padding(.trailing)
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name.init("resetContract")), perform: { _ in
                contractAddr = ""
            })}
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
