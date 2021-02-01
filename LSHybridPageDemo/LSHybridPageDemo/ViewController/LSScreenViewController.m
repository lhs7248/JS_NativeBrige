//
//  ViewController.m
//  LSHybridPageDemo
//
//  Created by lhs7248 on 2021/1/28.
//

#import "LSScreenViewController.h"

#import <LSHybirdPage/LSHybirdPage.h>

@interface LSScreenViewController ()

@end

@implementation LSScreenViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    LSWKWebView * webView = [[LSWKWebView alloc]initWithFrame:CGRectMake(0, 80, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"map" ofType:@"html"];
    
    NSString *htmlString = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    
    [self.view addSubview:webView];
    
}


@end
