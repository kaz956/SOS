import SwiftUI

struct HomeView: View {
    @State private var selectedIcon = "Default"
    @State private var appName = "SOS"
    @State private var showDummyScreen = true
    
    var body: some View {
        VStack {
            // アプリアイコン選択
            Picker("App Icon", selection: $selectedIcon) {
                Text("Default").tag("Default")
                Text("Browser").tag("BrowserIcon")
                Text("Calculator").tag("CalculatorIcon")
                Text("Clock").tag("ClockIcon")
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedIcon) {
                updateAppIcon(to: selectedIcon)
            }
            
            // アプリ名のカスタム
            TextField("Enter App Name", text: $appName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // ダミースクリーンのオン・オフ
            Toggle("Enable Dummy Screen", isOn: $showDummyScreen)
                .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle(appName)
    }
    
    // アイコン変更メソッド
    private func updateAppIcon(to iconName: String) {
        guard UIApplication.shared.supportsAlternateIcons else {
            print("Alternate icons not supported")
            return
        }
        
        let iconToSet: String? = (iconName == "Default") ? nil : iconName
        
        UIApplication.shared.setAlternateIconName(iconToSet) { error in
            if let error = error {
                print("Error setting icon: \(error.localizedDescription)")
            } else {
                print("Icon changed to \(iconName)")
            }
        }
    }
}

#Preview {
    HomeView()
}
