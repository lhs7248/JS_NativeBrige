//
//  LSBasePlugin.h
//  LSHybirdPage
//
//  Created by lhs7248 on 2021/2/1.
//

#import <UIKit/UIKit.h>
#import <webkit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSBasePlugin : NSObject

/// 同屏渲染插入Native的Map View
/// @param webView 目标的Web View
/// @param targetView 目标的WKChildScrollView
/// @param params 对应的参数信息
+(void)inserWebView:(WKWebView *)webView targetView:(UIScrollView *)targetView params:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
