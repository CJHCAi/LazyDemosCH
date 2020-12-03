//
//  YSStaticCellModel.m
//  YSStaticTableViewControllerDemo
//
//  Created by MOLBASE on 2018/7/18.
//  Copyright © 2018年 YangShen. All rights reserved.
//

#import "YSStaticCellModel.h"

#define YSImgWidth 30

static inline CGSize YSTitleSize(NSString *title, UIFont *font, CGFloat maxWidth) {
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(maxWidth, FLT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : font}
                                           context:nil];
    return titleRect.size;
}

@implementation YSStaticCellModel
- (instancetype)init {
    if (self = [super init]) {
        self.cellHeight     = 44;
        self.cellIdentifier = @"basicCell";
        self.cellClassName  = @"YSStaticTableViewCell";
        self.cellType       = YSStaticCellTypeAccessoryArrow;
    }
    return self;
}

- (void)setCellType:(YSStaticCellType)cellType {
    _cellType = cellType;
    
    if (cellType == YSStaticCellTypeButton) {
        self.cellIdentifier = @"buttonCell";
        self.cellClassName = @"YSStaticButtonCell";
    }
}

@end

@interface YSStaticDefaultModel ()
@property (nonatomic, readwrite, assign) BOOL showTitleImage;
@property (nonatomic, readwrite, assign) BOOL showIndicatorImage;
@property (nonatomic, readwrite, assign) CGSize titleSize;           ///< 左侧标题Size
@property (nonatomic, readwrite, assign) CGSize indicatorTitleSize;  ///< 右侧标题Size
@end

@implementation YSStaticDefaultModel {
    CGFloat   _titleMaxWidth;
}

- (instancetype)init {
    if (self = [super init]) {
        self.cellIdentifier      = @"defaultCell";
        self.cellClassName       = @"YSStaticDefaultCell";
        self.titleFont           = [UIFont systemFontOfSize:15];
        self.titleColor          = [UIColor blackColor];
        self.titleImageSize      = CGSizeMake(YSImgWidth, YSImgWidth);
        self.titleImageSpace     = 10;
        _titleMaxWidth           = 180;
        
        self.indicatorTitleFont  = [UIFont systemFontOfSize:13];
        self.indicatorTitleColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1];
        self.indicatorImageSize  = CGSizeMake(YSImgWidth, YSImgWidth);
        self.indicatorImageSpace = 6;
    }
    return self;
}

#pragma mark - setter
// 左侧
- (void)setTitle:(NSString *)title {
    if (_title == title || [_title isEqualToString:title]) return;
    
    _title = title;
    _titleSize = [self sizeForTitle:title withFont:self.titleFont];
    if (_titleSize.width > _titleMaxWidth) {
        _titleSize.width = _titleMaxWidth;
    }
}

- (void)setTitleFont:(UIFont *)titleFont {
    if (_titleFont == titleFont) return;
    
    _titleFont = titleFont;
    CGSize size = [self sizeForTitle:self.title withFont:titleFont];
    if (size.width > _titleSize.width && size.width < _titleMaxWidth) {
        _titleSize = size;
    }
}

- (void)setTitleImageName:(NSString *)titleImageName {
    if (_titleImageName == titleImageName) return;
    _titleImageName = titleImageName;
    self.showTitleImage = YES;
}

- (void)setTitleImageUrl:(NSString *)titleImageUrl {
    if (_titleImageUrl == titleImageUrl) return;
    _titleImageUrl = titleImageUrl;
    self.showTitleImage = YES;
}

// 右侧
- (void)setIndicatorTitle:(NSString *)indicatorTitle {
    if (_indicatorTitle == indicatorTitle || [_indicatorTitle isEqualToString:indicatorTitle]) return;
    
    _indicatorTitle = indicatorTitle;
    _indicatorTitleSize = [self sizeForTitle:indicatorTitle withFont:self.indicatorTitleFont];
    if (_indicatorTitleSize.width > _titleMaxWidth) {
        _indicatorTitleSize.width = _titleMaxWidth;
    }
}

- (void)setIndicatorTitleFont:(UIFont *)indicatorTitleFont {
    if (_indicatorTitleFont == indicatorTitleFont) return;
    
    _indicatorTitleFont = indicatorTitleFont;
    CGSize size = [self sizeForTitle:self.indicatorTitle withFont:indicatorTitleFont];
    if (size.width > _indicatorTitleSize.width && size.width < _titleMaxWidth) {
        _indicatorTitleSize = size;
    }
}

- (void)setIndicatorImageName:(NSString *)indicatorImageName {
    if (_indicatorImageName == indicatorImageName) return;
    _indicatorImageName = indicatorImageName;
    self.showIndicatorImage = YES;
}

- (void)setIndicatorImageUrl:(NSString *)indicatorImageUrl {
    if (_indicatorImageUrl == indicatorImageUrl) return;
    _indicatorImageUrl = indicatorImageUrl;
    self.showIndicatorImage = YES;
}


#pragma mark - help method
- (CGSize)sizeForTitle:(NSString *)title withFont:(UIFont *)font {
    return YSTitleSize(title, font, FLT_MAX);
}

@end
