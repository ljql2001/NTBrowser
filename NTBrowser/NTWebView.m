//
//  NTWebView.m
//  NTBrowser
//
//  Created by Li Jun on 2019/6/17.
//  Copyright © 2019 Nextop.CN. All rights reserved.
//

#import "NTWebView.h"
#import "Global.h"
#import "WKWebView+LongPress.h"

#define kEstimatedProgress @"estimatedProgress"

@interface NTWebView ()<WKUIDelegate, WKNavigationDelegate>

@property(nonatomic, retain) UIProgressView *viProgress;
@property(nonatomic, retain) WKWebView *wkWebview;
@property(nonatomic, retain) UIActivityIndicatorView *viIndicator;

@end

@implementation NTWebView

- (void)dealloc {
    [self.wkWebview removeObserver:self forKeyPath:kEstimatedProgress];
}

- (void)createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration {
    
    self.viProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 2)];
    self.viProgress.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    self.viProgress.progressTintColor = UIColor.orangeColor;
    self.viProgress.trackTintColor = UIColor.whiteColor;
    self.viProgress.progress = 0.0;
    [self addSubview:self.viProgress];
    
    if (configuration == nil) {
        configuration = [[WKWebViewConfiguration alloc] init];
    }
    self.wkWebview = [[WKWebView alloc] initWithFrame:self.bounds configuration:configuration];
    self.wkWebview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self insertSubview:self.wkWebview belowSubview:self.viProgress];
    
    self.wkWebview.UIDelegate = self;
    self.wkWebview.navigationDelegate = self;
    self.wkWebview.allowsBackForwardNavigationGestures = true;
    self.wkWebview.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true;
    [self.wkWebview addGestureRecognizerObserverWebElements:nil];
    [self.wkWebview addObserver:self forKeyPath:kEstimatedProgress options:NSKeyValueObservingOptionNew context:nil];
    
    self.viIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.viIndicator.bounds = CGRectMake(0, 0, 30, 30);
    self.viIndicator.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    self.viIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:self.viIndicator];
    self.viIndicator.hidden = YES;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createWebViewWithConfiguration:nil];
    }
    return self;
}

- (instancetype)initWithConfiguration:(WKWebViewConfiguration *)configuration {
    self = [super init];
    if (self) {
        [self createWebViewWithConfiguration:configuration];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self createWebViewWithConfiguration:nil];
}

- (void)loadRequestWithUrl:(NSString *)strUrl {
    if (strUrl.length > 0) {
        NSURL *url = [[NSURL alloc] initWithString:strUrl];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [self.wkWebview loadRequest:request];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kEstimatedProgress]) {
        self.viProgress.progress = self.wkWebview.estimatedProgress;
        if (self.viProgress.progress == 1) {
            self.viProgress.hidden = YES;
        } else {
            self.viProgress.hidden = NO;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - <WKUIDelegate>
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    if (!navigationAction.targetFrame.isMainFrame) {
        if ([self.delegate respondsToSelector:@selector(webviewDidPopupWebView:)]) {
            NTWebView *webview = [[NTWebView alloc] initWithConfiguration:configuration];
            [self.delegate webviewDidPopupWebView:webview];
            return webview.wkWebview;
        }
    }
    
    return nil;
}

#pragma mark - <WKNavigationDelegate>
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSLog(@"url=%@", navigationAction.request.URL.absoluteString);
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    self.viIndicator.hidden = NO;
    [self.viIndicator startAnimating];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.viIndicator stopAnimating];
    self.viIndicator.hidden = YES;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.viIndicator stopAnimating];
    self.viIndicator.hidden = YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self.viIndicator stopAnimating];
    self.viIndicator.hidden = YES;
}

@end
