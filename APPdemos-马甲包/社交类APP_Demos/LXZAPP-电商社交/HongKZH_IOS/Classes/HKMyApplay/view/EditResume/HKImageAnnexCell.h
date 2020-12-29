//
//  HKImageAnnexCell.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCellImagePickView.h"
/*
    图片附件的 cell
 */
@interface HKImageAnnexCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, weak) UIViewController *delegate;

@property (nonatomic,copy) void (^CellPickImageBlock)(NSMutableArray<UIImage *> *pickImages);

@property (nonatomic, copy) DeleteNetImageBlock deleteNetImageBlock;


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     delegate:(UIViewController *)delegate
                          tip:(NSString *)tip
                       images:(NSMutableArray *)images
           cellPickImageBlock:(void (^)(NSMutableArray<UIImage *> *pickImages))block;

+ (instancetype)imageAnnexCellWithDelegate:(UIViewController *)delegate
                                       tip:(NSString *)tip
                                    images:(NSMutableArray *)images
                        cellPickImageBlock:(void (^)(NSMutableArray<UIImage*> *pickImages))block;

//有网络图片
+ (instancetype)imageAnnexCellWithDelegate:(UIViewController *)delegate
                                       tip:(NSString *)tip
                                    images:(NSMutableArray *)images
                        cellPickImageBlock:(void (^)(NSMutableArray<UIImage*> *pickImages))block
                       DeleteNetImageBlock:(void (^)(HKEditResumeDataImgs *imageData)) delBlock;

@end
