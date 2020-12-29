//
//  HKImageAnnexCell.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKImageAnnexCell.h"

@interface HKImageAnnexCell ()

@property (nonatomic, weak) UILabel *tipLabel;

@property (nonatomic, weak) HKCellImagePickView *imagePickView;

@property (nonatomic, strong) NSString *tip;

@end

@implementation HKImageAnnexCell

//用静态方法使用这个 cell
+ (instancetype)imageAnnexCellWithDelegate:(UIViewController *)delegate
                                       tip:(NSString *)tip
                                    images:(NSMutableArray *)images
                        cellPickImageBlock:(void (^)(NSMutableArray<UIImage*> *pickImages))block{
    HKImageAnnexCell *cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self) delegate:delegate tip:tip images:images cellPickImageBlock:block];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     delegate:(UIViewController *)delegate
                          tip:(NSString *)tip
                       images:(NSMutableArray *)images
           cellPickImageBlock:(void (^)(NSMutableArray<UIImage *> *pickImages))block{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.images = images;
        self.delegate = delegate;
        self.tip = tip;
        self.CellPickImageBlock = block;
        [self setUpUI];
    }
    return self;
}

//网络图片
+ (instancetype)imageAnnexCellWithDelegate:(UIViewController *)delegate
                                       tip:(NSString *)tip
                                    images:(NSMutableArray *)images
                        cellPickImageBlock:(void (^)(NSMutableArray<UIImage*> *pickImages))block
                       DeleteNetImageBlock:(void (^)(HKEditResumeDataImgs *imageData)) delBlock{
    
    HKImageAnnexCell *cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self) delegate:delegate tip:tip images:images cellPickImageBlock:block DeleteNetImageBlock:delBlock];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     delegate:(UIViewController *)delegate
                          tip:(NSString *)tip
                       images:(NSMutableArray *)images
           cellPickImageBlock:(void (^)(NSMutableArray<UIImage *> *pickImages))block
          DeleteNetImageBlock:(void (^)(HKEditResumeDataImgs *imageData)) delBlock{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.images = images;
        self.delegate = delegate;
        self.tip = tip;
        self.CellPickImageBlock = block;
        self.deleteNetImageBlock = delBlock;
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    UILabel *tipLabel = [HKComponentFactory labelWithFrame:CGRectZero textColor:RGB(102,102,102) textAlignment:NSTextAlignmentLeft font:PingFangSCRegular14 text:self.tip supperView:self.contentView];
    self.tipLabel = tipLabel;
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(19);
        make.height.mas_equalTo(14);
    }];
 
    HKCellImagePickView *imagePickView = [HKCellImagePickView cellImagePickViewWithImages:self.images leftMargin:15 delegate:self.delegate];
    imagePickView.CellPickImageBlock = self.CellPickImageBlock;
    imagePickView.deleteNetImageBlock = self.deleteNetImageBlock;
    [self.contentView addSubview:imagePickView];
    self.imagePickView = imagePickView;
    
    [imagePickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.contentView);
        make.top.equalTo(self.tipLabel.mas_bottom).offset(15);
        make.bottom.equalTo(self.contentView).offset(-23);
    }];
}

@end
