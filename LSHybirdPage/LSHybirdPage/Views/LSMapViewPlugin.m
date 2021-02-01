//
//  LSMapViewPlugin.m
//  LSHybirdPage
//
//  Created by lhs7248 on 2021/1/29.
//

#import "LSMapViewPlugin.h"
#import <MapKit/MapKit.h>

@implementation LSMapViewPlugin


+ (void)inserWebView:(WKWebView *)webView targetView:(UIScrollView *)targetView params:(NSDictionary *)params{
    
    MKMapView * mapview = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 301)];
    mapview.mapType = MKMapTypeHybrid;
    [targetView addSubview:mapview];
    
}
@end
