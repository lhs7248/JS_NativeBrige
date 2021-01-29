//
//  LSWKMessageHandler.m
//  LSHybirdPage
//
//  Created by lhs7248 on 2021/1/28.
//

#import "LSWKMessageHandler.h"

@implementation LSWKMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSDictionary *parameter = message.body;
    if([message.name isEqualToString:@"insertLayer"]){
        [self findChildView:[message.webView subviews] tagId:parameter[@"tagId"] src:parameter[@"src"]];
    }
    
}



- (void)findChildView:(NSArray *)list tagId: (NSNumber *)tagId src:(NSString *)src {
    for (int i = 0; i < [list count]; i++) {
        UIView *obj = list[i];
        NSLog(@"%@", [obj class]);
        if ([[NSString stringWithFormat:@"%@", [obj class]] isEqualToString:@"WKChildScrollView"] && tagId.doubleValue == obj.bounds.size.height) {
            UIScrollView * scroll = (UIScrollView *)obj;
            scroll.scrollEnabled = NO;
            [scroll setCanCancelContentTouches:NO];
            
            
        } else if ([obj isKindOfClass:[UIView class]]) {
            [self findChildView: [obj subviews] tagId:tagId src:src];
        }
    }
    
}
@end
