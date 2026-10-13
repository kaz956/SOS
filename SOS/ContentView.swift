import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var appDelegate: AppDelegate
    
    @State private var showCallUI = false // FakeCallViewから切り替え用フラグを受け取る
    @StateObject private var fakeCallManager = FakeCallManager()

    init() {
        UITabBar.appearance().isHidden = false // 初期状態ではタブバーを表示
    }
    
    var body: some View {
        ZStack {
            TabView {
                if showCallUI {
                    
                    FakeCallView(showCallUI: $showCallUI, fakeCallManager: fakeCallManager)
                } else {
                    TabView {
                        HomeView()
                            .tabItem {
                                Image(systemName: "house.fill")
                                Text("Home")
                            }
                        FakeCallView(showCallUI: $showCallUI, fakeCallManager: fakeCallManager)
                            .tabItem {
                                Image(systemName: "phone.fill")
                                Text("Fake Call")
                            }
                        FlashSOSView()
                            .tabItem {
                                Image(systemName: "flashlight.on.fill")
                                Text("Flash SOS")
                            }
                        SOSView()
                            .tabItem {
                                Image(systemName: "antenna.radiowaves.left.and.right.circle.fill")
                                Text("Bluetooth SOS")
                            }
                    }
                }
            }
            .disabled(appDelegate.showDummyScreen) // ダミー画面表示中は他のビューを操作できないようにする
            
            if appDelegate.showDummyScreen {
                DummyScreenView()
                    .transition(.opacity) // アニメーションを追加
            }
        }
        .onChange(of: scenePhase) {
            // シーンのライフサイクルが変化したときの処理
            switch scenePhase {
                case .inactive:
                    appDelegate.showDummyScreen = true
                    
                case .background:
                    // アプリがバックグラウンドに入るとき
                    appDelegate.showDummyScreen = true
    
                case .active:
                    // アプリがアクティブに戻るとき
                    break
                default:
                    break
            }
        }
    }
}

#Preview {
    ContentView()
}
