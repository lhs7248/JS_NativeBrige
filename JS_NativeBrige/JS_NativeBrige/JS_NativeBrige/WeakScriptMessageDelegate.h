//
//  WeakScriptMessageDelegate.h
//  JS_NativeBrige
//
//  Created by lhs7248 on 2019/5/15.
//  Copyright © 2019 lhs7248. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>
@property(nonatomic,weak) id<WKScriptMessageHandler>scriptDelegate;

-(instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scripteDelegate;

@end

NS_ASSUME_NONNULL_END
