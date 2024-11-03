//
//  ContentView.swift
//  hangin
//
//  Created by Aharon Seidman on 9/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List{
                NavigationLink("This is screen number 1") {
                    ChatView()
                        
                }
                
                    
                    
                    NavigationLink("This is screen number 2") {
                        Text("Go to screen 2")
                    }
                }
            
            .navigationTitle(Text("Hangin'")) // Default to large title style
            .navigationBarItems(trailing:
                    Button(action: {
                        // Add action
                    }, label: {
                        Text("Add")
                    })
                )
            
        }}
        
    
}

#Preview {
    ContentView()
}
