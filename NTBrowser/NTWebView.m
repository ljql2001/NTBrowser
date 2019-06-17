//
//  NTWebView.m
//  NTBrowser
//
//  Created by Li Jun on 2019/6/17.
//  Copyright © 2019 Nextop.CN. All rights reserved.
//

#import "NTWebView.h"
#import <WebKit/WebKit.h>
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

- (void)initWebView {
    
    self.viProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 2)];
    [self addSubview:self.viProgress];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    self.wkWebview = [[WKWebView alloc] initWithFrame:self.bounds configuration:configuration];
    self.wkWebview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self insertSubview:self.wkWebview belowSubview:self.viProgress];
    
    self.wkWebview.UIDelegate = self;
    self.wkWebview.navigationDelegate = self;
    self.wkWebview.allowsBackForwardNavigationGestures = true;
    self.wkWebview.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true;
    [self.wkWebview addObserver:self forKeyPath:kEstimatedProgress options:NSKeyValueObservingOptionNew context:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initWebView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initWebView];
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
    
//    if (!navigationAction.targetFrame.isMainFrame) {
//        let webview = WKWebView(frame: self.viBasicContent.bounds, configuration: configuration)
//        DispatchQueue.main.async(execute: {
//            self.pushWebview(webview)
//        })
//        return webview
//    }
    
    return nil;
}

@end
