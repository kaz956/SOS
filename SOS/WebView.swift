import SwiftUI
import WebKit

// WebViewの作成
struct WebView: UIViewRepresentable {
    var url: URL
    @Binding var webView: WKWebView?
    
    func makeUIView(context: Context) -> WKWebView {
        // WKWebViewの作成
        let webView = WKWebView()
        
        // ナビゲーションデリゲートを設定
        webView.navigationDelegate = context.coordinator
        
        // 初期URLを読み込み
        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // URLが更新された場合に再読み込み
        if uiView.url != url {
            uiView.load(URLRequest(url: url))
        }
    }
    
    // コーディネーターを作成
    func makeCoordinator() -> WebViewCoordinator {
        return WebViewCoordinator()
    }
}

// WKNavigationDelegate を実装するためのコーディネーター
class WebViewCoordinator: NSObject, WKNavigationDelegate {
    
    // ページの読み込み開始時に呼ばれる
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Page loading started")
    }
    
    // ページの読み込みが完了した時に呼ばれる
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Page finished loading")
    }
    
    // ページ読み込み中にエラーが発生した場合に呼ばれる
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Page load failed with error: \(error.localizedDescription)")
    }
    
    // URL読み込み中にリダイレクトが発生した場合に呼ばれる
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Page started committing navigation")
    }
}
