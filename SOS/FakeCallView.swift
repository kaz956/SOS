import SwiftUI

struct FakeCallView: View {
    @Binding var showCallUI: Bool // ContentViewに連携
    @ObservedObject var fakeCallManager = FakeCallManager()  // FakeCallManagerを監視
    
    var body: some View {
        ZStack {
            // 半透明でグラデーションのついた背景
            LinearGradient(
                gradient: Gradient(colors: [Color.gray.opacity(0.7), Color.black.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                if fakeCallManager.isFakeCallActive {
                    // 着信画面
                    VStack {
                        // 通話相手の名前を中央上部に配置
                        Text(fakeCallManager.fakeCallerName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 80)
                        
                        Spacer()
                        
                        HStack(spacing: 50) {  // ボタン間のスペースを50に調整
                            // 拒否ボタン（赤）
                            VStack {
                                Button(action: {
                                    showCallUI = false
                                    fakeCallManager.endCall()  // 音楽停止と通話終了
                                }) {
                                    Image(systemName: "phone.down.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.white)
                                        .padding(26)  // ボタン内の余白を20に設定
                                        .background(Color.red)
                                        .clipShape(Circle())
                                }
                                .frame(width: 120, height: 120)  // 両方のボタンを同じサイズに調整
                                .padding(.leading, 30)  // ボタンの左に30の余白
                                
                                Text("Reject")  // 拒否ボタン下のテキスト
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .padding(.leading, 30)
                                    .frame(maxWidth: .infinity, alignment: .center)  // テキストを中央揃えにする
                            }
                            
                            // 応答ボタン（緑）
                            VStack {
                                Button(action: {
                                    showCallUI = true
                                    fakeCallManager.endFakeCall()  // 通話開始
                                }) {
                                    Image(systemName: "phone.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.white)
                                        .padding(15)  // ボタン内の余白を20に設定
                                        .background(Color.green)
                                        .clipShape(Circle())
                                }
                                .frame(width: 120, height: 120)  // 両方のボタンを同じサイズに調整
                                .padding(.trailing, 30)  // ボタンの右に30の余白
                                
                                Text("Answer")  // 応答ボタン下のテキスト
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .padding(.trailing, 30)
                                    .frame(maxWidth: .infinity, alignment: .center)  // テキストを中央揃えにする
                            }
                        }
                        .padding(.bottom, 40)
                    }
                }
                
                else if fakeCallManager.isInCall {
                    // 通話中画面
                    VStack {
                        // 通話相手の名前
                        Text(fakeCallManager.fakeCallerName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 80)
                        
                        // 通話時間
                        Text(fakeCallManager.callDuration)
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.top, 5)
                        
                        Spacer()
                        
                        // 2x3のボタン
                        VStack {
                            HStack {
                                // ミュートボタン
                                VStack {
                                    Button(action: {}) {
                                        Image(systemName: "mic.slash.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                            .padding(20)
                                            .background(Color.gray.opacity(0.7))
                                            .clipShape(Circle())
                                    }
                                    Text("Mute")
                                        .foregroundColor(.white)
                                }
                                .frame(width: 90, height: 120)
                                
                                // キーパッドボタン
                                VStack {
                                    Button(action: {}) {
                                        Image(systemName: "number")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                            .padding(20)
                                            .background(Color.gray.opacity(0.7))
                                            .clipShape(Circle())
                                    }
                                    Text("Keypad")
                                        .foregroundColor(.white)
                                }
                                .frame(width: 90, height: 120)
                                
                                // スピーカーボタン
                                VStack {
                                    Button(action: {}) {
                                        Image(systemName: "speaker.wave.2.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                            .padding(20)
                                            .background(Color.gray.opacity(0.7))
                                            .clipShape(Circle())
                                    }
                                    Text("Speaker")
                                        .foregroundColor(.white)
                                }
                                .frame(width: 90, height: 120)
                            }
                            
                            HStack {
                                // 通話を追加ボタン
                                VStack {
                                    Button(action: {}) {
                                        Image(systemName: "plus")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                            .padding(20)
                                            .background(Color.gray.opacity(0.7))
                                            .clipShape(Circle())
                                    }
                                    Text("Add Call")
                                        .foregroundColor(.white)
                                }
                                .frame(width: 90, height: 120)
                                
                                // FaceTimeボタン
                                VStack {
                                    Button(action: {}) {
                                        Image(systemName: "questionmark.video.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                            .padding(20)
                                            .background(Color.gray.opacity(0.7))
                                            .clipShape(Circle())
                                    }
                                    Text("FaceTime")
                                        .foregroundColor(.white)
                                }
                                .frame(width: 90, height: 120)
                                
                                // 連絡先ボタン
                                VStack {
                                    Button(action: {}) {
                                        Image(systemName: "person.crop.circle")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                            .padding(20)
                                            .background(Color.gray.opacity(0.7))
                                            .clipShape(Circle())
                                    }
                                    Text("Contacts")
                                        .foregroundColor(.white)
                                }
                                .frame(width: 90, height: 120)
                            }
                        }
                        .padding(.top, 40)
                        
                        Spacer()
                        
                        // 通話終了ボタン
                        Button(action: {
                            showCallUI = false
                            fakeCallManager.endCall()  // 音楽停止と通話終了
                        }) {
                            Image(systemName: "phone.down.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                                .padding(26)  // ボタン内の余白を20に設定
                                .background(Color.red)
                                .clipShape(Circle())
                        }
                        .frame(width: 120, height: 120)  // 両方のボタンを同じサイズに調整
                        .padding(.bottom, 50)
                    }
                } else {
                    // 初期画面（通話が開始されていない場合）
                    Button(action: {
                        showCallUI = true
                        fakeCallManager.startFakeCall()  // 着信を開始
                    }) {
                        Text("Start Fake Call")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
        }
    }
}

