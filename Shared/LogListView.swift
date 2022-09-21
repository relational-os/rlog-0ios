//
//  LogListView.swift
//  Log
//
//  Created by CJ Pais on 7/8/22.
//

import SwiftUI
import Combine

struct LogListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \LogItem.created, ascending: true)],
        animation: .default)
    private var items: FetchedResults<LogItem>
    @State var isHidden = true
    
    
    var body: some View {
        GeometryReader { geometry in
            
                ScrollViewReader { scrollView in
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 4) {
                            Text("Debug Info:")
                                .bold()
                            Text("Signer Address:")
                                .font(.caption)
                            Text(keychain.account?.address.value ?? "no wallet! big problem!")
                                .font(.caption)
                                .bold()
                                .textSelection(.enabled)
                            Text("Smart Contract Wallet Address:")
                                .font(.caption)
                            Text(UserDefaults.standard.string(forKey: "contractAddr") ?? "no wallet! big problem!")
                                .font(.caption)
                                .bold()
                                .textSelection(.enabled)
                            Button(action:{
                                UserDefaults.standard.set("", forKey: "contractAddr")
                                NotificationCenter.default.post(Notification(name: .init(rawValue: "resetContract"), object: true))
                            }) {
                                Text("Reset Contract Addr")
                            }
                            ForEach(items.indices, id: \.self) { index in
                                VStack(alignment: .leading) {
                                    if (index == 0 || dateChanged(curr: items[index], prev: items[index - 1])) {
                                        Text(formatDate(item: items[index]))
                                            .bold()
                                            .padding()
                                    }
                                    LogItemView(log: items[index])
                                }
                            }
                        }.frame(maxWidth: geometry.size.width).onAppear {
                            print("frame")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
                                if (items.count > 0) {
                                    scrollView.scrollTo(items.count - 1)
                                }
                                
                                isHidden = false
                            })
                        }
                        .onReceive(NotificationCenter.default.publisher(for: Notification.Name.init("inputHeightChanged")), perform: { _ in
                            
                            if (items.count > 0) {
                                scrollView.scrollTo(items.count - 1)
                            }
                            
                        })
                        .onChange(of: items.count, perform: { count in
                            if count > 0 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.30, execute: {
                                    if (items.count > 0) {
                                        scrollView.scrollTo(count - 1)
                                    }
                                })
                            }
                        })
                    }
                .frame(width: geometry.size.width)
                    .opacity(isHidden ? 0 : 1)
                    .padding(.top, 1)
                //                            .background(.blue)
            }
        }
    }
}

func formatDate(item: LogItem) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .full
    dateFormatter.timeStyle = .none
    
    return dateFormatter.string(from: item.created!)
}

func dateChanged(curr: LogItem, prev: LogItem) -> Bool {
    let cal = Calendar(identifier: .iso8601)
    
    let currDate = cal.dateComponents(in: TimeZone.current, from: curr.created!)
    let prevDate = cal.dateComponents(in: TimeZone.current, from: prev.created!)
//    DateComponents(from: <#T##Decoder#>)
    
    return currDate.day != prevDate.day;
}

struct LogListView_Previews: PreviewProvider {
    static var previews: some View {
        LogListView()
    }
}
