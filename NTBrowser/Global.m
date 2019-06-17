//
//  Global.m
//  NTBrowser
//
//  Created by Li Jun on 2019/6/17.
//  Copyright © 2019 Nextop.CN. All rights reserved.
//

#import "Global.h"

@implementation UIView(UILayout)
- (void)addBorderWithColor:(UIColor *)color {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 0.5;
}
@end

