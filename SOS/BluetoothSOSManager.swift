import Foundation
import CoreLocation
import UIKit

class BluetoothSOSManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var title: String = "Help me"
    @Published var message: String = "I'm here"
    @Published var includeLocation: Bool = true
    @Published var lastLocation: CLLocation?
    
    private var locationManager: CLLocationManager?
    
    override init() {
        super.init()
        requestLocation()
    }
    
    // GPS情報の取得を開始
    func requestLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    // 位置情報の更新を受け取る
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            lastLocation = location
            manager.stopUpdatingLocation()
        }
    }
    
    // SOSメッセージをテキストファイルに変換
    private func createSOSFile() -> URL? {
        var content = "**\(title)**\n\n\(message)"
        
        if includeLocation, let location = lastLocation {
            content += "\n\nLocation: \(location.coordinate.latitude), \(location.coordinate.longitude)"
        }
        
        // ドキュメントディレクトリに一時ファイルを作成
        let fileName = "\(title).txt"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("Error creating SOS file: \(error)")
            return nil
        }
    }
    
    // AirDropでテキストファイルを送信
    func sendSOS() {
        guard let fileURL = createSOSFile() else { return }
        
        let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
}
