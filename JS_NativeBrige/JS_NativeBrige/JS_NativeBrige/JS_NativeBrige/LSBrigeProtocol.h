//
//  LSBrigeProtocol.h
//  JS_NativeBrige
//
//  Created by lhs7248 on 2017/8/8.
//  Copyright © 2017年 lhs7248. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LSBrigeProtocol <NSObject>

@required
// js调用客户端的方法名

- (NSString *)scriptMessageHandlerName;

@optional

// 客户端接收到js方法的回调
- (void )browser:(id)browser didReceiveScriptMessage:(id)message;

@optional

-(id)browerCallBack:(id)browser didReceiveScriptMessage:(id)message;


@end
