//
//  ViewController.m
//  BMExport
//
//  Created by ___liangdahong on 2017/12/8.
//  Copyright © 2017年 ___liangdahong. All rights reserved.
//

#import "ViewController.h"
#import "BMModelManager.h"
#import "BMMySettingVC.h"
#import "BMCodeFormattingVC.h"
#import <PINCache/PINCache.h>

@interface ViewController () <NSTextViewDelegate>

@property (unsafe_unretained) IBOutlet NSTextView *jsonTextView;
@property (unsafe_unretained) IBOutlet NSTextView *modelTextView;
@property (nonatomic, assign) BOOL add; ///< <#Description#>
@property (nonatomic, assign) BOOL alignment; ///< <#Description#>
@property (nonatomic, strong) PINCache *pinCache; ///< <#Description#>

@end

@implementation ViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    _jsonTextView.automaticQuoteSubstitutionEnabled = NO;
    _modelTextView.automaticQuoteSubstitutionEnabled = NO;
    _pinCache = [[PINCache alloc] initWithName:@"setting"];
    NSNumber *addNum =  [_pinCache objectForKey:@"add"];
    if (addNum) {
        _add = addNum.boolValue;
    } else {
        _add = YES;
    }

    NSNumber *alignmentNum =  [_pinCache objectForKey:@"alignment"];
    if (alignmentNum) {
        _alignment = alignmentNum.boolValue;
    } else {
        _alignment = YES;
    }
}

- (void)textViewDidChangeSelection:(NSNotification *)notification {
    __block NSMutableString *string = @"".mutableCopy;
    NSError *error = [BMModelManager  propertyStringWithJson:self.jsonTextView.string clasName:@"RootClass" block:^(NSString *str) {
        [string appendString:@"\n\n\n"];
        [string appendString:str];        
        self.modelTextView.string = string;
    } add:_add alignment:_alignment];
    if (error) {
        self.modelTextView.string = error.domain;
    }
}

- (IBAction)settingButtonClick:(id)sender {
    BMMySettingVC *vc = [BMMySettingVC new];
    vc.add = _add;
    vc.alignment = _alignment;
    vc.block = ^(BOOL add, BOOL alignment) {
        self.add = add;
        self.alignment = alignment;
        self.jsonTextView.string = self.jsonTextView.string;
        [_pinCache setObject:@(add) forKey:@"add"];
        [_pinCache setObject:@(alignment) forKey:@"alignment"];
    };
    [self presentViewControllerAsModalWindow:vc];
}

- (IBAction)codeFormattingClick:(id)sender {
    [self presentViewControllerAsModalWindow:BMCodeFormattingVC.new];
}

@end
