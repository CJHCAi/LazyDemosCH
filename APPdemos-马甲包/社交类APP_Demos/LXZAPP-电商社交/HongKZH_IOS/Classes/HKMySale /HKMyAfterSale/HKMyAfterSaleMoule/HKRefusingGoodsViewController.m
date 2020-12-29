//
//  HKRefusingGoodsViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/6.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRefusingGoodsViewController.h"
#import "RHKeasonsRejectionTableViewCell.h"
#import "HKUploadVoucherTableViewCell.h"
#import "TZImagePickerController.h"
#import "MyGoodsRespone.h"
#import "HKSubmissionView.h"
#import "HKAfterSaleViewModel.h"
#import "TZImageManager.h"
@interface HKRefusingGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,HKUploadVoucherTableViewCellDelegate,TZImagePickerControllerDelegate,RHKeasonsRejectionTableViewCellDelegate,HKSubmissionViewDeleegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *imageArray;
@property (nonatomic, strong)HKSubmissionView *footerView;
@property (nonatomic, copy)NSString *refundReason;
@end

@implementation HKRefusingGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)isSubmission:(NSString*)refundReason{
    self.refundReason = refundReason;
    if (refundReason.length>10) {
        self.footerView.btnuserInteractionEnabled = YES;
    }else{
        self.footerView.btnuserInteractionEnabled = NO;
    }
    
}
-(void)refusingRefund{
//    拒绝退款
    NSMutableArray*image = [NSMutableArray arrayWithCapacity:self.imageArray.count];
    for (ImagesModel*imageM in self.imageArray) {
        [image addObject:imageM.image];
    }
    NSDictionary*dict = @{@"loginUid":HKUSERLOGINID,@"orderNumber":self.orderNumber,@"refundReason":self.refundReason};
    [HKAfterSaleViewModel sellerRefuseOrder:dict imageArray:image success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
-(void)merchantProof{
//   商家举证
    NSDictionary*dict = @{@"loginUid":HKUSERLOGINID,@"orderNumber":self.orderNumber,@"sellerProof":@"",@"sellerProofDesc":self.refundReason};
    NSMutableArray*image = [NSMutableArray arrayWithCapacity:self.imageArray.count];
    for (ImagesModel*imageM in self.imageArray) {
        [image addObject:imageM.image];
    }
    [HKAfterSaleViewModel sellerProof:dict imageArray:image success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
-(void)submissionViewData{
    if (self.staue == AfterSaleViewStatue_RefuseReturn) {
        [self refusingRefund];
    }else if (self.staue == AfterSaleViewStatue_ProofOfBuyerseller){
        [self merchantProof];
    }

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        //        [_textView becomeFirstResponder];
    }];
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    DLog(@"");
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset{
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset success:^(NSString *outputPath) {
        
    } failure:^(NSString *errorMessage, NSError *error) {
        
    }];
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    for (UIImage*image in photos) {
        ImagesModel*model = [[ImagesModel alloc]init];
        model.image = image;
        [self.imageArray addObject:model];
    }
    [self.tableView reloadData];
    DLog(@"");
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    NSData *imgData = UIImageJPEGRepresentation(img, 0.01);
    img = [UIImage imageWithData:imgData];
    
}
-(void)gotosendPhotoVC{
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:5-self.imageArray.count delegate:self];
    imagePickerVC.allowTakePicture = NO; // 在内部显示拍照按钮
   // imagePickerVC.allowTakeVideo = NO;
    imagePickerVC.allowPickingImage = YES;
    imagePickerVC.allowPickingOriginalPhoto = NO;
    imagePickerVC.allowPickingGif = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVC.sortAscendingByModificationDate = YES;
    imagePickerVC.showSelectBtn = NO;
    imagePickerVC.circleCropRadius = 100;
    imagePickerVC.isStatusBarDefault = NO;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}
-(void)dataUpdatedWithIndex:(NSInteger)index{
    if (index<0) {
        [self gotosendPhotoVC];
    }else{
        [self.imageArray removeObjectAtIndex:index];
        [self.tableView reloadData];
    }
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tableFooterView = self.footerView;
        _tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
        _tableView.estimatedRowHeight = 245;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        RHKeasonsRejectionTableViewCell *cell = [RHKeasonsRejectionTableViewCell keasonsRejectionTableViewCellWithTableView:tableView];
        cell.delegate = self;
        cell.staue = self.staue;
        return cell;
    }else if (indexPath.row == 1){
        HKUploadVoucherTableViewCell*cell = [HKUploadVoucherTableViewCell uploadVoucherTableViewCellWithTableView:tableView];
        cell.imageArray = self.imageArray;
        cell.delegate = self;
        cell.staue = self.staue;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
- (NSMutableArray *)imageArray
{
    if(_imageArray == nil)
    {
        _imageArray = [ NSMutableArray array];
    }
    return _imageArray;
}
-(HKSubmissionView *)footerView{
    if (!_footerView) {
        _footerView = [[HKSubmissionView alloc]init];
        _footerView.frame = CGRectMake(0, 0, kScreenWidth, 111);
        _footerView.delegate = self;
    }
    return _footerView;
}
-(void)setStaue:(AfterSaleViewStatue)staue{
    _staue = staue;
    if (staue == AfterSaleViewStatue_ProofOfBuyerseller) {
        self.title = @"举证";
    }else if(staue == AfterSaleViewStatue_RefuseReturn){
        self.title = @"拒绝退款";
    }
}
@end
