//
//  HLTextField.m
//  HLAlertView
//
//  Created by benjaminlmz@qq.com on 2020/5/6.
//  Copyright © 2020 Tony. All rights reserved.
//

#import "HLTextField.h"

@implementation HLTextField
- (id)init {
    self = [super init];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.model = [[HLAlertModel alloc] init];
        
        self.model.height = 30;
        self.borderStyle = UITextBorderStyleRoundedRect;
    }
    return self;
}

@end
