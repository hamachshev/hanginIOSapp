//
//  CirclesViews.swift
//  hangin
//
//  Created by Aharon Seidman on 11/11/24.
//

import SwiftUI

struct CirclesViews: View {
    var body: some View {
        HStack {
            Circle()
                
                .fill(Color("CircleBackground"))
                .frame(width: 50)
                .shadow(color: .black, radius: 30, x: -5, y:5)
            Circle()
                .fill(Color("CircleBackground"))
                .frame(width: 50)
                .offset(x: -25)
                .shadow(color: .black, radius: 30, x: -5, y:5)
                
            Circle()
                .fill(Color("CircleBackground"))
                .frame(width: 50)
                .offset(x: -50)
                .shadow(color: .black, radius: 30, x: -5, y:5)
                
            Spacer()
        }
        .frame(width: 200)
    }
}

#Preview {
    CirclesViews()
}
