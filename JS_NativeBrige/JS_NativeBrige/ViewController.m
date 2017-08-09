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

@end

@implementation ViewController

- (IBAction)webViewAction:(id)sender {
    
    
    LSWebViewController * WebVC = [LSWebViewController webBrowserWithConfiguration:YES];
    
    [self pushWebVC:WebVC];
    
}
- (IBAction)wkWebViewAction:(id)sender {
    
    LSWebViewController * wkWebVC = [LSWebViewController webBrowserWithConfiguration:YES];
    [self pushWebVC:wkWebVC];

}


-(void)pushWebVC:(LSWebViewController *)webVC{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"test"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];


//    [webVC loadHTMLString:htmlCont];
    [webVC loadHTMLString:htmlCont baseURl:baseURL];
    [self.navigationController pushViewController:webVC animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
