//
//  LSDataBrigeManger.m
//  JS_NativeBrige
//
//  Created by lhs7248 on 2017/8/8.
//  Copyright © 2017年 lhs7248. All rights reserved.
//

#import "LSDataBrigeManger.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
// :: Other ::
#import "LSOpenBrowerPlugin.h"

@interface LSDataBrigeManger()<WKScriptMessageHandler>

@property(nonatomic,strong)LSWebViewController  * webVC;


@property (nonatomic, strong) NSMutableDictionary *plugins;

@property (nonatomic, weak) JSContext *jsContext;

@property (nonatomic, strong) NSMutableDictionary *messageHandlers;

@property (nonatomic, strong) NSMutableDictionary *fakeJSWebKit;

@end


@implementation LSDataBrigeManger


-(instancetype)initWithWebVC:(LSWebViewController *)webVC{
    
    self = [super init];
    
    if (self) {
        
        self.webVC = webVC;
        self.plugins = [NSMutableDictionary dictionary];
        
        if (webVC.webView) {
            self.messageHandlers = [NSMutableDictionary dictionary];
        }
        
        [self changeNavigatorUserAgent];
        
    }
    return self;
}

#pragma mark --WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    id<LSBrigeProtocol> plugin = [_plugins objectForKey:message.name];
    
    if (plugin) {
        [plugin browser:self.webVC didReceiveScriptMessage:message.body];
    }
    
}

// 添加plugin 的方法
- (void)addPlugin:(id<LSBrigeProtocol>)plugin {
    
    NSString *name;
    if ([plugin respondsToSelector:@selector(scriptMessageHandlerName)]) {
        name = [plugin scriptMessageHandlerName];
    }
    
    if (!name || [_plugins objectForKey:name]) { return; }
    
    [_plugins setObject:plugin forKey:name];
    
    if (self.webVC.wkWebView) {
        [self.webVC.wkWebView.configuration.userContentController addScriptMessageHandler:self name:[plugin scriptMessageHandlerName]];
    } else if (self.webVC.webView) {
        self.jsContext.exceptionHandler = ^(JSContext *con, JSValue *exception) {
            con.exception = exception;
        };
        
        if (![_messageHandlers objectForKey:name]) {
            [_messageHandlers setObject:@{@"postMessage":^(id data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [plugin browser:self.webVC didReceiveScriptMessage:data];
                });
            }} forKey:name];
        }
    }
}

- (id<LSBrigeProtocol>)getPlugin:(NSString *)name {
    return [_plugins objectForKey:name];
}

- (void)addDefaultPlugins {
    // 交互：通过safari打开url
//    [self addPlugin:[[LNOpenBrowserPlugin alloc]init]];
    // 交互：跳转至邀请好友界面，页面之间的表现为pop到上一层
//    [self addPlugin:[[LNInviteFriendsPlugin alloc]init]];
    // 交互：调起分享的视图
//    [self addPlugin:[[LNInvokeShareFunctionPlugin alloc]init]];
    
    if (self.webVC.webView) {
        JSContext *context = self.jsContext;
        context[@"webkit"] = self.fakeJSWebKit;
    }
}

// 修改 default userAgent


-(void)changeNavigatorUserAgent{
   
    //get the original user-agent of webview
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    //add my info to the new agent
    if ([oldAgent rangeOfString:@"app=Loan,version"].length>0) {
        return;
    }
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    NSString *newAgent = [oldAgent stringByAppendingFormat:@"; app=Loan,version=%@",currentVersion];
    
    //regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}

#pragma mark - Getters & Setters

- (JSContext *)jsContext {
    return [self.webVC.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
}

- (NSMutableDictionary *)fakeJSWebKit {
    if (!_fakeJSWebKit) {
        _fakeJSWebKit = @{@"messageHandlers": _messageHandlers}.mutableCopy;
    }
    return _fakeJSWebKit;
}


@end
