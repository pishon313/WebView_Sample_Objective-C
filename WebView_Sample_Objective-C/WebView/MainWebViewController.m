//
//  MainWebViewController.m
//  WebView_Sample_Objective-C
//
//  Created by Sarah Jeong on 7/5/24.
//

#import "MainWebViewController.h"

@interface MainWebViewController ()

@end

@implementation MainWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - ContainerView SETTING
- (void)setContainerView {
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containerView];
    
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.containerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

- (void)setWebView {
    // Configure WKwebViewConfiguration
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    
    WKPreferences *preferences = [[WKPreferences alloc] init];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 10.0;
    
    WKWebpagePreferences *webpagePreferences = [[WKWebpagePreferences alloc] init];
    webpagePreferences.allowsContentJavaScript = YES;
    webpagePreferences.preferredContentMode = WKContentModeMobile;
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"messageHandler"];
    
    configuration.processPool = self.sharedProcessPool;
    configuration.preferences = preferences;
    configuration.defaultWebpagePreferences = webpagePreferences;
    configuration.userContentController = userContentController;
    
    self.mainWebView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mainWebView.UIDelegate = self;
    self.mainWebView.navigationDelegate = self;
    
    self.mainWebView.scrollView.showsVerticalScrollIndicator = YES;
    self.mainWebView.allowsBackForwardNavigationGestures = YES;
    self.mainWebView.allowsLinkPreview = YES;
    
    if(@available(iOS 16.4, *)) {
        self.mainWebView.inspectable = YES;
    }
    
    [NSLayoutConstraint activateConstraints:@[
        [self.mainWebView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor],
        [self.mainWebView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
        [self.mainWebView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
        [self.mainWebView.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor]
    ]];
    
    NSURL *url = [NSURL URLWithString:@"https://www.example.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.mainWebView loadRequest:request];
}

#pragma mark - WKScriptMessageHandler Method
-(void) userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"messageHandler"]) {
        if ([message.body isKindOfClass:[NSString class]]) {
            NSString *messageBody = (NSString *)message.body;
            NSLog(@"JavaScript message received: %@", messageBody);
            
            if ([messageBody isEqualToString:@"login"]) {
                NSLog(@"Login");
            } else if ([messageBody isEqualToString:@"logout"]) {
                NSLog(@"Logout");
            } else {
                NSLog(@"Unknown action");
            }
        }
    }
}


#pragma mark - WKNavigationDelegate Methods

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"Web view started loading content");
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"Received server redirect");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"Encountered load error: %@", error.localizedDescription);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"Navigation completed");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"Navigation failed: %@", error.localizedDescription);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"Web content process terminated");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"Navigation request: %@", navigationAction.request.URL.absoluteString ?: @"Unknown URL");
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
