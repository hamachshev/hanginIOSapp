//
//  RightMessage.swift
//  hangin
//
//  Created by Aharon Seidman on 10/29/24.
//

import SwiftUI

struct RightMessage: View {
    var text:String
    var body: some View {
        HStack{
            Spacer()
            Text(text)
                .foregroundColor(.white)
                .font(.caption)
                .padding(10)
                .padding(.horizontal, 5)
                .background(RoundedRectangle(cornerRadius: 25)
                    .fill(Color("ownMessage")))
        }
        .padding(.bottom, 5)
    }
}
