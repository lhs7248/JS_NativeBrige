//
//  LSBrigeMessage.h
//  LSWKWebView
//
//  Created by lhs7248 on 2021/1/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSBrigeMessage : NSObject


/// 模块名称
@property(nonatomic, copy) NSString * moduelName;

/// 方法名称
@property(nonatomic, copy) NSString * methodName;

/// 方法名称
@property(nonatomic, copy) NSString * callbackId;




@end

NS_ASSUME_NONNULL_END
