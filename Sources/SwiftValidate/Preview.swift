
import SwiftUI
import Foundation

struct ViewWrapper_Previews: PreviewProvider {
    struct LoginModel {
        var email: String
        var password: String
    }
    
    class ViewModel: ObservableObject {
        @Published var model = LoginModel(email: "",password: "")
        
        @Validated(.isEmpty) var username:String="eyn"

    }
    

    
    struct Content: View {
        
        @Validated(.isEmpty) var username:String="eyn"

        @StateObject private var vm = ViewModel()
        @State var btnText = "OK?"
        
        private func ok() {
            print("OK")
            btnText="OK!"
            
            _username.validate()
            
            
            
        }
        
        var body: some View {
            List {
                TextField("Username", text: $username)
                Spacer()
                Text(username)
                Text(_username.errMsg)
                Spacer()
                TextField("Email", text: $vm.model.email)
                TextField("Password", text: $vm.model.password)
                Button(btnText,action:ok)
            }
        }
    }
    
    static var previews: some View {
        Group {
            Content()
        }
    }
}
