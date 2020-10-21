//
//  WZMediaAssetBaseCell.m
//  WZPhotoPicker
//
//  Created by wizet on 2017/5/21.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZMediaAssetBaseCell.h"
#import "WZMediaFetcher.h"

@implementation WZMediaAssetBaseCell

- (void)prepareForReuse {
    self.imageView.image = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.contentView.layer.borderWidth = 1.0;
//        self.contentView.layer.borderColor = [UIColor blackColor].CGColor;
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = [UIColor lightGrayColor];
        _imageView.layer.masksToBounds = true;
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)clickedBtn:(UIButton *)sender {
    if (_asset) {
        if (_selectedBlock) {
            _selectedBlock(_asset.selected);
        }
    }
}

- (void)setAsset:(WZMediaAsset *)asset {
    if ([asset isKindOfClass:[WZMediaAsset class]]) {
        _asset = asset;
        self.selectButton.selected = _asset.selected;
        if (_asset.imageThumbnail) {
            self.imageView.image = _asset.imageThumbnail;
        } else {
            __weak typeof(self) weakSelf = self;
            [_asset fetchThumbnailImageSynchronous:false handler:^(UIImage *image) {
                 weakSelf.imageView.image = image;
            }];
        }
    }
}

#pragma mark - Accessor
- (UIButton *)selectButton {
    if (!_selectButton) {
        CGFloat selectedBtnHW = 33;
        _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - selectedBtnHW , 0, selectedBtnHW, selectedBtnHW)];
        [self.contentView addSubview:_selectButton];
        [_selectButton setImage:[UIImage imageNamed:@"message_oeuvre_btn_normal"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"message_oeuvre_btn_selected"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        _selectButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    return _selectButton;
}


@end
