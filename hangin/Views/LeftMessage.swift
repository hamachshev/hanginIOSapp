//
//  LeftMessage.swift
//  hangin
//
//  Created by Aharon Seidman on 10/29/24.
//

import SwiftUI

struct LeftMessage: View {
    var text:String
    
    var body: some View{
        HStack{
            Text(text)
                .foregroundColor(.white)
                .font(.caption)
                .padding(10)
                .padding(.horizontal, 10)
                .background(RoundedRectangle(cornerRadius: 25)
                    .fill(Color("secondary")))
            Spacer()
    }
    .padding(.bottom, 5)
    }
}

