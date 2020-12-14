//
//  MusicListTableCell.h
//  MusicPartnerDownload
//
//  GitHub:https://github.com/szweee
//  Blog:  http://www.szweee.com
//
//  Created by 索泽文 on 16/2/13.
//  Copyright © 2016年 索泽文. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MusicListDelegate <NSObject>

-(void)addDownLoadTaskAction:(NSIndexPath *)indexPath;

@end

@interface MusicListTableCell : UITableViewCell

@property (assign ,nonatomic) id<MusicListDelegate> delegate;

@property (strong,nonatomic) NSIndexPath *index;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *desc;

- (IBAction)downLoadAction:(UIButton *)sender;


-(void)showData:(NSDictionary *)data;

@end
