//
//  ViewController.m
//  ExpandFrameModel
//
//  Created by 栗子 on 2017/12/6.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/. All rights reserved.
//

#import "ViewController.h"
#import "ExpandTableViewCell.h"
#import "ListModel.h"
#import "ListFrameModel.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableVIew;
@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    [self initData];
     [self createUI];
    
}
-(void)createUI{
    self.tableVIew=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, LZScreenW, LZScreenH)style:UITableViewStylePlain];
    self.tableVIew.delegate=self;
    self.tableVIew.dataSource=self;
    self.tableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableVIew];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"cell";
    ExpandTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[ExpandTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ListFrameModel  *frameModel = self.dataSource[indexPath.row];
    if (frameModel.listModel.isSelected) {
        cell.answerLB.hidden = NO;
        cell.line1.hidden    = NO;
    }else{
        cell.answerLB.hidden = YES;
        cell.line1.hidden    = YES;
    }
    cell.frameModel = frameModel;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   ListFrameModel  *frameModel = self.dataSource[indexPath.row];
    if (frameModel.listModel.isSelected) {
        return [self.dataSource[indexPath.row] expandCellHeight];
    }else{
         return [self.dataSource[indexPath.row] unExpandCellHeight];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ListFrameModel  *frameModel = self.dataSource[indexPath.row];
    frameModel.listModel.isSelected = !frameModel.listModel.isSelected;
    [self.tableVIew reloadData];
    
}

-(void)initData{
    for (int i=0; i<8; i++) {
        ListModel *model = [[ListModel alloc]init];
        model.question = [NSString stringWithFormat:@"这是第%d问题",i];
        model.answer =[NSString stringWithFormat:@"这是第%d问题的答案这是第问题的答案这是第问题的答案这是第问题的答案这是第问题的答案这是第问题的答案这是第问题的答案这是第题的答案这是第d问题的答案这是问题的答案这是第问题的答案这是第d问题的答案这是第问题的答案这是第问题的答案",i];
        model.isSelected = NO;
        ListFrameModel *frameModel = [[ListFrameModel alloc]init];
        frameModel.listModel = model;
        [self.dataSource addObject:frameModel];
    }
    [self.tableVIew reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
