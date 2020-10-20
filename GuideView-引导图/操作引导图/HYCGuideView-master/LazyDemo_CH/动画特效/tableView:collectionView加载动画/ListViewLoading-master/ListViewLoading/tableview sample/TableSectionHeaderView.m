//
//  TableSectionHeaderView.m
//  ListViewLoading
//
//  Created by 刘江 on 2019/10/14.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import "TableSectionHeaderView.h"

@implementation TableSectionHeaderView

- (UIImageView *)cover {
    if (!_cover) {
        _cover = [self findTag:101 view:self];
    }
    return _cover;
}

- (UIImageView *)logo {
    if (!_logo) {
        _logo = [self findTag:102 view:self];
    }
    return _logo;
}

- (UILabel *)name {
    if (!_name) {
         _name = [self findTag:103 view:self];
    }
    return _name;
}

- (UILabel *)job {
    if (!_job) {
         _job = [self findTag:104 view:self];
    }
    return _job;
}

- (__kindof UIView *)findTag:(NSInteger)tag view:(UIView *)view {
    if (view.tag == tag) {
        return view;
    }
    for (UIView *sub in view.subviews) {
        if (sub.tag == tag) {
            return sub;
        }else if (sub.subviews.count > 0) {
            return [self findTag:tag view:sub];
        }
    }
    return nil;
}

@end
