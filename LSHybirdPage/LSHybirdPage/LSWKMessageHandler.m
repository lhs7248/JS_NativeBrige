//
//  LSWKMessageHandler.m
//  LSHybirdPage
//
//  Created by lhs7248 on 2021/1/28.
//

#import "LSWKMessageHandler.h"
#import "LSMapViewPlugin.h"



@implementation LSWKMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSDictionary *parameter = message.body;
    if([message.name isEqualToString:@"insertLayer"]){
      
        [self findChildView:[message.webView subviews] tagId:parameter[@"tagId"] src:parameter[@"src"] callBack:^(UIScrollView *targetView) {
            
            [LSMapViewPlugin inserWebView:message.webView targetView:targetView params:parameter];
            
        }];
    }
    
}



- (void)findChildView:(NSArray *)list tagId: (NSNumber *)tagId src:(NSString *)src callBack:(void(^)(UIScrollView * targetView))callBack{
    for (int i = 0; i < [list count]; i++) {
        UIView *obj = list[i];
        if ([[NSString stringWithFormat:@"%@", [obj class]] isEqualToString:@"WKChildScrollView"] && tagId.doubleValue == obj.bounds.size.height) {
            NSLog(@"%@", [obj class]);
            UIScrollView * scroll = (UIScrollView *)obj;
            scroll.scrollEnabled = NO;
            scroll.showsVerticalScrollIndicator = NO;
            scroll.showsHorizontalScrollIndicator = NO;
            [scroll setCanCancelContentTouches:NO];
            callBack(scroll);

        } else if ([obj isKindOfClass:[UIView class]]) {
            [self findChildView:[obj subviews] tagId:tagId src:src callBack:callBack];
        }
    }
    
}
@end
