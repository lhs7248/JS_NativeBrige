//
//  WeakScriptMessageDelegate.m
//  JS_NativeBrige
//
//  Created by lhs7248 on 2019/5/15.
//  Copyright © 2019 lhs7248. All rights reserved.
//

#import "WeakScriptMessageDelegate.h"

@implementation WeakScriptMessageDelegate
-(instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scripteDelegate{
    self = [super init];
    if (self) {
        _scriptDelegate = scripteDelegate;
    }
    return self;
}
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
