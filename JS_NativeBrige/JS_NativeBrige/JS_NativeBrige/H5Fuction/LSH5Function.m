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
-(void)showTestTost:(NSString *)testTostStr;
-(void)showBigData:(NSDictionary*)bigDict;
- (NSString *)getCurrentLocation;

@end

@interface LSH5Function () <LSH5FunctionDelegate>
@property(nonatomic,strong)UIView * view;
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

    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:toastStr];
        [SVProgressHUD dismissWithDelay:3];
    });
}

-(void)showTestTost:(NSString *)testTostStr{
    
    NSLog(@"showTost:%@",testTostStr);
}

-(void)showBigData:(NSDictionary*)bigDict{
    NSString * imageBase64 = bigDict[@"image"];
    NSRange  range = [imageBase64 rangeOfString:@"data:image/jpeg;base64,"];
    NSString * base64 = [imageBase64 substringFromIndex:range.length];
    NSData *decodedImageData = [[NSData alloc]
                                initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showImage:decodedImage dateLenth:[NSString stringWithFormat:@"%ld",base64.length/(1024 * 1024)]];
    });
}


-(void)showImage:(UIImage *)image dateLenth:(NSString *)imageDatalength{
    
    UIView * view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 100, ([UIScreen mainScreen].bounds.size.width - 100), ([UIScreen mainScreen].bounds.size.height - 300))];
    imageView.image = image;
    [view addSubview:imageView];
    
    UILabel * labe = [[UILabel alloc]initWithFrame:CGRectMake(50,([UIScreen mainScreen].bounds.size.height - 200) , 300, 40)];
    labe.font = [UIFont systemFontOfSize:12];
    labe.text = [NSString stringWithFormat:@"传递image字符串长度：%@M",imageDatalength];
    [view addSubview:labe];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)]];
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    
    
}

-(void)removeView{
    [self.view removeFromSuperview];
}

- (NSString *)getCurrentLocation {

  return @"北京大院";
}

@end
