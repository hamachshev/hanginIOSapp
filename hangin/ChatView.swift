//
//  ChatView.swift
//  hangin
//
//  Created by Aharon Seidman on 9/13/24.
//

import SwiftUI

struct ChatView: View {
    @State private var text: String = ""
    @State private var swipeUp:CGFloat = 0
    @State private var message = false
    @State private var ended = false
    
    var body: some View {
        VStack{
            Spacer()
            ZStack{
                Text(text).foregroundColor(.white)
                    .tint(.white)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width:UIScreen.main.bounds.width * 0.9, height: 50)
                    .background(Color("bluish"))
                    .clipShape(RoundedRectangle(cornerRadius: 11.0))
                    
                    .offset(x: message ? 165: 0, y: message ? -125 : 0)
                    .scaleEffect(x:0.5, y:0.5)
                
                TextField("", text: $text, prompt: Text("Say something!").foregroundColor(.white))
                    .tint(.white)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width:UIScreen.main.bounds.width * 0.9, height: 50)
                    .background(Color("bluish"))
                    .clipShape(RoundedRectangle(cornerRadius: 11.0))
                    .offset(x: 0, y: !ended ? swipeUp: 0)
                    
         
                        
                    
               
                    .gesture(
                        DragGesture()
                            .onChanged{ value in
                                if value.translation.height < -5  && value.translation.height > -15 {
                                    ended = false
                                    swipeUp = value.translation.height
                                    
                                    withAnimation(Animation.bouncy){
                                        message = true
                                    }
    
                                }
                            }
                            .onEnded({ _ in
                                withAnimation {
                                    ended = true
                                }
                                
                            })
                                
                                      
                    )
                
                Button {
                    print("Edit button was tapped")
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .tint(.white)
                }
                
            }
            Text("hello \(text)")
        }
    }
}

#Preview {
    ChatView()
}
