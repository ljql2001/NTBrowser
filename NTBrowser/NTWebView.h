//
//  NTWebView.h
//  NTBrowser
//
//  Created by Li Jun on 2019/6/17.
//  Copyright © 2019 Nextop.CN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NTWebViewDelegate <NSObject>
- (void)webviewDidOpenPopupWindow;
@end

@interface NTWebView : UIView

@property(nonatomic, assign) id<NTWebViewDelegate> delegate;
- (void)loadRequestWithUrl:(NSString *)strUrl;

@end

NS_ASSUME_NONNULL_END
