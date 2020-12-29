//
//  HKEditMyGoodsViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEditMyGoodsViewController.h"
#import "HKEditMyGoodsTableViewCell.h"
#import "HKEditGoodsViewModel.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "HKEditGoodsModelIdTableViewCell.h"
#import "HKEditMyGoodsDeleteTableViewCell.h"
#import "HK_LeSeeAddProductClassifyMenu.h"
//#import "HK_ShopDataDataAllmediashopcategorysModel.h"
#import "HKFreightViewListController.h"
#import "HK_LeSeeAddProductDescVC.h"
#import "HKShopDataInitRespone.h"
@interface HKEditMyGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,HKEditMyGoodsTableViewCellDelegate,TZImagePickerControllerDelegate,HKEditMyGoodsDeleteTableViewCellDelegate,HKEditGoodsModelIdTableViewCellDelegate,HKFreightViewListControllerDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)MyGoodsRespone *respone;
@end

@implementation HKEditMyGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    if (!self.isAdd) {
       self.title = @"编辑商品";
      [self loadData];
    }else{
        self.title = @"添加商品";
        MyGoodsRespone*model = [[MyGoodsRespone alloc]init];
        MyGoodsInfo*infoM = [[MyGoodsInfo alloc]init];
        model.data = infoM;
        SkusModel*skuModel = [[SkusModel alloc]init];
        infoM.skus = [NSMutableArray arrayWithObject:skuModel];
        model.data.images = [NSMutableArray array];
        model.data.freightName = @"包邮";
        self.respone = model;
        [self.tableView reloadData];
    }
    
    // Do any additional setup after loading the view.
}
-(void)loadData{
    NSDictionary*dic = @{@"loginUid":HKUSERLOGINID,@"productId":self.productId};
    [HKEditGoodsViewModel loadMyGoodsinfo:dic success:^(MyGoodsRespone *respone) {
        if (respone.code == 0) {
            self.respone = respone;
            [self.tableView reloadData];
        }
    }];
}
-(void)selectFreightModel:(HKFreightListData *)model{
    
    self.respone.data.freightName = model.name;
    self.respone.data.freightId = model.freightId;
    [self.tableView reloadData];
}
-(void)setUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
            
            //back
    UIButton *bbt = [HKComponentFactory buttonWithType:UIButtonTypeCustom frame:CGRectMake(-10, 0, 50, 30) taget:self action:@selector(saveGoods) supperView:nil];
    [bbt setTitleColor:[UIColor colorWithRed:64.0/255.0 green:144.0/255.0 blue:247.0/255.0 alpha:1] forState:0];
    [bbt setTitle:@"完成" forState:0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bbt];
    
}
-(BOOL)skuIsPerfect{
    BOOL isPerfect = YES;
    for (SkusModel*model in self.respone.data.skus) {
        if (model.skuId.length == 0) {
            isPerfect = NO;
            break;
        }
    }
    return isPerfect;
}
-(void)saveGoods{
    MyGoodsInfo*goods =self.respone.data;
    if (goods.title.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"商品名称不能为空"];
        return;
    }
    if (goods.freightName.length==0) {
        [SVProgressHUD showErrorWithStatus:@"运费名称不能为空"];
        return;
    }
    
    if (goods.categoryName.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"商品分类不能为空"];
        return;
    }
    if (goods.skus.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"商品规格不能为空"];
        return;
    }
    if (![self skuIsPerfect]) {
        [SVProgressHUD showErrorWithStatus:@"商品规格填写不完善"];
        return;
    }
    if (self.isAdd) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        [HKEditGoodsViewModel saveAddMyGoodsinfo:self.respone.data success:^(BOOL isSuc) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            if (isSuc) {
                if ([self.delegate respondsToSelector:@selector(addGoods:)]) {
                    [self.delegate addGoods:self.respone.data];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [HKEditGoodsViewModel saveMyGoodsinfo:self.respone.data success:^(BOOL isSuc) {
        [SVProgressHUD dismiss];
        if (isSuc) {
            if ([self.delegate respondsToSelector:@selector(updateaGoods:row:)]) {
                [self.delegate updateaGoods:goods row:self.indexPath];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    }
}
-(void)dataUpdatedWithIndex:(NSInteger)index{
    if (index<0) {
        [self gotosendPhotoVC];
    }else{
        ImagesModel *imageM = self.respone.data.images[index];
        if (imageM.imgSrc.length > 0) {
            [self.respone.data.deleteImage addObject:imageM];
            
        }else{
            [self.respone.data.addImage enumerateObjectsUsingBlock:^(ImagesModel*image, NSUInteger idx, BOOL * _Nonnull stop) {
                if (image.image == imageM.image) {
                    [self.respone.data.addImage removeObject:image];
                }
            }];
        }
        [self.respone.data.images removeObjectAtIndex:index];
        [self.tableView reloadData];
    
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
        [self.respone.data.addImage addObject:model];
        [self.respone.data.images addObject:model];
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
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:5-self.respone.data.images.count delegate:self];
    imagePickerVC.naviTitleColor = [UIColor blackColor];
    imagePickerVC.barItemTextColor = [UIColor blackColor];
    imagePickerVC.allowTakePicture = YES; // 在内部显示拍照按钮
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
-(void)category{
    {
        [HK_LeSeeAddProductClassifyMenu showInView:self.navigationController.view withDataSourceType:DataSourceType_ShopData_AllMediaShopCategorys animation:YES selectedCallback:^(NSArray *items) {
            AllmediashopcategorysInit* data = items.lastObject;
            self.respone.data.categoryId = data.mediaCategoryId;
            self.respone.data.categoryName = data.name;
            [self.tableView reloadData];
                                  }];
    }
}
-(void)goodsInfo{
    //最后一个cell
    //商品详情
    HK_LeSeeAddProductDescVC *vc = [[HK_LeSeeAddProductDescVC alloc] init];
    vc.inHtmlString = self.respone.data.descript;
    vc.saveCallback = ^(NSString *htmlString) {
        self.respone.data.descript = htmlString;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)selectFFreight{
    //运费
    HKFreightViewListController *v = [[HKFreightViewListController alloc] init];
    v.delegate = self;
    [self.navigationController pushViewController:v animated:YES];
}
-(void)removeGoods{
    [HKEditGoodsViewModel deleteProduct:self.respone.data success:^(BOOL isSuc) {
        if (isSuc) {
            if (self.rowRefresh) {
                self.rowRefresh(self.indexPath.row);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
}
-(void)addGoodsGotoVc{
    BOOL isAdd = YES;
    for (SkusModel*skuM in self.respone.data.skus) {
        if (skuM.model.length <= 0) {
            isAdd = NO;
            break;
        }
    }
    if (isAdd) {
        SkusModel*skuM = [[SkusModel alloc]init];
        skuM.skuId = @"";
        [self.respone.data.skus addObject:skuM];
        [self.tableView reloadData];
    }else{
        
    }
    
}
-(void)deleteSkusWithModel:(SkusModel *)model{
    [self.respone.data.skus removeObject:model];
    [self.tableView reloadData];
    if (model.skuId.length > 0) {
        [self.respone.data.deleteSku addObject:model];
    }
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    }
    return _tableView;
}
-(void)htmlEdit{
    [self goodsInfo];
}
#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section != 1) {
        return 1;
    }
    return self.respone.data.skus.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HKEditMyGoodsTableViewCell*cell = [HKEditMyGoodsTableViewCell editMyGoodsTableViewCellWithTableView:tableView];
        if (self.respone.code == 0 && self.respone) {
            cell.model = self.respone.data;
            cell.delegate = self;
        }
        return cell;
    }else if (indexPath.section == 1){
        HKEditGoodsModelIdTableViewCell *cell = [HKEditGoodsModelIdTableViewCell ditGoodsModelIdTableViewCellWithTableView:tableView];
        if (self.respone) {
            cell.model = self.respone.data.skus[indexPath.row];
        }
        
        cell.delegate = self;
        return cell;
    }else{
        HKEditMyGoodsDeleteTableViewCell *cell = [HKEditMyGoodsDeleteTableViewCell editMyGoodsDeleteTableViewCell:tableView];
        if (self.respone) {
             cell.model = self.respone.data;
        }
        cell.isAdd = self.isAdd;
        cell.delegate = self;
        return cell;
    }
 
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
@end
