import UIKit
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    
    var window: UIWindow?
    @Published var showDummyScreen = false
    
    override init() {
        super.init()
        
        // NotificationCenterでバックグラウンド状態を監視
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        // Observerを削除してメモリリークを防ぐ
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func didEnterBackground() {
        // アプリがバックグラウンドに入るとき
        print("Application did enter background")
        showDummyScreen = true // ダミー画面を表示
    }

    @objc func willEnterForeground() {
        // アプリがフォアグラウンドに戻るとき
        print("Application will enter foreground")
        showDummyScreen = false // ダミー画面を非表示
    }
}

extension Notification.Name {
    static let didEnterBackground = Notification.Name("didEnterBackground")
    static let didBecomeActive = Notification.Name("didBecomeActive")
}
