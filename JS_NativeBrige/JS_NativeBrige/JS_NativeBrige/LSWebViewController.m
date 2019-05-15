//
//  LSWebViewController.m
//  JS_NativeBrige
//
//  Created by lhs7248 on 2017/8/8.
//  Copyright © 2017年 lhs7248. All rights reserved.
//

#import "LSWebViewController.h"
#import "LSDataBrigeManger.h"
#import <SVProgressHUD/SVProgressHUD.h>

static void *KINWebBrowserContext = &KINWebBrowserContext;

@interface LSWebViewController ()

@property (nonatomic, strong) UIBarButtonItem *closeButtonItem; //关闭按钮

@property (nonatomic, strong) LSDataBrigeManger *pluginManager;

@property (nonatomic, assign) BOOL canGoBack;

@end

@implementation LSWebViewController

+ (LSWebViewController *)webBrowser {
    LSWebViewController *webBrowserViewController =
      [LSWebViewController webBrowserWithConfiguration:nil];
    return webBrowserViewController;
}

+ (LSWebViewController *)webBrowserWithConfiguration:(BOOL)useWKWebView {
    LSWebViewController *webBrowserViewController =
      [[self alloc] initWithConfiguration:useWKWebView];
    return webBrowserViewController;
}

#pragma mark - Initializers

- (id)init {
    return [self initWithConfiguration:nil];
}

- (id)initWithConfiguration:(BOOL)useWKWebView {
    self = [super init];
    if (self) {
        if (useWKWebView) {
            WKWebViewConfiguration *configuration =
              [[WKWebViewConfiguration alloc] init];
            WKUserContentController *userContentController =
              [[WKUserContentController alloc] init];
            if (configuration) {
                configuration.userContentController = userContentController;
                self.wkWebView =
                  [[WKWebView alloc] initWithFrame:CGRectZero
                                     configuration:configuration];
            } else {
                configuration = [[WKWebViewConfiguration alloc] init];
                configuration.userContentController = userContentController;
                self.wkWebView =
                  [[WKWebView alloc] initWithFrame:CGRectZero
                                     configuration:configuration];
            }
            CGFloat topInset = 20;
            self.wkWebView.scrollView.layer.masksToBounds = NO;
            [self.wkWebView.scrollView
              setContentInset:UIEdgeInsetsMake(topInset, 0, 0, 0)];
            [self.wkWebView
              setFrame:CGRectMake(0, 0, self.wkWebView.bounds.size.width,
                                  self.wkWebView.bounds.size.height
                                    - topInset)];

            self.wkWebView.allowsBackForwardNavigationGestures = YES;
            
        } else {
            self.webView = [[UIWebView alloc] init];
        }
        //        self.showsURLInNavigationBar = NO;
        //        self.showsPageTitleInNavigationBar = YES;
        //        self.historyEnable = YES;

        //        self.externalAppPermissionAlertView = [[UIAlertView alloc]
        //        initWithTitle:@"Leave this app?" message:@"This web page is
        //        trying to open an outside app. Are you sure you want to open
        //        it?" delegate:self cancelButtonTitle:@"Cancel"
        //        otherButtonTitles:@"Open App", nil];
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.previousNavigationControllerNavigationBarHidden =
    //    self.navigationController.navigationBarHidden;

    // 初始化交互管理器
    self.pluginManager = [[LSDataBrigeManger alloc] initWithWebVC:self];

    if (self.wkWebView) {
        self.navigationItem.title = @"wkWebView";
        [self.wkWebView setFrame:self.view.bounds];
        [self.wkWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth |
                                            UIViewAutoresizingFlexibleHeight];
        [self.wkWebView setNavigationDelegate:self];
        [self.wkWebView setUIDelegate:self];
        [self.wkWebView setMultipleTouchEnabled:YES];
        [self.wkWebView setAutoresizesSubviews:YES];
        [self.wkWebView.scrollView setAlwaysBounceVertical:YES];
        [self.view addSubview:self.wkWebView];

        [_pluginManager addDefaultPlugins];
    } else if (self.webView) {

        self.navigationItem.title = @"webView";
        [self.webView setFrame:self.view.bounds];
        [self.webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth |
                                          UIViewAutoresizingFlexibleHeight];
        [self.webView setDelegate:self];
        [self.webView setMultipleTouchEnabled:YES];
        [self.webView setAutoresizesSubviews:YES];
        [self.webView setScalesPageToFit:YES];
        [self.webView.scrollView setAlwaysBounceVertical:YES];
        [self.view addSubview:self.webView];
    }

    if (self.navigationController) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationItem.leftBarButtonItems = nil;
        if ([self.navigationController.viewControllers indexOfObject:self]
            > 0) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                    initWithImage:[UIImage imageNamed:@"nav_btn_back_default"]
              landscapeImagePhone:nil
                            style:UIBarButtonItemStylePlain
                           target:self
                           action:@selector(goBack:)];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    /**
     *  如果是pop回上级页面，则恢复navigationController的状态
     */
    //    if (![self.navigationController.viewControllers containsObject:self])
    //    {
    //        [self.navigationController
    //        setNavigationBarHidden:self.previousNavigationControllerNavigationBarHidden
    //        animated:animated];
    //    }

    //    [self.uiWebView setDelegate:nil];
    //    [self.progressBar removeFromSuperview];
}

#pragma mark - Public Interface

- (void)loadRequest:(NSURLRequest *)request {
    if (self.wkWebView) {
        [self.wkWebView loadRequest:request];
    } else if (self.webView) {
        [self.webView loadRequest:request];
    }
}

- (void)loadURL:(NSURL *)URL {
    // webview的请求url添加token字段
    NSString *urlString = URL.absoluteString;

    [self loadRequest:[NSURLRequest requestWithURL:URL]];
}

- (void)loadURLString:(NSString *)URLString {
    NSURL *URL = [NSURL URLWithString:URLString];
    [self loadURL:URL];
}

- (void)loadHTMLString:(NSString *)HTMLString baseURl:(NSURL *)baseUrl {
    if (self.wkWebView) {
        [self.wkWebView loadHTMLString:HTMLString baseURL:baseUrl];
    } else if (self.webView) {
        [self.webView loadHTMLString:HTMLString baseURL:baseUrl];
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView
  shouldStartLoadWithRequest:(NSURLRequest *)request
              navigationType:(UIWebViewNavigationType)navigationType {
    NSURL * url = request.URL;
    if (webView == self.webView) {
        if ([url.scheme isEqualToString:@"ald"]) {
            NSString * urlStr = [url resourceSpecifier];
            [self showAlert:urlStr];
        }

    }
    return YES;
}
-(void)showAlert:(NSString * )urlStr {
    if ([[[urlStr componentsSeparatedByString:@"?"] firstObject] hasSuffix:@"showToast"]) {
        NSString * message = [[urlStr componentsSeparatedByString:@"?"] lastObject];
        NSString * messageStr = [[message componentsSeparatedByString:@"="] lastObject];
        NSString * decodeMessage =  [messageStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [SVProgressHUD showWithStatus:decodeMessage];
        [SVProgressHUD dismissWithDelay:3];
    }else{
        NSLog(@"protocol:%@",urlStr);
    }
    
    
    
  
}

// 网页开始加载后，注入交互方式
- (void)webViewDidStartLoad:(UIWebView *)webView {

    if (self.webView == webView) {
        [_pluginManager addDefaultPlugins];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView == self.webView) {
        //        [self checkWebViewCanGoBack];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (webView == self.webView) {
        //        if(!self.webView.isLoading) {
        //            self.uiWebViewIsLoading = NO;
        //            [self updateNavigationBarState];
        //
        //            [self fakeProgressBarStopLoading];
        //        }
        //        if([self.delegate
        //        respondsToSelector:@selector(webBrowser:didFailToLoadURL:error:)])
        //        {
        //            [self.delegate webBrowser:self
        //            didFailToLoadURL:self.uiWebView.request.URL error:error];
        //        }
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView
  didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (webView == self.wkWebView) {

        //        [self updateNavigationBarState];
        //
        //        self.progressBar.isLoading = YES;
        //        [self.progressBar progressUpdate:.05];
        //
        //        if([self.delegate
        //        respondsToSelector:@selector(webBrowser:didStartLoadingURL:)])
        //        {
        //            [self.delegate webBrowser:self
        //            didStartLoadingURL:self.wkWebView.URL];
        //        }
    }
}

- (void)webView:(WKWebView *)webView
  didFinishNavigation:(WKNavigation *)navigation {
    if (webView == self.wkWebView) {
        //        [self checkWebViewCanGoBack];
    }
}

- (void)webView:(WKWebView *)webView
  didFailProvisionalNavigation:(WKNavigation *)navigation
                     withError:(NSError *)error {
    if (webView == self.wkWebView) {
    }
}

- (void)webView:(WKWebView *)webView
  didFailNavigation:(WKNavigation *)navigation
          withError:(NSError *)error {
    if (webView == self.wkWebView) {
    }
}

- (void)webView:(WKWebView *)webView
  decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
                  decisionHandler:
                    (void (^)(WKNavigationActionPolicy))decisionHandler {
        if(webView == self.wkWebView) {
            NSURL *url = navigationAction.request.URL;
            if ([url.scheme isEqualToString:@"ald"]) {
                NSString * urlStr = [url resourceSpecifier];
                [self showAlert:urlStr];
            }
//            if(![self externalAppRequiredToOpenURL:URL]) {
//                if(!navigationAction.targetFrame) {
//                    [self loadURL:URL];
//                    decisionHandler(WKNavigationActionPolicyCancel);
//                    return;
//                }
//            }
//            else if([[UIApplication sharedApplication] canOpenURL:URL]) {
//    //             跳转到系统浏览器进行打开
//    //            [self launchExternalAppWithURL:URL];
//                decisionHandler(WKNavigationActionPolicyCancel);
//                return;
//            }
        }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - WKUIDelegate

#pragma mark - External App Support

- (BOOL)externalAppRequiredToOpenURL:(NSURL *)URL {
    NSSet *validSchemes = [NSSet setWithArray:@[ @"http", @"https" ]];
    return ![validSchemes containsObject:URL.scheme];
}

- (void)checkWebViewCanGoBack {
    if (self.canGoBack) {
        if (self.webView && [self.webView canGoBack]) {
            [self addSpaceButton];
        } else if (self.wkWebView && [self.wkWebView canGoBack]) {
            [self addSpaceButton];
        }
    }
}

- (void)goBack:(UIButton *)sender {
    if ([self gotoBack]) {
        [self closeItemClicked];
    }
}

- (BOOL)gotoBack {
    if (_canGoBack) {
        if (self.webView && [self.webView canGoBack]) {
            [self.webView goBack];
            [self addSpaceButton];
            return NO;
        } else if (_wkWebView && [_wkWebView canGoBack]) {
            if (self.backURL) { //为了答题游戏特意加的跳转特定网页
                for (WKBackForwardListItem *item in _wkWebView.backForwardList
                       .backList) {
                    if ([item.URL.absoluteString
                          isEqualToString:self.backURL]) {
                        [_wkWebView goToBackForwardListItem:item];
                    }
                }
            } else {
                [_wkWebView goBack];
            }
            [self addSpaceButton];
            return NO;
        }
    }
    return YES;
}

- (void)closeItemClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addSpaceButton {
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                           target:nil
                           action:nil];

    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"nav_btn_back_default"]
      landscapeImagePhone:nil
                    style:UIBarButtonItemStylePlain
                   target:self
                   action:@selector(goBack:)];

    self.navigationItem.leftBarButtonItems =
      @[ spaceButtonItem, backBarButtonItem, self.closeButtonItem ];
}

- (UIBarButtonItem *)closeButtonItem {
    if (!_closeButtonItem) {
        _closeButtonItem = [[UIBarButtonItem alloc]
          initWithImage:[UIImage imageNamed:@"nav_icon_close"]
                  style:UIBarButtonItemStylePlain
                 target:self
                 action:@selector(closeItemClicked)];
    }
    return _closeButtonItem;
}

@end
