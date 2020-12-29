//
//  UserInformVC.m
//  SeeFood
//
//  Created by lanou on 15/11/30.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "UserInformVC.h"
#import "PrefixHeader.pch"
#import "AppDelegate.h"
#import "UserModel.h"
#import <BmobSDK/Bmob.h>
#import <UIImageView+WebCache.h>

@interface UserInformVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIImageView *imV;//头像
@property(nonatomic, strong) NSArray *listArray;
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, strong) UserModel *userModel;
@end

@implementation UserInformVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.navigationItem setTitle:@"User InforMation"];
    [self.view addSubview:self.tableView];
    
    [self getData];
}

- (void)getData {
    _listArray = @[@"头像", @"用户名", @"昵称", @"手机号", @"E-Mail", @"地区", @"性别", @"出生年月日", @"自我介绍"];
    
    BmobUser *user = [BmobUser getCurrentUser];
    if (user) {
        _userModel = [[UserModel alloc]init];
        _userModel.username = user.username;
        _userModel.email = [user objectForKey:@"email"];
        _userModel.phone = user.mobilePhoneNumber;
        _userModel.photoURL = [user objectForKey:@"photoURL"];
        _userModel.gender = [user objectForKey:@"gender"];
        _userModel.myIntroduction = [user objectForKey:@"introduction"];
        _userModel.address = [user objectForKey:@"address"];
        _userModel.nickname = [user objectForKey:@"nickname"];
        _userModel.birthday = [user objectForKey:@"birthday"];
    }
    
    
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    NSString *logUsername = appDelegate.logUsername;
//    NSString *stringURL = [NSString stringWithFormat:@"http://180.76.16.26:9999/jhb/login?username=%@", logUsername];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:stringURL]];
//    [request setHTTPMethod:@"POST"];
//    __weak typeof(self) weakSelf=self;
//    [[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        weakSelf.userModel = [UserModel jsonToModel:dic];
//        
//        NSLog(@"%@", weakSelf.userModel.username);
//        
//        [weakSelf performSelectorOnMainThread:@selector(reloadDate) withObject:nil waitUntilDone:YES];
//    }]resume];
}

- (void)reloadDate {
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.hidden = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        return KScreenWidth * 0.5;
    }
    else
    {
        return KScreenWidth * 0.2;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}
//点击
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //点击跳转编辑textField
//    if(indexPath.row==0)
//    {
//        //调用相机 相册
//        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"确定要拍照吗" preferredStyle:1];
//        [self presentViewController:alert animated:YES completion:nil];
//        
//        UIAlertAction *action=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"拍照");
//            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//            {
//                UIImagePickerController * picker = [[UIImagePickerController alloc]init];
//                picker.delegate = self;
//                picker.allowsEditing = YES;
//                //摄像头
//                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                [self presentViewController:picker animated:YES completion:nil];
//                
//            }
//            //如果没有系统相机提示用户
//            else
//            {
//                NSLog(@"设备没有相机");
//            }
//        }];
//        
//        UIAlertAction *action3=[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDestructive handler:nil];
//        
//        UIAlertAction *action2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//
//        [alert addAction:action];
//        [alert addAction:action2];
//        [alert addAction:action3];
//    }
//    else if (indexPath.row==1)
//    {
//        //跳转填写昵称界面
//        NameViewController *name=[[NameViewController alloc]init];
//        [self.navigationController pushViewController:name animated:YES];
//    }
//    else if(indexPath.row==2)
//    {
//        //跳转填写手机号界面
//        NumbViewController *num=[[NumbViewController alloc]init];
//        [self.navigationController pushViewController:num animated:YES];
//    }
//    else if(indexPath.row==3)
//    {
//        //跳转地区定位界面
//        
//    }
//    else if(indexPath.row==4)
//    {
//        //弹出性别点选提示框
//    }
//    else if(indexPath.row==5)
//    {
//        //弹出点选出生年月日
//    }
//}
#pragma mark - 拍摄完成后或者选择相册完成后自动调用的方法 -
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
//{
//    // 存入系统相册
//     UIImageWriteToSavedPhotosAlbum(self.imV.image, nil, nil, nil);

    //得到图片
//    [ setImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
    // 模态返回
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//返回
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = _listArray[indexPath.row];
    switch (indexPath.row) {
        case 0: //头像
        {
            UIImageView *photo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth * 0.3, KScreenWidth * 0.3)];
            photo.center = CGPointMake(KScreenWidth / 2, KScreenWidth * 0.5 / 2);
            photo.backgroundColor = [UIColor grayColor];
            //显示用户照片
            NSString *filename = [NSString stringWithFormat:@"%@?t=1&a=f9794509da450cf1d08aa472900ca477", _userModel.photoURL];
            [photo sd_setImageWithURL:[NSURL URLWithString:filename]];
            [cell.contentView addSubview:photo];
        }
            break;
        case 1: //用户名
            cell.detailTextLabel.text = _userModel.username;
            break;
        case 2: //昵称
            cell.detailTextLabel.text = _userModel.nickname;
            break;
        case 3: //手机
            cell.detailTextLabel.text = _userModel.phone;
            break;
        case 4: //email
            cell.detailTextLabel.text = _userModel.email;
            break;
        case 5: //地区
            cell.detailTextLabel.text = _userModel.address;
            break;
        case 6: //性别
            cell.detailTextLabel.text = _userModel.gender;
            break;
        case 7: //生日
            cell.detailTextLabel.text = @"";
            break;
        case 8: //生日
            cell.detailTextLabel.text = _userModel.myIntroduction;
            break;
        default:
            break;
    }
    return cell;
}
//- (void)changeLabelAction:(NSNotification *)notification
//{
//    UITableViewCell *cell=[[UITableViewCell alloc]init];
//    
//    if([notification.name isEqualToString:@"changeLabelName"])
//    {
//        UITextField *textField=(UITextField *)notification.object;
//        cell.detailTextLabel.text=textField.text;
//      //移除通知
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeLabelName" object:nil];
//    }
//    else if([notification.name isEqualToString:@"changeLabelNumb"])
//    {
//        UITextField *textField=(UITextField *)notification.object;
//        cell.detailTextLabel.text=textField.text;
//        //移除通知
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeLabelNumb" object:nil];
//
//    }
//    else if([notification.name isEqualToString:@"changeLabelLoc"])
//    {
//        UITextField *textField=(UITextField *)notification.object;
//        cell.detailTextLabel.text=textField.text;
//        //移除通知
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeLabelLoc" object:nil];
//
//    }
//    else if([notification.name isEqualToString:@"changeLabelSex"])
//    {
//        UITextField *textField=(UITextField *)notification.object;
//        cell.detailTextLabel.text=textField.text;
//        //移除通知
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeLabelSex" object:nil];
//
//    }
//    else if([notification.name isEqualToString:@"changeLabelBirth"])
//    {
//        UITextField *textField=(UITextField *)notification.object;
//        cell.detailTextLabel.text=textField.text;
//        //移除通知
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeLabelBirth" object:nil];
//
//    }
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
