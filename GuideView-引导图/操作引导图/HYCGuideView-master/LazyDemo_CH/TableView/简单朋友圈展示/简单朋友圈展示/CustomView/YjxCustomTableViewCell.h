//
//  TableViewCell.h
//  TableviewLayout
//

#import <UIKit/UIKit.h>
#import "UILabel+MCLabel.h"
#import "YjxCustomModel.h"
#import "YjxToolBarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YjxCustomTableViewCell : UITableViewCell

//@property (nonatomic,strong)NSDictionary *dataModel;
@property(nonatomic, strong)UIImageView *iconImg;
@property(nonatomic, strong)UILabel *nameL;
@property(nonatomic, strong)UILabel *textContentL;
@property(nonatomic, strong)UILabel *timeL;
@property(nonatomic, strong)UILabel *personalLibL;
@property (nonatomic,strong)UICollectionView *collectView;
@property (nonatomic,strong)UIView *line;

//底部工具栏
@property(nonatomic, strong)YjxToolBarView *toolbar;
@property(nonatomic, strong)YjxCustomModel *model;
@end

NS_ASSUME_NONNULL_END
