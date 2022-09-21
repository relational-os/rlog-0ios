//
//  ContentView.swift
//  Shared
//
//  Created by CJ Pais on 7/8/22.
//


import SwiftUI
import web3

struct LogInputView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FocusState private var focused: Bool
    @State private var text = ""
    
    
    var body: some View {
        HStack(alignment: .bottom) {
            importPhotoButton.padding(.horizontal).padding(.bottom, 5)
            ZStack(alignment: .bottom) {
                
                
                if #available(iOS 16.0, *) {
                    TextField("log", text: $text, axis: .vertical)
                    //                TextEditor(text: $text)
                        .font(.system(.body))
                        .focused($focused)
                        .padding(.all, 5)
                        .padding(.horizontal, 13)
                    //                        .frame(maxHeight: 80)
                        .background(GeometryReader { geometry in
                            RoundedRectangle(cornerRadius: 17).stroke(Color(.systemGray3), lineWidth: 1.0)
                                .onChange(of: geometry.size.height, perform: { height in
                                    NotificationCenter.default.post(Notification(name: .init(rawValue: "inputHeightChanged"), object: height))
                                })
                        })
                        .lineLimit(5)
                } else {
                    // Fallback on earlier versions
                    TextEditor(text: $text)
                        .font(.system(.body))
                        .focused($focused)
                        .padding(.all, 5)
                        .padding(.horizontal, 13)
                        .frame(maxHeight: 80)
                        .background(GeometryReader { geometry in
                            RoundedRectangle(cornerRadius: 17).stroke(Color(.systemGray3), lineWidth: 1.0)
                                .onChange(of: geometry.size.height, perform: { height in
                                    NotificationCenter.default.post(Notification(name: .init(rawValue: "inputHeightChanged"), object: height))
                                })
                        })
                        .lineLimit(5)
                }
                        
                
//                        .background(Color.purple)
                HStack {
                    Spacer()
                    
                    if (text != "") {
                        sendButton.padding(.bottom, 3.75)
                    } else {
                        recordButton.padding(.bottom, 3)
                    }
                    
                }
            }
            .onAppear {
                focused = true;
            }
//                    .onChange(of: geometry.size.height, perform: { height in
//                        NotificationCenter.default.post(Notification(name: .init(rawValue: "inputHeightChanged"), object: height))
//                    })
        }
    //            .background(Color.green)
//            }
    }
    
    private func addLog() {
        withAnimation {
            let newLog = LogItem(context: viewContext)
            
            newLog.created = Date()
            newLog.modified = Date()
            newLog.data = text
            newLog.author = ""
            newLog.txHash = ""
            newLog.uuid = UUID()
        
            do {
                let (signedData, signedMessage) = getSignedMessage(message: text)
                try? sendLog(data: signedData!, signature: signedMessage!)
                text = ""
                try viewContext.save()
                
//                print("get account \(getAccount())")
                

            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            
            
//            NotificationCenter.default.post(Notification(name: .init(rawValue: "logCreated"), object: nil))
        }
    }
    
    var importPhotoButton: some View {
        Button(action: {
            
        })
        {
            Image(systemName: "photo.fill")
                .foregroundColor(.gray)
                .font(Font.system(.title2))
//                .background(Color.pink)
        }
    }
    
    var recordButton: some View {
        Button(action: {
            
        })
        {
            Image(systemName: "mic")
                .foregroundColor(.gray)
                .padding(.all, 4.0)
        }
        .padding(.trailing, 4)
    }
    
    var sendButton: some View {
        Button(action: {
            addLog()
        })
        {
            Image(systemName: "arrow.up")
                .foregroundColor(Color.white)
                .padding(.all, 4.0)
                .background(Circle().foregroundColor(Color.blue))
                .font(Font.system(.body).bold())
        }
        .keyboardShortcut(.return)
        .padding(.trailing, 4)
    }
}

func sendLog(data: TypedData, signature: String) throws {
    guard let url = URL(string: "http://site-demo.vercel.app/api/forward") else {
//    guard let url = URL(string: "http://192.168.0.241:3000/api/forward") else {
//    guard let url = URL(string: "http://172.16.101.80:3000/api/forward") else {
        fatalError("URL Doesn't Exist")
    }
    
    print("\(data)")
    
    let contractAddr = UserDefaults.standard.string(forKey: "contractAddr")!
    let params = JSONMessage(contractAddr: contractAddr, data: data, signature: signature)
    let jsonData = try? JSONEncoder().encode(params)
//    let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
    
    var urlRequest = URLRequest(url: url)
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.httpMethod = "POST"
    urlRequest.httpBody = jsonData
    
    
    let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
        }
        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        if let responseJSON = responseJSON as? [String: Any] {
            print(responseJSON)
        }
    }
    
    task.resume()
    
}


struct LogInputView_Previews: PreviewProvider {
    static var previews: some View {
        LogInputView()
    }
}
