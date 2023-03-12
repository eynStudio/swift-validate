import SwiftUI
import Foundation

public struct ViewWrapper<Content:View,Payload>:View {
    @State private var validated: Validated<Payload> = .untouched

    private let label: String
    private let content: Content
    private let publisher: ValidationPublisherOf<Payload>
    
    public init(
        _ label: String,
        _ content: Content,
        _ publisher: ValidationPublisher
    ) where Payload == Void {
        self.label = label
        self.content = content
        self.publisher = publisher
    }
    
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(label)
            content
            
            if case let .failure(reason) = self.validated, !reason.isEmpty {
                Text(LocalizedStringKey(reason))
//                    .font(configuration.hintFont)
//                    .foregroundColor(configuration.dangerColor)
//                    .transition(configuration.hintTransition)
            }
        }
        .onReceive(publisher, perform: handleValidation)
    }
    
    private func handleValidation(_ validationResult: Validated<Payload>) {
        withAnimation {
            self.validated = validationResult
        }
    }
}

extension View {
    public func validate(
        _ label:String,
        for publisher: ValidationPublisher
    ) -> some View {
        ViewWrapper(label,self,publisher)
    }
}

struct ViewWrapper_Previews: PreviewProvider {
    struct LoginModel {
        var email: String
        var password: String
    }
    
    class ViewModel: ObservableObject {
        @Published var model = LoginModel(email: "",password: "")
        
        public lazy var emailValidator: ValidationPublisher = {
            $model.map(\.email).validateNonEmpty(error: "Not Empty")
        }()
        public lazy var passwordValidator: ValidationPublisher = {
            $model.map(\.password).validateNonEmpty(error: "Not Empty")
        }()
    }
    

    
    struct Content: View {
        @StateObject private var vm = ViewModel()
        @State var btnText = "OK?"
        
        private func ok() {
            print("OK")
            btnText="OK!"
            
        }
        
        var body: some View {
            List {
                TextField("Email", text: $vm.model.email).validate("Email",for: vm.emailValidator)
                TextField("Password", text: $vm.model.password).validate("Password",for: vm.passwordValidator)
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
