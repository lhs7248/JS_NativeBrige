//
//  LSH5Function.m
//  JS_NativeBrige
//
//  Created by lhs7248 on 2019/3/26.
//  Copyright © 2019 lhs7248. All rights reserved.
//

#import "LSH5Function.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <SVProgressHUD/SVProgressHUD.h>

@protocol LSH5FunctionDelegate <JSExport>

- (void)showTost:(NSString *)toastStr;
-(void)showArray:(NSArray *)toastArray;
-(void)showDict:(NSDictionary *)toastDict;
- (NSString *)getCurrentLocation;

@end

@interface LSH5Function () <LSH5FunctionDelegate>

@end

@implementation LSH5Function

-(void)showDict:(NSDictionary *)toastDict{
    
    NSData * data =  [NSJSONSerialization dataWithJSONObject:toastDict options:0 error:nil];
    NSString * toast = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:toast];
        [SVProgressHUD dismissWithDelay:3];
    });
}
-(void)showArray:(NSArray *)toastArray{
    
    NSData * data =  [NSJSONSerialization dataWithJSONObject:toastArray options:0 error:nil];
    NSString * toast = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:toast];
        [SVProgressHUD dismissWithDelay:3];
    });
}
- (void)showTost:(NSString *)toastStr {
    NSLog(@"showTost:%@",toastStr);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [SVProgressHUD showWithStatus:toastStr];
//        [SVProgressHUD dismissWithDelay:3];
//    });
}

- (NSString *)getCurrentLocation {

  return @"北京大院";
}

@end
