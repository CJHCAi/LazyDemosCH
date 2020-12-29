//
//  ChattingTableViewController.m
//  环信测试
//
//  Created by tarena on 16/9/1.
//  Copyright © 2016年 tarena. All rights reserved.
//

 
#import "Utils.h"
//#import "RecordButton.h"
#import "TRMessageCell.h"
//#import "amrFileCodec.h"
#import "UIImageView+WebCache.h"
#import "EasemobManager.h"
#import "TRChattingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIViewExt.h"

@interface TRChattingViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate,UITableViewDataSource, UITableViewDelegate>
//@property (nonatomic, strong)AVAudioPlayer *player;
@property (nonatomic, strong)NSMutableArray *messages;
 

@property (nonatomic, strong)IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *commentBar;
@property (weak, nonatomic) IBOutlet YYTextView *commentTV;

@property (nonatomic, strong)UIScrollView *faceSV;
@property (nonatomic, strong)NSArray *faceArr;

//********多选图片相关
@property (nonatomic, strong)UIScrollView *selectedImageSV;



@property (nonatomic, strong)UIScrollView *pickerSV;
@property (nonatomic, strong)UIButton *addImageButton;
@property (nonatomic, strong)NSMutableArray *selectedImageViews;
//录音相关
//@property (nonatomic, strong)UIView *voiceView;

//@property (nonatomic, strong)UILabel *timeLabel;

//@property (nonatomic, strong)NSData *voiceData;
@end

@implementation TRChattingViewController

//录音界面
//-(UIView *)voiceView{
//    
//    if (!_voiceView) {
//        _voiceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 216)];
//        
//        RecordButton *btn = [[RecordButton alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
//        btn.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 216/2);
//        
//        [_voiceView addSubview:btn];
//
//    }
//    
//    return _voiceView;
//}


//表情界面
-(UIScrollView *)faceSV{
    if (!_faceSV) {
        _faceSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 216)];
        //绑定表情
        [Utils faceMappingWithText:self.commentTV];
        //添加表情按钮
        NSString *path = [[NSBundle mainBundle]pathForResource:@"default" ofType:@"plist"];
        NSArray *faceArr = [NSArray arrayWithContentsOfFile:path];
        self.faceArr = faceArr;
        NSInteger page = faceArr.count%32==0?faceArr.count/32 : faceArr.count/32+1;
        [_faceSV setContentSize:CGSizeMake(page*self.view.bounds.size.width, 0)];
        //整页显示
        _faceSV.pagingEnabled = YES;
        float size = self.view.bounds.size.width/8;
        //        35   32    3
        for (int i=0; i<page; i++) {
            NSInteger count = 32;
            //如果是最后一页
            if (i==page-1) {
                count = faceArr.count%32;
            }
            for (int j=0; j<count; j++) {
                
                UIButton *faceBtn = [[UIButton alloc]initWithFrame:CGRectMake(j%8*size+i*self.view.bounds.size.width, j/8*size, size, size)];
                [_faceSV addSubview:faceBtn];
                //显示图片
                NSDictionary *faceDic = faceArr[j+32*i];
                NSString *imageName = faceDic[@"png"];
                [faceBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                //让按钮记住自己是第几个
                faceBtn.tag = j+32*i;
                [faceBtn addTarget:self action:@selector(faceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    return _faceSV;
}
//表情按钮
-(void)faceBtnAction:(UIButton *)faceBtn{
    NSDictionary *faceDic = self.faceArr[faceBtn.tag];
    NSString *text = faceDic[@"chs"];
    [self.commentTV insertText:text];
}
//图片界面
-(UIScrollView *)selectedImageSV{
    if (!_selectedImageSV) {
        _selectedImageSV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216)];
        self.addImageButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 30, 100, 140)];
        [self.addImageButton setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
        [self.selectedImageSV addSubview:self.addImageButton];
        [self.addImageButton addTarget:self action:@selector(addImageAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedImageSV;
}
//图片按钮
-(void)addImageAction
{
    if (self.selectedImageViews.count<9) {
        UIImagePickerController *pick=[UIImagePickerController new];
        pick.delegate=self;
        [self presentViewController:pick animated:YES completion:nil];
    }
}
//根据点击的按钮设置键盘的inputview
- (IBAction)clicked:(UIButton *)sender {
    switch (sender.tag) {
        case 0://图片
            self.commentTV.inputView = [self.commentTV.inputView isEqual:self.selectedImageSV]?nil : self.selectedImageSV;
            break;
        case 1://表情
            self.commentTV.inputView = [self.commentTV.inputView isEqual:self.faceSV]?nil : self.faceSV;
            break;
//        case 2://录音
//            self.commentTV.inputView = [self.commentTV.inputView isEqual:self.voiceView]?nil : self.voiceView;
//            break;
    }
    [self.commentTV reloadInputViews];
}
//发送
- (IBAction)sendAction:(id)sender {
    
    if (self.commentTV.text.length>0) {
        EMMessage *message =  [[EasemobManager shareManager]sendMessageWithText:self.commentTV.text andUsername:self.toUsername];
        [self.messages addObject:message];
        [self.tableView reloadData];
        [self showNewMessage];
        self.commentTV.text = @"";
    }
    //如果有图片
    if (self.selectedImageViews.count>0) {
        for (UIImageView *imageView in self.selectedImageViews) {
            UIImage *image = imageView.image;
            EMMessage *m =  [[EasemobManager shareManager]sendMessageWithImage:image andUsername:self.toUsername];
            [self.messages addObject:m];
            [self.tableView reloadData];
            [self showNewMessage];
        }
        //删除所有选择的图片
        for (UIImageView *iv in self.selectedImageViews) {
            [iv removeFromSuperview];
        }
        [self.selectedImageViews removeAllObjects];
        [UIView animateWithDuration:.5 animations:^{
          self.addImageButton.left = 10;
        }];
    }
}
 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.toUsername;
    self.tabBarController.tabBar.hidden = YES;
    
    self.selectedImageViews = [NSMutableArray array];
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.toUsername conversationType:eConversationTypeChat];
    //删除会话
//    [[EaseMob sharedInstance].chatManager removeConversationByChatter:self.toUsername deleteMessages:YES append2Chat:YES];

    self.messages = [[conversation loadAllMessages] mutableCopy];
    
    //监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMessageAction:) name:@"接收消息" object:nil];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recrodAction:) name:@"RecordDidFinishNotification" object:nil];
    
    //监听软键盘
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeAction:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TRMessageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];

}
//监听键盘
-(void)keyboardChangeAction:(NSNotification *)noti{
    
    NSLog(@"%@",noti.userInfo);
    CGRect keyboardF = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //判断收软键盘
    if (keyboardF.origin.y==[UIScreen mainScreen].bounds.size.height) {
        //还原
        self.commentBar.transform = CGAffineTransformIdentity;
        self.tableView.height = [UIScreen mainScreen].bounds.size.height - 64 - self.commentBar.height;
    }else{//软键盘弹出
        self.commentBar.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height);
        //tableView高度变短
        self.tableView.height = [UIScreen mainScreen].bounds.size.height-keyboardF.size.height-self.commentBar.height - 64;
        //显示最新消息
        [self showNewMessage];
    }
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showNewMessage];
    //如果选择了图片 则显示软键盘
    if (self.selectedImageViews.count>0) {
        [self.commentTV becomeFirstResponder];
    }
}
//-(void)recrodAction:(NSNotification *)noti{
//    NSData *data = noti.object[@"data"];
//    float time = [noti.object[@"time"]floatValue];
//    //发送音频消息
//    EMMessage *message = [[EasemobManager shareManager]sendMessageWithVoiceData:data andTime:time andUsername:self.toUsername];
//    
//    [self.messages addObject:message];
//    [self.tableView reloadData];
//     [self showNewMessage];
//}

- (void)newMessageAction:(NSNotification *)noti {
    EMMessage *message = noti.object;
    if ([message.from isEqualToString:self.toUsername]) {
        [self.messages addObject:message];
        [self.tableView reloadData];
        [self showNewMessage];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TRMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    EMMessage *message = self.messages[indexPath.row];
    cell.toUser = self.toUser;
    cell.message = message; 
    if (indexPath.row>0) {
        EMMessage *preMessage = self.messages[indexPath.row-1];
        if ((message.timestamp-preMessage.timestamp)<1000*60) {//一分钟内
            cell.timeLabel.hidden = YES;
            cell.messageContentView.transform = CGAffineTransformMakeTranslation(0, -cell.timeLabel.height);
        }else{
            cell.timeLabel.hidden = NO;
            cell.messageContentView.transform = CGAffineTransformIdentity;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EMMessage *message = self.messages[indexPath.row];
    //得到消息的具体内容
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    switch ((int)msgBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            
        }
            break;
        case eMessageBodyType_Image:
        {
            
            // 得到一个图片消息body
            EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
            NSLog(@"大图remote路径 -- %@"   ,body.remotePath);
            NSLog(@"大图local路径 -- %@"    ,body.localPath);
           
            UIViewController *vc = [UIViewController new];
            UIImageView *iv = [[UIImageView alloc]initWithFrame:vc.view.bounds];
            
            [vc.view addSubview:iv];
            
            if ([message.to isEqualToString:self.toUsername]) {//自己发
                iv.image = [UIImage imageWithContentsOfFile:body.localPath];
                
            }else{//接收到
                [iv sd_setImageWithURL:[NSURL URLWithString:body.remotePath]];
            }
            
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
//        case eMessageBodyType_Voice:
//        {
//            
//            EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
//            NSLog(@"音频remote路径 -- %@"      ,body.remotePath);
//            NSLog(@"音频local路径 -- %@"       ,body.localPath);
//            
//            
//            //得到点击这一行的Cell
//            TRMessageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            
//            if ([message.to isEqualToString:self.toUsername]) {//自己发送的内容
//                NSData *data = [NSData dataWithContentsOfFile:body.localPath];
//                data = DecodeAMRToWAVE(data);
//                
//                self.player = [[AVAudioPlayer alloc]initWithData:data error:nil];
//                [self.player play];
//                
//                [cell.voiceView beginAnimation];
//             
//                
//            }else{//对方发送的
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:body.remotePath]];
//                    
//                    data = DecodeAMRToWAVE(data);
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        self.player = [[AVAudioPlayer alloc]initWithData:data error:nil];
//                        [self.player play];
//                        [cell.voiceView beginAnimation];
//                    });
//
//                });
//                
//                
//                
//               
//            }
            
//        }
//            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMMessage *message = self.messages[indexPath.row];
    float h = 0;
    //得到消息的具体内容
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    switch ((int)msgBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            
            // 收到的文字消息
            NSString *txt = ((EMTextMessageBody *)msgBody).text;
            //计算文本高度
            
            YYTextView *tv = [[YYTextView alloc]initWithFrame:CGRectMake(0, 0, 250, 0)];
            tv.text = txt;
            
            h = tv.textLayout.textBoundingSize.height + 30 +8;
        }
            break;
        case eMessageBodyType_Image:
        {
            h = 150+24; //图片高度+气泡高度
        }
            break;
        case eMessageBodyType_Voice:
        {
            h = 60;
        }
            break;
    }
    //判断是否需要显示时间label
    if (indexPath.row>0) {
        EMMessage *preMessage = self.messages[indexPath.row-1];
        if ((message.timestamp-preMessage.timestamp)>1000*60) {//不隐藏时间label
            h+=20;
        }
    }else{
        h+=20;
    }
    return h;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/





-(void)showNewMessage{
    if (self.messages.count>0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

#pragma mark 多选图片相关
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    
    UIImageView *iv=[[UIImageView alloc]initWithFrame:CGRectMake(self.selectedImageViews.count*80, 0, 80, 80)];
    
    iv.image=info[UIImagePickerControllerOriginalImage];
    
    [self.pickerSV addSubview:iv];
    
    
    iv.userInteractionEnabled=YES;
    [self.selectedImageViews addObject:iv];
    
    self.pickerSV.contentSize=CGSizeMake(self.selectedImageViews.count*80, 0);
    
    UIButton *delBtn =[[UIButton alloc]initWithFrame:CGRectMake(60, 0, 20, 20)];
    [delBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [delBtn setTitle:@"X" forState:UIControlStateNormal];
    [delBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [iv addSubview:delBtn];
    
    //图片选择到9张得时候直接完成 返回
    if(self.selectedImageViews.count==9)
    {
        [self doneAction];
        
    }
    
    
    
    
    
}
-(void)deleteAction:(UIButton *)btn
{
    [self.selectedImageViews removeObject:btn.superview];
    [btn.superview removeFromSuperview];
    for(int i=0;i<self.selectedImageViews.count;i++)
    {
        UIImageView *iv=self.selectedImageViews[i];
        [UIView animateWithDuration:0.5 animations:^{
            iv.frame=CGRectMake(i*80, 0, 80, 80);
        }];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    
    //找到第二个页面 添加选择控件
    if(navigationController.viewControllers.count==2)
    {
        
        //得到页面中sv 把高度 -100
        UIView *cv = [viewController.view.subviews firstObject];
        CGRect frame = cv.frame;
        frame.size.height -= 100;
        cv.frame = frame;
        
        
        
        UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, kScreenH - 100, kScreenW, 100)];
        v.backgroundColor = [UIColor whiteColor];
        [viewController.view addSubview:v];
        self.pickerSV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, kScreenW, 80)];
        self.pickerSV.backgroundColor=[UIColor grayColor];
        [v addSubview:self.pickerSV];
        UIButton *doneBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 40, 0, 40, 20)];
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        doneBtn.backgroundColor=[UIColor grayColor];
        [v addSubview:doneBtn];
        [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        
        //把之前选择的图片添加进去
        for(int i=0;i<self.selectedImageViews.count;i++)
        {
            UIImageView *iv=self.selectedImageViews[i];
            
            iv.frame=CGRectMake(i*80, 0, 80, 80);
            UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(60, 0, 20, 20)];
            [delBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [delBtn setTitle:@"X" forState:UIControlStateNormal];
            [delBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            
            [iv addSubview:delBtn];
            [self.pickerSV addSubview:iv];
        }
    }
}
-(void)doneAction
{
    
    
    //遍历选择到的图片 把选择到的图片 添加到发送页面的SV里面
    for (int i=0; i<self.selectedImageViews.count; i++) {
        UIImageView *iv=self.selectedImageViews[i];
        iv.frame = CGRectMake(20+120*i, 30, 100, 140);
        //把图片里面的删除按钮 删掉
        UIButton *delBtn = [iv.subviews firstObject];
        [delBtn removeFromSuperview];
        
        [self.selectedImageSV addSubview:iv];
    }
    
    self.selectedImageSV.contentSize=CGSizeMake((self.selectedImageViews.count+1)*120, 0);
    
    self.addImageButton.center = CGPointMake(20+self.selectedImageViews.count*120+self.addImageButton.bounds.size.width/2, self.addImageButton.center.y);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
   
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end
