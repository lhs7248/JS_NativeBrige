//
//  ViewController.m
//  JS_NativeBrige
//
//  Created by lhs7248 on 2017/8/8.
//  Copyright © 2017年 lhs7248. All rights reserved.
//

#import "ViewController.h"
#import "LSWebViewController.h"


@interface ViewController ()
@property(nonatomic,strong)LSWebViewController  * webVC;

@end

@implementation ViewController

- (IBAction)webViewAction:(id)sender {
    
    
}
- (IBAction)wkWebViewAction:(id)sender {
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"test"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [self.webVC.webView loadHTMLString:htmlCont baseURL:baseURL];
//    [self.webVC loadURLString:htmlPath];
    [self.webVC loadHTMLString:htmlCont];
    [self.navigationController pushViewController:self.webVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webVC = [[LSWebViewController alloc]init];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
