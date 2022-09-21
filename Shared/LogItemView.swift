//
//  NoteView.swift
//  cjplay
//
//  Created by CJ Pais on 4/4/20.
//  Copyright © 2020 CJ Pais. All rights reserved.
//

import SwiftUI

struct LogItemView: View {
    
    var log: LogItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(log.created!.toTime())
                .font(.footnote)
                .bold()
                .padding(.horizontal, 11.0)
            Text(log.data!)
//                .foregroundColor(.black)
                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                .padding(.horizontal, 11.0)
                .textSelection(.enabled)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 11.0)
        .padding(.vertical, 7.0)
        .background(
            RoundedRectangle(cornerRadius: 16.0)
//                .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
                .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
        )
        .padding(.horizontal, 7.0)
    }
}

//struct LogView_Previews: PreviewProvider {
//    static var previews: some View {
////        LogItemView(text: "this is a test string")
//    }
//}
