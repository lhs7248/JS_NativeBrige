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
#import "LSGetUserTokenPlugin.h"


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
        
        [self plugin:plugin messagaBoy:message.body];
      
    }
    
}
// 处理H5 页面传到Native的信息
-(void)plugin:(id<LSBrigeProtocol>)plugin messagaBoy:(id)messageBody{
    
    NSDictionary * dict = [self jsonStrToObj:messageBody];
    if ([dict[@"requireBack"] boolValue] == NO) {
        
        [plugin browser:self.webVC didReceiveScriptMessage:dict[@"messageBody"]];
    }else{
        
        id backParma = [plugin brower:self.webVC didReceiveScriptMessage:dict[@"messageBody"]];
        
        NSMutableDictionary * paramDict = [NSMutableDictionary dictionaryWithCapacity:10];
        [paramDict setValue:dict[@"messageId"] forKey:@"messageId"];
        [paramDict setValue:backParma forKey:@"messageBody"];
        
        NSString * paramStr = [self objToJsonStr:paramDict];
        
        NSString * method = [dict valueForKey:@"method"];
        
        [self evaluateJavaScriptMethod:method param:paramStr];
        
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
                    [self plugin:plugin messagaBoy:data];
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
    // 交互：跳转至邀请好友界面，页面之间的表现为pop到上一层
//    [self addPlugin:[[LNInviteFriendsPlugin alloc]init]];
    // 交互：调起分享的视图
//    [self addPlugin:[[LNInvokeShareFunctionPlugin alloc]init]];
//    [self addPlugin:[LSOpenBrowerPlugin alloc]]
    
    [self addPlugin:[[LSOpenBrowerPlugin alloc]init]];
    [self addPlugin:[[LSGetUserTokenPlugin alloc]init]];
    
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

-(void)evaluateJavaScriptMethod:(NSString *)method param:(NSString *)paramStr{
    
    NSString *jsStr = [NSString stringWithFormat:@"%@('%@')",method,paramStr];
    if (self.webVC.wkWebView) {
        [self.webVC.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"%@----%@",result, error);
        }];
    }else if (self.webVC.webView){
        [self.webVC.webView stringByEvaluatingJavaScriptFromString:jsStr];
    }
    
}

#pragma mark -- json & obj
-(id)jsonStrToObj:(NSString *)jsonStr{
    
    NSData * jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    id obj =  [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    return obj;
}

-(NSString *)objToJsonStr:(id)obj{
    
    NSData * data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:0];
    NSString * jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
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
