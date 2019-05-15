//
//  LSOpenBrowerPlugin.m
//  JS_NativeBrige
//
//  Created by lhs7248 on 2017/8/8.
//  Copyright © 2017年 lhs7248. All rights reserved.
//

#import "LSOpenBrowerPlugin.h"
#import <UIKit/UIKit.h>
#import <SVProgressHUD/SVProgressHUD.h>

@implementation LSOpenBrowerPlugin

-(NSString *)scriptMessageHandlerName{
    return @"openBrowser";
}


-(void )browser:(id)browser didReceiveScriptMessage:(id)message{
    
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

-(id)browerCallBack:(id)browser didReceiveScriptMessage:(id)message{
   
    return @"callBack";
}
@end
