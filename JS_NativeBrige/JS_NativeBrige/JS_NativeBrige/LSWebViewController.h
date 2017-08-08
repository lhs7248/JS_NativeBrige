//
//  LSWebViewController.h
//  JS_NativeBrige
//
//  Created by lhs7248 on 2017/8/8.
//  Copyright © 2017年 lhs7248. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


@interface LSWebViewController : UIViewController

//提供的WebView
@property(nonatomic,strong)UIWebView  * webView;

//提供的WKwebView
@property(nonatomic,strong) WKWebView * wkWebView;


@end

