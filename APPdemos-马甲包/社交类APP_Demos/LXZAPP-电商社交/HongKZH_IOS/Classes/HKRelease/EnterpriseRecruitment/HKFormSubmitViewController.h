//
//  HKFormSubmitViewController.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"
#import "HK_SectionModel.h"
#import "HK_FormCell.h"
#import "HK_CardsCertificationViewController.h"
#import "ActionSheetStringPicker.h"
#import "VPImageCropperViewController.h"
#import "ImageTool.h"
#import "NSData+EasyExtend.h"
#import "GTMBase64.h"
#import "HK_SingleColumnPickerView.h"
#import "HK_UploadImagesModel.h"
#import "HK_LeSeeAddProductClassifyMenu.h"

#import "HKInitializationRespone.h"
typedef void(^UploadSuccessBlock)(void);

@interface HKFormSubmitViewController : HK_BaseView <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,VPImageCropperDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *groups;   //数据源保存 formModel

//处理键盘
@property (nonatomic, assign) CGRect editFrame;
@property (nonatomic, assign) CGPoint lastContentOffset;

//上传图片处理
@property (nonatomic, weak) HK_LogoFormModel *logoModel; //图片类型 cell 特殊处理
//地区选择处理
@property (nonatomic, weak) HK_SeclectFormModel *areaModel;
@property (nonatomic, strong) NSIndexPath *areaIndexPath;

@property (nonatomic, strong) NSMutableDictionary<NSString *, HK_UploadImagesModel *> *images;   //保存所有要上传的图片

@property (nonatomic, strong) NSString *rightItemTitle;

@property (nonatomic, strong) NSMutableDictionary *dataDict;

@property (nonatomic, copy) UploadSuccessBlock uploadSuccessBlock;

- (BOOL)nextStep;

- (void)handleTableClick:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;  //cell 点击处理

- (void)showPickerDataWithType:(NSString *)type model:(BaseModel *)model seclectFormModel:(HK_SeclectFormModel *)seclectFormModel indexPath:(NSIndexPath *)indexPath;           //从 初始化数据中选择 处理
@end
