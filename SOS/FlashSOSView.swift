import SwiftUI

struct FlashSOSView: View {
    @State private var inputText: String = "SOS"
    @State private var brightness: Float = 1.0

    @StateObject var flashManager = FlashSOSManager()

    var body: some View {
        VStack {
            // 画面上半分: フラッシュ送信
            VStack {
                Text("Morse Code Flashlight")
                    .font(.title)
                    .padding()

                TextField("Enter text", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())


                VStack {
                    Text("Brightness: \(Int(brightness * 100))%")
                        .padding(.top, 16)
                        .font(.headline)
                    Slider(value: $brightness, in: 0.1...1.0, step: 0.1)
                        .padding(.horizontal)
                }

                Button(action: {
                    flashManager.setBrightness(level: brightness)
                    flashManager.sendMorseSignal(text: inputText)
                }) {
                    Text("Send Morse Signal")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(flashManager.isRunning ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(flashManager.isRunning)

                Button(action: {
                    flashManager.cancelMorseSignal()
                }) {
                    Text("Cancel")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(flashManager.isRunning ? Color.red : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!flashManager.isRunning)
            }
            .padding()
            
            Divider()

            // 画面下半分: モールス信号デコード
            VStack {
                Text("Morse Code Decoder")
                    .font(.title)
                    .padding(.horizontal)

                TextField("Morse Input", text: Binding.constant(flashManager.morseCodeBuffer))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .disabled(true)

                TextField("Decoded text", text: Binding.constant(flashManager.decodedText))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .disabled(true)

                // 「.」「-」「スペース」ボタンと削除ボタンを横並びに
                HStack {
                    Button(".") { flashManager.addMorseSymbol(".") }
                        .buttonStyle(MorseButtonStyle())
                    Button("-") { flashManager.addMorseSymbol("-") }
                        .buttonStyle(MorseButtonStyle())
                        .padding(.leading, 10)
                    Button("␣") { flashManager.addMorseSymbol(" ") }
                        .buttonStyle(MorseButtonStyle())
                        .padding(.leading, 10)

                    // 削除ボタン（アイコン）
                    Button(action: {
                        flashManager.deleteLastMorseSymbol()
                    }) {
                        Image(systemName: "delete.left.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.red)
                    }
                    .padding(.leading, 24)
                }
                .padding()

                Button(action: {
                    flashManager.resetMorseCode()
                }) {
                    Text("Reset Morse Code")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

// モールス信号入力ボタンのスタイル
struct MorseButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .padding()
            .frame(width: 60, height: 60)
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Circle())
            .shadow(radius: 5)
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct FlashSOSView_Previews: PreviewProvider {
    static var previews: some View {
        FlashSOSView()
    }
}
