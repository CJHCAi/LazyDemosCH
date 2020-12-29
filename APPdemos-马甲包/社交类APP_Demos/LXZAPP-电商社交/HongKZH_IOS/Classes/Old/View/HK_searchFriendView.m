//
//  HK_searchFriendView.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/8/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_searchFriendView.h"
#import "HKSearchfriendList.h"
#import "HK_BaseRequest.h"
@interface HK_searchFriendView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray *shopsNew;

@property (nonatomic, strong)UITableView * searchlistView;

@property (nonatomic,strong)UITextField  * textField;

@end

@implementation HK_searchFriendView
- (NSMutableArray *)shopsNew
{
    if (!_shopsNew) {
        _shopsNew = [NSMutableArray array];
    }
    return _shopsNew;
}

-(UITableView *)searchlistView {
    if (!_searchlistView) {
        CGRect rect = self.view.bounds;
        if (@available(iOS 11.0, *)) {
            rect = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
        }
        else
        {
            rect = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
        }

        _searchlistView =[[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
       _searchlistView.backgroundColor = UICOLOR_RGB_Alpha(0Xffffff, 1);
        
        _searchlistView.tableFooterView =[[UIView alloc] init];
        //    myTableView.contentInset = UIEdgeInsetsMake(-SafeAreaTopHeight-10, 0, 0, 0);
        if (@available(iOS 11.0, *)) {
            //        myTableView.contentInset = UIEdgeInsetsMake(-SafeAreaTopHeight-10, 0, 0, 0);
        }
        _searchlistView.dataSource = self;
        _searchlistView.delegate = self;
        [self.view addSubview:_searchlistView];
    }
    return _searchlistView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)initNav
{
    //设置titleView
    
    self.navigationItem.titleView  =self.textField ;
    
   
    
    if (@available(iOS 11.0, *)) {
        
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftBtnPressed:) image:[UIImage imageNamed:@"selfMediaClass_back"]];
        self.navigationItem.rightBarButtonItem =[UIBarButtonItem itemWithTarget:self action:@selector(rightBtnPressed:) title:@"取消"];
        
    }
    else
    {
        UIButton *backButton  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        /**
         *  设置frame只能控制按钮的大小
         */
        backButton.frame= CGRectMake(0, 0, 62, 36);
        [backButton setBackgroundImage:[UIImage imageNamed:@"selfMediaClass_back.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        /**
         *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        negativeSpacer.width = -5;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];
        
        UIButton *rightButton  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        /**
         *  设置frame只能控制按钮的大小
         */
        rightButton.frame= CGRectMake(0, 0, 36, 36);
        [rightButton setTitle:@"取消" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *btn_right_right = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        UIBarButtonItem *rightnegativeSpacer = [[UIBarButtonItem alloc]
                                                initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                target:nil action:nil];
        /**
         *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        negativeSpacer.width = -5;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightnegativeSpacer, btn_right_right, nil];
        
    }
}
#pragma mark 开始搜索--输入搜索
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSString *subString = textField.text;
    subString = [subString stringByReplacingCharactersInRange:range withString:string];
    [self performSelector:@selector(addRequest) withObject:nil afterDelay:0.5];
    return YES;
}

//点击搜索
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.textField resignFirstResponder];
    
    [self addRequest];
  
    return YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
     [self initNav];
    [self setNeedsStatusBarAppearanceUpdate];
     //   [SystemNavBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.searchlistView];

}
-(void)addRequest {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:HKUSERLOGINID forKey:@"loginUid"];
    [dic setValue:self.textField.text forKey:@"name"];
    
    if (self.textField.text.length) {
        [HK_BaseRequest buildPostRequest:get_friendSearchfriendList body:dic success:^(id  _Nullable responseObject) {
            HKSearchfriendList*listData = [HKSearchfriendList mj_objectWithKeyValues:responseObject];
            if (listData.responeSuc) {
                self.shopsNew = [NSMutableArray arrayWithArray:listData.data];
                [self.searchlistView reloadData];
            }
            
        } failure:^(NSError * _Nullable error) {
            
        }];
//            [self Business_Request:BusinessRequestType_friend_searchfriendList dic:dic cache:NO];
    }else {
        [self.shopsNew removeAllObjects];
        [self.searchlistView reloadData];
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     FriendData *model = [self.shopsNew objectAtIndex:indexPath.row];
    
    HKMyFollowAndFansList *modelD =[[HKMyFollowAndFansList alloc] init];
    modelD.uid =model.uid ;
    modelD.name =model.name ;
    modelD.headImg = model.headImg;
    [AppUtils pushUserDetailInfoVcWithModel:modelD andCurrentVc:self];
//    HK_CladlyChattesView *vc = [[HK_CladlyChattesView alloc]init];
//    vc.targetId = model.uid;
//    vc.conversationType = ConversationType_PRIVATE;
//    vc.name = model.name;
//    [self.navigationController pushViewController:vc animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    UITableViewCell *cell = nil;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FriendData *model = [self.shopsNew objectAtIndex:indexPath.row];

    //NSLog(@"model.headIm..->%@ model.name.->%@",model.headImg,model.name);
    
    UIImageView * circularButton1 = [[UIImageView alloc] init];
    
    circularButton1.backgroundColor = [UIColor clearColor];
    [circularButton1.layer setMasksToBounds:YES];
    [circularButton1.layer setCornerRadius:24]; //设置矩形四个圆角半径
    [circularButton1.layer setBorderWidth:0];   //边框宽度
    
    
    UILabel *titleBom = [UILabel new];
    titleBom.backgroundColor = [UIColor clearColor];
    titleBom.font = [UIFont systemFontOfSize:16];
    titleBom.textAlignment = NSTextAlignmentCenter;
    titleBom.textColor = UICOLOR_RGB_Alpha(0x333333, 1);
    
    
    if (model && model.headImg&&[model.headImg isKindOfClass:[NSString class]]&&model.headImg.length>0) {
        [circularButton1 sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"imgDefault_bg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                [image  fadeIn:circularButton1 withDuration: 0.2 andWait : 0.2];
            }
        }];
    }
    else
    {
        [circularButton1 setImage:[UIImage imageNamed:@"imgDefault_bg"]];
    }
    
    [cell addSubview:circularButton1];
    
    [circularButton1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell).with.offset(10);
        make.left.equalTo(cell).with.offset(12);
        make.size.mas_equalTo(CGSizeMake(48,48));
    }];
    
    titleBom.text = @"  ";
    if (model.name&&[model.name isKindOfClass:[NSString class]]&&model.name.length>0)
    {
        titleBom.text = model.name;
    }
    [cell addSubview:titleBom];
    [titleBom mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell).with.offset(0);
        make.left.equalTo(circularButton1.mas_right).with.offset(12);
        make.height.mas_lessThanOrEqualTo(100000);
        make.height.mas_equalTo(70);
    }];
    
    UIView *svBg = [UIView new];
    [cell addSubview:svBg];
    [svBg.layer setMasksToBounds:YES];
    [svBg.layer setCornerRadius:6]; //设置矩形四个圆角半径
    [svBg.layer setBorderWidth:0];   //边框宽度
    [svBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell).with.offset(30);
        make.left.equalTo(titleBom.mas_right).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(44,13));
    }];
    
    
    UIImageView *triangleImgI = [[UIImageView alloc] init];
    if (model && model.sex&&[model.sex isKindOfClass:[NSString class]]&&model.sex.length>0){
        if ([model.sex intValue] == 1) {
            svBg.backgroundColor =UICOLOR_RGB_Alpha(0x83c6ff, 1);
            triangleImgI.image = [UIImage imageNamed:@"friend_boyW"];
        }
        else
        {
            svBg.backgroundColor =UICOLOR_RGB_Alpha(0xff8397, 1);
            triangleImgI.image = [UIImage imageNamed:@"friend_girlW"];
        }
    }
    [svBg addSubview:triangleImgI];
    [triangleImgI mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(svBg).with.offset(3);
        make.left.equalTo(svBg).with.offset(6);
        make.size.mas_equalTo(CGSizeMake(6,8));
    }];
    
    UILabel *title = [UILabel new];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont systemFontOfSize:9];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = UICOLOR_RGB_Alpha(0xffffff, 1);
    
    title.text = @"  ";
    
    if (model.level&&model.level>0)
    {
        title.text = [NSString stringWithFormat:@"LV%ld",(long)model.level];
    }
    
    [svBg addSubview:title];
    
    [title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(svBg).with.offset(1.5);
        make.left.equalTo(triangleImgI.mas_right).with.offset(4);
        make.width.mas_lessThanOrEqualTo(100000);
        make.height.mas_lessThanOrEqualTo(100000);
    }];
   
    return cell;
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70.0f;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return  self.shopsNew.count;
}

-(void)leftBtnPressed:(UIButton *)sender {
    [self.textField resignFirstResponder];
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBtnPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.textField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITextField *)textField{
    if (!_textField) {
        UITextField  * textF =[[UITextField alloc] initWithFrame: CGRectMake(0,0,270,30)];
        textF.backgroundColor =[UIColor whiteColor];
        textF.textColor = RGB(51,51,51);
        textF.font =[UIFont systemFontOfSize:14];
        //Base style for 矩形 1
        
        textF.layer.cornerRadius = 4;
        textF.layer.masksToBounds=YES;
        textF.layer.borderColor = [[UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f] CGColor];
        textF.layer.borderWidth = 0.5;
        textF.layer.backgroundColor = [[UIColor colorWithRed:255.0f/255.0f green:253.0f/255.0f blue:255.0f/255.0f alpha:1.0f] CGColor];
        textF.alpha = 1;
        _textField = textF;
        textF.returnKeyType =UIReturnKeySearch;
        textF.delegate = self;
        UIView *leftContentView =[[UIView alloc] initWithFrame:CGRectMake(0,0,30,20)];
        leftContentView.backgroundColor =[UIColor clearColor];
        
        UIImageView * left =[[UIImageView alloc] initWithFrame:CGRectMake(10,4,14,14)];
        left.image =[UIImage imageNamed:@"search"];
        
        [leftContentView addSubview:left];
        textF.leftView = leftContentView;
        textF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}
-(void)setSearchText:(NSString *)searchText{
    _searchText = searchText;
    if (searchText.length>0) {
        self.textField.text = searchText;
        [self addRequest];
    }
    
}
@end
