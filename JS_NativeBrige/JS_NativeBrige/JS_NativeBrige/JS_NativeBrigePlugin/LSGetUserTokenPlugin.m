//
//  LSGetUserTokenPlugin.m
//  JS_NativeBrige
//
//  Created by lhs7248 on 2017/8/9.
//  Copyright © 2017年 lhs7248. All rights reserved.
//

#import "LSGetUserTokenPlugin.h"
#import <UIKit/UIKit.h>

@interface LSGetUserTokenPlugin()
@property(nonatomic,strong)UIView * view;
@end

@implementation LSGetUserTokenPlugin

-(NSString *)scriptMessageHandlerName{
    return @"getToken";
}

-(void)browser:(id)browser didReceiveScriptMessage:(id)message{
   
    
//    NSLog(@"WKWebViewProtocol:%@",message);
    [self showBigData:message];
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

-(id)browerCallBack:(id)browser didReceiveScriptMessage:(id)message{
   
    return @"上海 浦电路地铁站";
}


@end
