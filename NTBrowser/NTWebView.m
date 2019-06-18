//
//  NTWebView.m
//  NTBrowser
//
//  Created by Li Jun on 2019/6/17.
//  Copyright © 2019 Nextop.CN. All rights reserved.
//

#import "NTWebView.h"
#import "Global.h"

#define kEstimatedProgress @"estimatedProgress"

@interface NTWebView ()<WKUIDelegate, WKNavigationDelegate>

@property(nonatomic, retain) UIProgressView *viProgress;
@property(nonatomic, retain) WKWebView *wkWebview;

@end

@implementation NTWebView

- (void)dealloc {
    [self.wkWebview removeObserver:self forKeyPath:kEstimatedProgress];
}

- (void)createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration {
    
    self.viProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 2)];
    self.viProgress.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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
    [self.wkWebview addObserver:self forKeyPath:kEstimatedProgress options:NSKeyValueObservingOptionNew context:nil];
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

@end
