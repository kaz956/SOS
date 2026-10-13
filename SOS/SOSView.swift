import SwiftUI

struct SOSView: View {
    @StateObject private var sosManager = BluetoothSOSManager()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Send SOS Message")
                .font(.largeTitle)
                .bold()
            
            // タイトル入力欄
            TextField("Enter Title", text: $sosManager.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // メッセージ入力欄
            TextField("Enter Message", text: $sosManager.message)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // GPS添付のオン/オフ切り替え
            Toggle("Include Location", isOn: $sosManager.includeLocation)
                .padding(.horizontal)
            
            // 送信ボタン
            Button(action: {
                sosManager.sendSOS()
            }) {
                Text("Send via AirDrop")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding(.top)
    }
}

#Preview {
    SOSView()
}
