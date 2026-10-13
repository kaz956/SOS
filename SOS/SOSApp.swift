import SwiftUI

@main
struct SilentSOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDelegate) // AppDelegateをEnvironmentObjectとして渡す
        }
    }
}
