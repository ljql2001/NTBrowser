//
//  ViewController.m
//  NTBrowser
//
//  Created by Li Jun on 2019/6/17.
//  Copyright © 2019 Nextop.CN. All rights reserved.
//

#import "ViewController.h"
#import "Global.h"
#import "NTWebView.h"

@interface ViewController ()<UITextFieldDelegate> {
    
    IBOutlet UIView *viHeaderBG;
    IBOutlet UIView *viNavBar;
    IBOutlet UITextField *tfUrlField;
    IBOutlet UIButton *btnGo;
    IBOutlet UIView *viContent;
}

@property(nonatomic, retain) NSMutableArray<NTWebView *> *allWebViews;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    tfUrlField.delegate = self;
    self.allWebViews = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)doBrowseWithUrlString:(NSString *)strUrl {
    if (strUrl.length > 0) {
        NTWebView *webview = [[NTWebView alloc] init];
        [self pushWebview:webview];
        [self.allWebViews.lastObject loadRequestWithUrl:strUrl];
    }
}

- (void)pushWebview:(NTWebView *)webview {
    [self.allWebViews addObject:webview];
    [webview addBorderWithColor:UIColor.blackColor];
    webview.layer.shadowRadius = 10.0;
    webview.layer.shadowColor = UIColor.blackColor.CGColor;
    webview.layer.shadowOpacity = 0.8;
    webview.layer.shadowOffset = CGSizeMake(10.0, 10.0);
    webview.frame = viContent.bounds;
    webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [viContent addSubview:webview];
    if (self.allWebViews.count > 1) {
        webview.alpha = 0.5;
        webview.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            webview.transform = CGAffineTransformIdentity;
            webview.alpha = 1.0;
        } completion:nil];
    }
    
    //self.updateBtnRetreatState()
}

#pragma mark - <UITextFieldDelegate>
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self doBrowseWithUrlString:textField.text];
}

#pragma mark - UIButton Action
- (IBAction)btnGoDidClick:(id)sender {
    [self doBrowseWithUrlString:tfUrlField.text];
}

@end
