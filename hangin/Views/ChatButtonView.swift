//
//  ChatButtonView.swift
//  hangin
//
//  Created by Aharon Seidman on 11/11/24.
//

import SwiftUI

struct ChatButtonView: View {
    var body: some View {
        Button(action:{
            
            
        }){
            HStack{
                CirclesViews()
                Text("hello")
                Spacer()
            }
            
        }
        .padding(20)
        .font(.title3)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(RoundedRectangle(cornerRadius: 25).fill(Color("secondary")))
    }
}

#Preview {
    ChatButtonView()
}
