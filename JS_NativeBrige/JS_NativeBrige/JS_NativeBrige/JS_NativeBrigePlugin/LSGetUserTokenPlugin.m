//
//  LSGetUserTokenPlugin.m
//  JS_NativeBrige
//
//  Created by lhs7248 on 2017/8/9.
//  Copyright © 2017年 lhs7248. All rights reserved.
//

#import "LSGetUserTokenPlugin.h"

@implementation LSGetUserTokenPlugin

-(NSString *)scriptMessageHandlerName{
    return @"getToken";
}

-(void)browser:(id)browser didReceiveScriptMessage:(id)message{
   
    NSLog(@"WKWebViewProtocol:%@",message);
    
}
-(id)browerCallBack:(id)browser didReceiveScriptMessage:(id)message{
   
    return @"上海 浦电路地铁站";
}


@end
