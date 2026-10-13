import AVFoundation
import SwiftUI

class FlashSOSManager: ObservableObject {
    @Published var isRunning = false // 状態管理
    @Published var decodedText: String = "" // 解読されたテキストを保持
    private var isCancelled = false
    private var brightness: Float = 1.0 // 明るさのデフォルト値
    @Published var morseCodeBuffer: String = "" // 受け取ったモールス信号を保存

    func setBrightness(level: Float) {
        brightness = level
    }

    func sendMorseSignal(text: String) {
        isRunning = true
        isCancelled = false
        let morseCode = convertToMorse(text: text.uppercased())

        DispatchQueue.global(qos: .userInitiated).async {
            for symbol in morseCode {
                if self.isCancelled { break }
                
                switch symbol {
                case ".":
                    self.toggleFlash(on: true)
                    usleep(100_000) // 0.1秒
                    self.toggleFlash(on: false)
                case "-":
                    self.toggleFlash(on: true)
                    usleep(300_000) // 0.3秒
                    self.toggleFlash(on: false)
                default:
                    usleep(700_000) // 文字間スペース
                }

                usleep(300_000) // 各シンボルの間に短い間隔を入れる
            }

            DispatchQueue.main.async {
                self.isRunning = false
            }
        }
    }

    func cancelMorseSignal() {
        isCancelled = true
        turnOffFlash()
        isRunning = false
    }

    private func convertToMorse(text: String) -> String {
        let morseDict: [Character: String] = [
            "A": ".-", "B": "-...", "C": "-.-.", "D": "-..", "E": ".",
            "F": "..-.", "G": "--.", "H": "....", "I": "..", "J": ".---",
            "K": "-.-", "L": ".-..", "M": "--", "N": "-.", "O": "---",
            "P": ".--.", "Q": "--.-", "R": ".-.", "S": "...", "T": "-",
            "U": "..-", "V": "...-", "W": ".--", "X": "-..-", "Y": "-.--",
            "Z": "--..", "1": ".----", "2": "..---", "3": "...--", "4": "....-",
            "5": ".....", "6": "-....", "7": "--...", "8": "---..", "9": "----.",
            "0": "-----", " ": " "
        ]
        return text.map { morseDict[$0] ?? "" }.joined(separator: " ")
    }

    private func toggleFlash(on: Bool) {
        // バックグラウンドスレッドでフラッシュの操作を行う
        DispatchQueue.global(qos: .userInitiated).async {
            guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
            do {
                try device.lockForConfiguration()
                if on {
                    try device.setTorchModeOn(level: self.brightness) // スライダーの値を反映
                } else {
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            } catch {
                print("Error accessing flashlight: \(error)")
            }
        }
    }


    func turnOffFlash() {
        toggleFlash(on: false)
    }
    
    // モールス信号を解読
    func decodeMorseCode() {
        let morseDict: [String: String] = [
            ".-" : "A", "-..." : "B", "-.-." : "C", "-.." : "D", "." : "E",
            "..-." : "F", "--." : "G", "...." : "H", ".." : "I", ".---" : "J",
            "-.-" : "K", ".-.." : "L", "--" : "M", "-." : "N", "---" : "O",
            ".--." : "P", "--.-" : "Q", ".-." : "R", "..." : "S", "-" : "T",
            "..-" : "U", "...-" : "V", ".--" : "W", "-..-" : "X", "-.--" : "Y",
            "--.." : "Z", ".----" : "1", "..---" : "2", "...--" : "3", "....-" : "4",
            "....." : "5", "-...." : "6", "--..." : "7", "---.." : "8", "----." : "9",
            "-----" : "0", " " : " "
        ]
        
        // モールス信号をスペースで分割し、解読
        self.decodedText = morseCodeBuffer.split(separator: " ").compactMap { morseDict[String($0)] }.joined()
    }
    
    // モールス信号をリセット
    func resetMorseCode() {
        morseCodeBuffer = ""
        decodedText = ""
    }
    
    // モールス信号を追加
    func addMorseSymbol(_ symbol: String) {
        morseCodeBuffer += symbol
        decodeMorseCode()
    }
    
    func deleteLastMorseSymbol() {
        guard !morseCodeBuffer.isEmpty else { return }
        morseCodeBuffer.removeLast()
        decodeMorseCode()
    }
}
