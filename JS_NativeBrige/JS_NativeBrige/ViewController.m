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
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (IBAction)webViewAction:(id)sender {
    
    
    LSWebViewController * WebVC = [LSWebViewController webBrowserWithConfiguration:NO];
    
    [self pushWebVC:WebVC fileName:@"webViewJSBrige"];
    
}
- (IBAction)wkWebViewAction:(id)sender {
    
    LSWebViewController * wkWebVC = [LSWebViewController webBrowserWithConfiguration:YES];
    
    [self pushWebVC:wkWebVC fileName:@"WKWebViewJSBrige"];

}
- (IBAction)WebviewWKWebView:(id)sender {
    LSWebViewController * WebVC = [LSWebViewController webBrowserWithConfiguration:NO];
    
    
    [self pushWebVC:WebVC fileName:@"JSBrige"];
}


-(void)pushWebVC:(LSWebViewController *)webVC fileName:(NSString *)fileName{
 
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:fileName
                                                          ofType:@"html"];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    [self.textField resignFirstResponder];
}

@end
