//
//  LSDataBrigeManger.h
//  JS_NativeBrige
//
//  Created by lhs7248 on 2017/8/8.
//  Copyright © 2017年 lhs7248. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSBrigeProtocol.h"
#import "LSWebViewController.h"

//遵守相关的协议
@interface LSDataBrigeManger : NSObject

// 初始化 相关的Manager
-(instancetype)initWithWebVC:(LSWebViewController *)webVC;

//
- (void)addPlugin:(id<LSBrigeProtocol>)plugin;

- (id<LSBrigeProtocol>)getPlugin:(NSString *)name;

- (void)addDefaultPlugins;

@end
