//
//  LSWebViewController.h
//  JS_NativeBrige
//
//  Created by lhs7248 on 2017/8/8.
//  Copyright © 2017年 lhs7248. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface LSWebViewController : UIViewController<WKNavigationDelegate, WKUIDelegate, UIWebViewDelegate>


//提供的WebView
@property(nonatomic,strong)UIWebView  * webView;

//提供的WKwebView
@property(nonatomic,strong) WKWebView * wkWebView;


@property (nonatomic, copy) NSString *backURL;
//@property (nonatomic, weak) id <KINWebBrowserDelegate> delegate;

// Load a NSURLURLRequest to web view
// Can be called any time after initialization
- (void)loadRequest:(NSURLRequest *)request;

// Load a NSURL to web view
// Can be called any time after initialization
- (void)loadURL:(NSURL *)URL;

// Loads a URL as NSString to web view
// Can be called any time after initialization
- (void)loadURLString:(NSString *)URLString;


// Loads an string containing HTML to web view
// Can be called any time after initialization
- (void)loadHTMLString:(NSString *)HTMLString;


+ (LSWebViewController *)webBrowser;
+ (LSWebViewController *)webBrowserWithConfiguration:(BOOL)useWKWebView;

@end

