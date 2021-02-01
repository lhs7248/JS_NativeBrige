//
//  LSWKWebView.m
//  LSHybirdPage
//
//  Created by lhs7248 on 2021/1/28.
//

#import "LSWKWebView.h"
#import "LSWKMessageHandler.h"
#import "LSMapViewPlugin.h"
#import <MapKit/MapKit.h>


@interface LSWKWebView()<WKNavigationDelegate>


@end


@implementation LSWKWebView

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration{
    self = [super initWithFrame:frame configuration:[LSWKWebView createWKWebViewConfiguration]];
    if (self) {
        self.navigationDelegate = self;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (WKWebViewConfiguration *)createWKWebViewConfiguration{
    
    static WKProcessPool * shareProcessPool = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        shareProcessPool = [[WKProcessPool alloc] init];
    });
    
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
    config.processPool = shareProcessPool;
    
    config.userContentController = [[WKUserContentController alloc] init];
    
    [config.userContentController addScriptMessageHandler:[[LSWKMessageHandler alloc] init] name:@"insertLayer"];
    
    return config;
}


#pragma  mark  重写hitTest 方法

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView * view = [super hitTest:point withEvent:event];
    
    //3种状态无法响应事件
    if (self.userInteractionEnabled == NO || self.hidden == YES ||  self.alpha <= 0.01) return nil;
    
     //触摸点若不在当前视图上则无法响应事件
     if ([self pointInside:point withEvent:event] == NO) return nil;
    
    if ([view isKindOfClass:NSClassFromString(@"WKChildScrollView")]) {
        
        NSInteger childCount = view.subviews.count;
        
        for (int i = 0;  i < childCount; i ++) {
            
            UIView * childView = view.subviews[i];
            CGPoint childP = [self convertPoint:point toView:childView];
            UIView *fitView = [view hitTest:childP withEvent:event];
            if (fitView) {
                return fitView;
            }
        }
    }
    return view;
}




- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    MKMapView * mapview = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 301)];
//    mapview.mapType = MKMapTypeHybrid;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self findChildView:[webView  subviews] tagId:@"301" src:@"" callBack:^(UIScrollView *targetView) {
//            [LSMapViewPlugin inserWebView:webView targetView:targetView params:nil];
            [targetView addSubview:mapview];
            
        }];
    });
    
}



- (void)findChildView:(NSArray *)list tagId: (NSNumber *)tagId src:(NSString *)src callBack:(void(^)(UIScrollView * targetView))callBack{
    for (int i = 0; i < [list count]; i++) {
        UIView *obj = list[i];
        NSLog(@"%@", [obj class]);
        if ([[NSString stringWithFormat:@"%@", [obj class]] isEqualToString:@"WKChildScrollView"] && tagId.doubleValue == obj.bounds.size.height) {
            NSLog(@"%@", [obj class]);
            UIScrollView * scroll = (UIScrollView *)obj;
            scroll.scrollEnabled = NO;
            scroll.showsVerticalScrollIndicator = NO;
            scroll.showsHorizontalScrollIndicator = NO;
            [scroll setCanCancelContentTouches:NO];
            callBack(scroll);
            return;

        } else if ([obj isKindOfClass:[UIView class]]) {
            [self findChildView:[obj subviews] tagId:tagId src:src callBack:callBack];
        }
    }
    
}
@end
