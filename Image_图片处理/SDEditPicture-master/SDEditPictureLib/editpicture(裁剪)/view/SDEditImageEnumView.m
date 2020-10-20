//
//  SDEditImageEnumView.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/18.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDEditImageEnumView.h"

#import "SDEditImageEnumModel.h"
#import "AppFileComment.h"

@implementation SDEditImageEnumView

- (instancetype)initWithEditEnumModel:(SDEditImageEnumModel *)model withSize:(CGSize)size
{
    self = [super init];
    if (self) {
        self.frame = (CGRect){self.frame.origin,size};
        _editModel = model;
        [self displayEditView];
    }
    return self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.editModel.done_subject sendNext:self.editModel];
    
}



- (void)displayEditView
{
    if (self.editModel.photoAction == SDEditPhotoMainReset) {
        [self displayMainResetEditView];
    }else if (self.editModel.photoAction == SDEditPhotoMainFilter || self.editModel.photoAction == SDEditPhotoFilter){
        [self displayEditImageView];
    }else if (self.editModel.photoAction == SDEditPhotoMainCut || self.editModel.photoAction == SDEditPhotoCut){
        [self displayEditImageView];

    }else if (self.editModel.photoAction == SDEditPhotoMainDecorate){
        [self displayEditImageView];

    }else if (self.editModel.photoAction == SDEditPhotoMainGraffiti){
        [self displayEditImageView];
    }else if (self.editModel.photoAction == SDEditPhotoCancel){
        [self displayCancelEditView];
    }else if (self.editModel.photoAction == SDEditPhotoSure){
        [self displaySureEditView];
    }else if (self.editModel.photoAction == SDEditPhotoTag){
        [self displayEditImageView];
    }else if (self.editModel.photoAction == SDEditPhotoDecorate){
        [self displayEditImageView];
    }else if (self.editModel.photoAction == SDEditPhotoBrush){
        [self displayEditImageView];
    }else if (self.editModel.photoAction == SDEditPhotoEraser){
        [self displayEditImageView];
    }
    
}
- (void)displayMainResetEditView
{
    self.showIconImageView.backgroundColor = [UIColor colorWithHexRGB:0xf6f6fa];
    self.showEnumLabel.textColor = [UIColor colorWithHexRGB:0x757575];
    self.showEnumLabel.text = self.editModel.enumText;
    CGSize size = [self.showEnumLabel.text sizeWithAttributes:@{NSFontAttributeName:self.showEnumLabel.font}];
    
    self.showIconImageView.frame = CGRectMake(0, 0, size.width + MAXSize(60), MAXSize(82));
    
    self.showIconImageView.center = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f);
    
    self.showEnumLabel.frame = CGRectMake(0, 0, size.width, size.height);
    
    self.showEnumLabel.center = CGPointMake(self.bounds.size.width / 2.f , self.bounds.size.height / 2.f);
    
    self.showIconImageView.layer.masksToBounds = YES;
    self.showIconImageView.layer.cornerRadius = MAXSize(82) / 2.f;
}

- (void)displayEditImageView
{
    self.showIconImageView.image = [UIImage imageNamed:self.editModel.imageLink];
    
    self.showIconImageView.frame = CGRectMake(0, 0, MAXSize(46), MAXSize(46));
    
    self.showEnumLabel.text = self.editModel.enumText;
    self.showEnumLabel.textColor = [UIColor colorWithHexRGB:0x757575];
    
    CGSize size = [self.showEnumLabel.text sizeWithAttributes:@{NSFontAttributeName:self.showEnumLabel.font}];

    self.showEnumLabel.frame = (CGRect){CGPointZero,size};
    
    self.showIconImageView.center = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f - size.height / 2.f - MAXSize(10));
    
    self.showEnumLabel.center = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f + MAXSize(46) / 2.f + MAXSize(10));

}

- (void)displayCancelEditView
{
    NSString * imageLink = [AppFileComment imagePathStringWithImagename:@"close_icon@2x"];
    self.showIconImageView.image = [UIImage imageNamed:imageLink];
    
    self.showIconImageView.frame = CGRectMake(0, 0, MAXSize(48), MAXSize(48));
    
    self.showIconImageView.center = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height /2.f);
    
}
- (void)displaySureEditView
{
    NSString * imageLink = [AppFileComment imagePathStringWithImagename:@"sure_icon@2x"];
    
    self.showIconImageView.image = [UIImage imageNamed:imageLink];
    
    self.showIconImageView.frame = CGRectMake(0, 0, MAXSize(48), MAXSize(48));
    
    self.showIconImageView.center = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height /2.f);
}



- (UIImageView *)showIconImageView
{
    if (!_showIconImageView) {
        UIImageView * theView = [[UIImageView alloc] init];
        [self addSubview:theView];
        
        _showIconImageView = theView;
    }
    return _showIconImageView;
}

- (UILabel *)showEnumLabel
{
    if (!_showEnumLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self addSubview:theView];
        theView.font = [UIFont systemFontOfSize: DFont(36)];
        
        _showEnumLabel = theView;
    }
    return _showEnumLabel;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
