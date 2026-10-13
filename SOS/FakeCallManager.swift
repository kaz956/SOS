import Foundation
import AVFoundation

class FakeCallManager: ObservableObject {
    @Published var isFakeCallActive = false
    @Published var isInCall = false
    @Published var callDuration: String = "00:00"
    var fakeCallerName = "John Doe"  // 仮の通話相手の名前
    var audioPlayer: AVAudioPlayer?
    
    private var callStartTime: Date?
    private var timer: Timer?

    func startFakeCall() {
        isFakeCallActive = true
        playRingtone()
    }

    func endCall() {
        isFakeCallActive = false
        isInCall = false
        stopRingtone()
        stopCallTimer()
    }

    func endFakeCall() {
        self.isInCall = true
        self.isFakeCallActive = false
        startCallTimer()
        audioPlayer?.stop()  // 通話開始時に音楽を止める
    }

    func playRingtone() {
        guard let url = Bundle.main.url(forResource: "ringtone", withExtension: "mp3") else {
            print("Ringtone file not found!")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1  // 無限ループ
            audioPlayer?.play()
        } catch {
            print("Error playing ringtone: \(error)")
        }
    }

    func stopRingtone() {
        audioPlayer?.stop()
    }
    
    private func startCallTimer() {
        callStartTime = Date()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCallDuration), userInfo: nil, repeats: true)
    }
    
    private func stopCallTimer() {
        timer?.invalidate()
    }
    
    @objc private func updateCallDuration() {
        guard let startTime = callStartTime else { return }
        let elapsedTime = Date().timeIntervalSince(startTime)
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        callDuration = String(format: "%02d:%02d", minutes, seconds)
    }
}
