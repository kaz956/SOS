import SwiftUI
import WebKit

struct DummyScreenView: View {
    @EnvironmentObject var appDelegate: AppDelegate
    @State private var searchText = ""  // 検索バーのテキスト
    @State private var currentURL = URL(string: "https://www.apple.com")!  // 初期URL
    
    // WebViewの状態管理
    @State private var webView: WKWebView?

    var body: some View {
        VStack {
            // WebViewの表示部分
            WebView(url: currentURL, webView: $webView) // WebViewのインスタンスを渡す
                .edgesIgnoringSafeArea(.all)  // 余白をなくす

            // 下部のナビゲーションバー
            HStack {
                Button(action: {
                    // 戻るボタンのアクション
                    if let webView = webView, webView.canGoBack {
                        webView.goBack()  // WebViewで前のページに戻る
                    } else {
                        appDelegate.showDummyScreen = false
                    }
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.leading)
                }

                Spacer()

                // 検索バーを配置
                SearchBar(text: $searchText)
                    .onSubmit {
                        // エンターキーが押されたときにURLを更新
                        if !searchText.isEmpty {
                            currentURL = URL(string: "https://www.google.com/search?q=\(searchText)")!
                        } else {
                            currentURL = URL(string: "https://www.google.com")!
                        }
                    }

                Spacer()

                Button(action: {
                    // リフレッシュボタンのアクション
                    webView?.reload()  // WebViewをリロード
                }) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.trailing)
                }
            }
            .background(Color.gray.opacity(0.2))
            .frame(height: 50)
        }
        .background(Color.white) // 背景色
        .edgesIgnoringSafeArea(.top) // 上部の余白をなくす
    }
}

// 検索バー用のカスタムビュー
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .padding(.leading)
            TextField("Search...", text: $text)
                .padding(7)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            if !text.isEmpty {
                Button(action: {
                    text = ""  // テキストクリア
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .padding(.trailing)
                }
            }
        }
        .frame(height: 35)
        .padding(.horizontal)
        .background(Color.white)
        .foregroundColor(.black)
        .cornerRadius(10)
    }
}
