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

#import "LSH5Function.h"
#import <SVProgressHUD/SVProgressHUD.h>

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
    
    if ([message.name isEqualToString:@"openBrowser"]) {
        [self dealOpenBrower:message.body];
    }else if([message.name isEqualToString:@"getToken"] & [message.body isKindOfClass:[NSString class]]) {
        NSLog(@"WKWebViewProtocol:%@",message);
    }else{
        
        [self plugin:plugin messagaBoy:message.body];
    }
    
}

-(void )dealOpenBrower:(id)message{
    
    if ([message isKindOfClass:[NSString class]]) {
        [self showTostStr:message];
    }else if ([message isKindOfClass:[NSArray class]] ||[message isKindOfClass:[NSDictionary class]]){
        NSData * data =  [NSJSONSerialization dataWithJSONObject:message options:0 error:nil];
        NSString * toast = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [self showTostStr:toast];
    }
    
    
}

-(void)showTostStr:(NSString *)toastStr {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:toastStr];
        [SVProgressHUD dismissWithDelay:3];
    });
}

// 处理H5 页面传到Native的信息
-(void)plugin:(id<LSBrigeProtocol>)plugin messagaBoy:(id)messageBody{
    

//    NSDictionary * dict = [self jsonStrToObj:messageBody];
    NSDictionary * dict = messageBody;
    if ([dict[@"requireBack"] boolValue] == NO) {
        if ([plugin respondsToSelector:@selector(browser:didReceiveScriptMessage:)]) {

            [plugin browser:self.webVC didReceiveScriptMessage:dict[@"messageBody"]];
        }
    }else{
        if ([plugin respondsToSelector:@selector(browerCallBack:didReceiveScriptMessage:)]) {
            id backParma = [plugin browerCallBack:self.webVC didReceiveScriptMessage:dict[@"messageBody"]];
            NSMutableDictionary * paramDict = [NSMutableDictionary dictionaryWithCapacity:10];
            [paramDict setValue:dict[@"messageId"] forKey:@"messageId"];
            [paramDict setValue:backParma forKey:@"messageBody"];

            NSString * paramStr = [self objToJsonStr:paramDict];

            NSString * method = [dict valueForKey:@"method"];

            [self evaluateJavaScriptMethod:method param:paramStr];

        }

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
    [self addPlugin:[[LSOpenBrowerPlugin alloc]init]];
    [self addPlugin:[[LSGetUserTokenPlugin alloc]init]];
    
    if (self.webVC.webView) {
        JSContext *context = self.jsContext;
        
//        context[@"webkit"] = self.fakeJSWebKit;
        context[@"NativeFunction"] = [[LSH5Function alloc]init];
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
