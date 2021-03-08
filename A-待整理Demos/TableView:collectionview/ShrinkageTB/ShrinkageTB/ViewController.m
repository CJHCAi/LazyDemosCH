//
//  ViewController.m
//  ShrinkageTB
//
//  Created by xxlc on 2019/6/25.
//  Copyright © 2019 yunfu. All rights reserved.
//

#import "ViewController.h"
#import "SignInCell.h"



@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *isOpentaskArr;//新手任务折叠是否打开
@property (nonatomic, strong) NSMutableArray *isOpendayArr;//每日任务折叠是否打开
@property (nonatomic, assign) CGFloat heightCell;//cell动态高度


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
   
    _heightCell = 0.0f;
    
    //新手任务
    _isOpentaskArr = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        NSString *state = @"close";
        [self.isOpentaskArr addObject:state];
    }
    
}
#pragma mark -tableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //cell之间有间隔是需要打开
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = [UIColor clearColor];
        
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - tableview delegate / dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
#pragma mark -cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SignInCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirCell"];
    if (!cell) {
        cell = [[SignInCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FirCell"];
    }
    if (indexPath.row == 0) {
        cell.titleLab.hidden = NO;
        cell.typeLab.hidden = YES;
        cell.promitLab.hidden = YES;
        cell.goldImagelab.hidden = YES;
        cell.glodLab.hidden = YES;
        cell.rightBtn.hidden = YES;
        cell.backHidenView.hidden = YES;
        cell.selectedBtn.hidden = YES;
        
    }else{
        cell.leftView.hidden = YES;
        
        NSString *state = [self.isOpentaskArr objectAtIndex:indexPath.row - 1];
        if ([state isEqualToString:@"open"]) {
            cell.backHidenView.hidden = NO;//折叠隐藏
            [cell.selectedBtn setImage:[UIImage imageNamed:@"task_up"] forState:0];
        }else{
            cell.backHidenView.hidden = YES;//折叠隐藏
            [cell.selectedBtn setImage:[UIImage imageNamed:@"task_down"] forState:0];
        }
        
    }
    
    //折叠
    cell.selectedBtn.tag = 1000 + indexPath.row;
    [cell.selectedBtn addTarget:self action:@selector(rightSelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
    
    
}
#pragma mark -高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row) {
        
        NSString *state = [self.isOpentaskArr objectAtIndex:indexPath.row - 1];
        
        if ([state isEqualToString:@"open"]) {
            return 200*m6Scale;//动态高度
        }else{
            return 100*m6Scale;//动态高度
        }
    }
    return 100*m6Scale;
   
}
#pragma mark -新手任务折叠
- (void)rightSelBtn:(UIButton *)sender{
    
    NSString *state = [self.isOpentaskArr objectAtIndex:sender.tag - 1001];
    if ([state isEqualToString:@"open"]) {
        state = @"close";
    }else{
        state = @"open";
    }
    self.isOpentaskArr[sender.tag - 1001] = state;
    NSLog(@"----%@",_isOpentaskArr);
    //    [_tableView reloadData];
    //一个cell刷新
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag - 1000 inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.section == 0) {
    //
    //    }else if(indexPath.section == 1){
    if ([cell respondsToSelector:@selector(tintColor)]) {
        //        if (tableView == self.tableView) {
        CGFloat cornerRadius = 10.f;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 30*m6Scale, 0);
        
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
        } else if (indexPath.row == 0) {
            
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
            
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        } else {
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
        layer.fillColor = [UIColor whiteColor].CGColor;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        if (addLine == YES) {
            //                CALayer *lineLayer = [[CALayer alloc] init];
            //                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
            //                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
            //                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
            //                [layer addSublayer:lineLayer];
            
            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
            UIImageView *lineImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"s_Line_icon"]];
            lineImage.frame = CGRectMake(CGRectGetMinX(bounds) + 20*m6Scale, bounds.size.height-lineHeight, bounds.size.width - 40*m6Scale, lineHeight);
            [cell addSubview:lineImage];
            
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
    //    }
}




@end
