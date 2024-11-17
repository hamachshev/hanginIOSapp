import SwiftUI

struct Circles2: View {
    var users: [ChatUser]
    @State private var circles: [Color] = [Color("CircleBackground"), Color("CircleBackground"), Color("CircleBackground")]  // Initial colors for circles
    
    var body: some View {
        
            HStack(spacing: -25) {  // Negative spacing for overlap
                ForEach(0..<users.count, id: \.self) { index in
                    ZStack {
                        // Shadow circle layer
                        Circle()
                            .fill(Color.black.opacity(0.2))  // Shadow color
                            .frame(width: 50)
                            .offset(x: -5, y: 4)  // Offset for shadow positioning
                            .blur(radius: 4)      // Blurring to soften the shadow
                        
                        // Main circle layer
                        Circle()
                            .fill(.circleBackground)
                            .frame(width: 50)
                        if let url = users[index].profilePic {
                            AsyncImage(url: URL(string: users[index].profilePic!)){
                                image in
                                image.resizable()
                            } placeholder: {
                                
                            }
                            .frame(width:40, height: 40)
                            .clipShape(.circle)
                        }
                    
                    }
                    .zIndex(Double(index))  // Ensure circles layer correctly
                }
            }
         
       
            
            
        

    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Circles2(users:[ChatUser(uuid: "8", firstName: "kjfdhsa", lastName: "fjhdsk", number: "98877776666", profilePic: "https://picsum.photos/200/300")])
    }
}
