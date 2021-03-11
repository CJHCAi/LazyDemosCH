//
//  HLImageView.m
//  HLAlertView
//
//  Created by benjaminlmz@qq.com on 2020/5/7.
//  Copyright © 2020 Tony. All rights reserved.
//

#import "HLImageView.h"
@interface HLImageView()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic ,strong) Constraint *constraint;
@property (nonatomic ,strong) HLImageViewModel *imageViewModel;
@end

@implementation HLImageView

- (id)init {
    self = [super init];
    if (self) {
        self.constraint = [[Constraint alloc] init];
        self.imageViewModel = [[HLImageViewModel alloc] init];
        self.imageView = [[UIImageView alloc] init];
    }
    return self;
}

+ (instancetype)imageViewWithImage:(UIImage *)image block:(void(^)(Constraint *,HLImageViewModel *))block {
    if (image == nil) {
        return nil;
    }
    HLImageView *object = [[HLImageView alloc] init];
    object.imageView.image = image;
    [object.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    block(object.constraint,object.imageViewModel);
    return object;
}
@end
