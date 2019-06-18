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

@interface ViewController ()<UITextFieldDelegate, NTWebViewDelegate>

@property(nonatomic, retain) NSMutableArray<NTWebView *> *allWebViews;
@property(nonatomic, assign) IBOutlet UIView *viHeaderBG;
@property(nonatomic, assign) IBOutlet UIView *viNavBar;
@property(nonatomic, assign) IBOutlet UITextField *tfUrlField;
@property(nonatomic, assign) IBOutlet UIButton *btnGo;
@property(nonatomic, assign) IBOutlet UIView *viContent;
@property(nonatomic, assign) IBOutlet UIView *viKeyboardMask;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tfUrlField.delegate = self;
    self.allWebViews = [[NSMutableArray alloc] initWithCapacity:0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(viKeyboardMaskDidTap:)];
    [self.viKeyboardMask addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UIKeyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UIKeyboardDidShowNotification:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UIKeyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UIKeyboardDidHideNotification:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)doBrowseWithUrlString:(NSString *)strUrl {
    if (strUrl.length > 0) {
        NTWebView *webview = [[NTWebView alloc] init];
        webview.delegate = self;
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
    webview.frame = self.viContent.bounds;
    webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.viContent addSubview:webview];
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.tfUrlField resignFirstResponder];
    [self doBrowseWithUrlString:textField.text];
    return YES;
}

#pragma mark - UIButton Action
- (IBAction)viKeyboardMaskDidTap:(id)sender {
    [self.tfUrlField resignFirstResponder];
}

- (IBAction)btnGoDidClick:(id)sender {
    [self doBrowseWithUrlString:self.tfUrlField.text];
}

#pragma mark - <NTWebViewDelegate>
- (void)webviewDidPopupWebView:(NTWebView *)webview {
    webview.delegate = self;
    [self pushWebview:webview];
}

- (void)UIKeyboardWillShowNotification:(NSNotification *)notification {
    NSLog(@"%s notification=%@", __func__, notification);
    self.viKeyboardMask.alpha = 0.0;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.viKeyboardMask.alpha = 0.4f;
                     } completion:nil];
}

- (void)UIKeyboardDidShowNotification:(NSNotification *)notification { }

- (void)UIKeyboardWillHideNotification:(NSNotification *)notification {
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.viKeyboardMask.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)UIKeyboardDidHideNotification:(NSNotification *)notification { }

@end
