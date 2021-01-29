//
//  LSWKWebView.h
//  LSHybirdPage
//
//  Created by lhs7248 on 2021/1/28.
//

#import <UIKit/UIKit.h>
#import <webkit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface LSWKWebView : WKWebView

/// 当前加载的URL
@property (nonatomic , copy) NSString * currentUrl;

/// 当前加载的request
@property (nonatomic , copy) NSURLRequest * request;



@end

NS_ASSUME_NONNULL_END
