//
//  ThirdTableViewCell.h
//  
//
//  Created by V.Valentino on 16/9/21.
//
//

#import <UIKit/UIKit.h>

@interface ThirdTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *contents;


@end
