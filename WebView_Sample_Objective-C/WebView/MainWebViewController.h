//
//  MainWebViewController.h
//  WebView_Sample_Objective-C
//
//  Created by Sarah Jeong on 7/5/24.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainWebViewController : UIViewController <WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) UIView * containerView;
@property (nonatomic, strong) WKWebView * mainWebView;
@property (nonatomic, strong) WKProcessPool *sharedProcessPool;

@end

NS_ASSUME_NONNULL_END
