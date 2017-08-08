//
//  LSOpenBrowerPlugin.m
//  JS_NativeBrige
//
//  Created by lhs7248 on 2017/8/8.
//  Copyright © 2017年 lhs7248. All rights reserved.
//

#import "LSOpenBrowerPlugin.h"
#import <UIKit/UIKit.h>


@implementation LSOpenBrowerPlugin

-(NSString *)scriptMessageHandlerName{
    return @"openBrowser";
}


-(void )browser:(id)browser didReceiveScriptMessage:(id)message{
    
    if ([message isKindOfClass:[NSString class]]) {
        NSString *urlParam = (NSString *)message;
        if (urlParam.length > 0) {
            
            BOOL isExsit = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlParam]];
            if(isExsit) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlParam]];
            }
        }
    }
    
}
@end
