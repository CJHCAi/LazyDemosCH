//
//  BMCodeFormattingVC.m
//  BMExport
//
//  Created by ___liangdahong on 2017/12/12.
//  Copyright © 2017年 ___liangdahong. All rights reserved.
//

#import "BMCodeFormattingVC.h"

@interface BMCodeFormattingVC ()

@property (weak) IBOutlet NSTextField *textField;

@end

@implementation BMCodeFormattingVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)codeFormattingClick1:(id)sender {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = self.textField.stringValue;
    // 深度遍历，会递归枚举它的内容
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:path];
    NSMutableArray <NSString *> *pasths = @[].mutableCopy;
    while ((path = [dirEnum nextObject]) != nil) {
        NSArray *arr = [path componentsSeparatedByString:@"/"];
        if (arr.count) {
            if (![[[arr lastObject] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"."]
                && ![[[arr firstObject] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"."]) {
                [pasths addObject:path];
            }
        }
    }
    [pasths enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", self.textField.stringValue, obj] encoding:NSUTF8StringEncoding error:NULL];
        if (str.length) {
            NSMutableString *mstr = str.mutableCopy;
            if ([mstr rangeOfString:@"___liangdahong"].location != NSNotFound) {
                while ([mstr replaceOccurrencesOfString:@"\n\n\n" withString:@"\n\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mstr.length)]);
                [mstr writeToFile:[NSString stringWithFormat:@"%@/%@", self.textField.stringValue, obj] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
            }
        }
    }];
}

@end
