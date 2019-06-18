//
//  NTWebView.h
//  NTBrowser
//
//  Created by Li Jun on 2019/6/17.
//  Copyright © 2019 Nextop.CN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NTWebView;
@protocol NTWebViewDelegate <NSObject>
- (void)webviewDidPopupWebView:(NTWebView *)webview;
@end

@interface NTWebView : UIView

@property(nonatomic, assign) id<NTWebViewDelegate> delegate;
- (void)loadRequestWithUrl:(NSString *)strUrl;

@end

NS_ASSUME_NONNULL_END
