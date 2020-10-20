//
//  ConstraintsViewController.m
//  Popping
//
//  Created by André Schneider on 19.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import "ConstraintsViewController.h"
#import "UIColor+CustomColors.h"

@interface ConstraintsViewController()
@property(nonatomic) UIView *redView;
@property(nonatomic) UIView *greenView;
@property(nonatomic) UIView *blueView;
@property(nonatomic) UIView *contentView;
- (void)addBarButton;
- (void)addViews;
- (void)updateConstraints:(id)sender;
- (NSArray *)shuffledArrayFromArray:(NSArray *)array;
@end

@implementation ConstraintsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBarButton];
    [self addViews];
    [self updateConstraints:nil];
}

#pragma mark - Private Instance methods

- (void)addBarButton
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Shuffle"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(updateConstraints:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)addViews
{
    self.contentView = [UIView new];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.contentView];

    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[_contentView]|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_contentView)]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[_contentView]|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_contentView)]];

    self.redView = [UIView new];
    self.redView.backgroundColor = [UIColor customBlueColor];
    self.redView.translatesAutoresizingMaskIntoConstraints = NO;
    self.redView.layer.cornerRadius = 4.f;
    self.greenView = [UIView new];
    self.greenView.backgroundColor = [UIColor customGreenColor];
    self.greenView.translatesAutoresizingMaskIntoConstraints = NO;
    self.greenView.layer.cornerRadius = 4.f;
    self.blueView = [UIView new];
    self.blueView.backgroundColor = [UIColor customYellowColor];
    self.blueView.translatesAutoresizingMaskIntoConstraints = NO;
    self.blueView.layer.cornerRadius = 4.f;

    [self.contentView addSubview:self.redView];
    [self.contentView addSubview:self.greenView];
    [self.contentView addSubview:self.blueView];
}

- (void)updateConstraints:(id)sender
{

    [self.contentView layoutIfNeeded];
    [self.contentView removeConstraints:self.contentView.constraints];

    NSDictionary *views = NSDictionaryOfVariableBindings(_redView, _greenView, _blueView);
    NSArray *viewNames = [self shuffledArrayFromArray:views.allKeys];

    NSString *firstViewKey= viewNames[0];
    NSString *secondViewKey = viewNames[1];
    NSString *thirdViewKey = viewNames[2];

    NSString *horizontalFormat = [NSString stringWithFormat:@"H:|-(20)-[%@]-(20)-|", firstViewKey];
    NSString *additionalHorizontalFormat = [NSString stringWithFormat:@"H:|-(20)-[%1$@]-(20)-[%2$@(==%1$@)]-(20)-|", secondViewKey, thirdViewKey];
    NSString *verticalFormat = [NSString stringWithFormat:@"V:|-(88)-[%1$@]-(20)-[%2$@(==%1$@)]-(20)-|", firstViewKey, secondViewKey];
    NSString *additionalVerticalFormat = [NSString stringWithFormat:@"V:|-(88)-[%1$@]-(20)-[%2$@(==%1$@)]-(20)-|", firstViewKey, thirdViewKey];

    [self.contentView addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:horizontalFormat
                               options:0
                               metrics:nil
                               views:views]];

    [self.contentView addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:additionalHorizontalFormat
                               options:NSLayoutFormatAlignAllTop
                               metrics:nil
                               views:views]];

    [self.contentView addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:verticalFormat
                               options:0
                               metrics:nil
                               views:views]];

    [self.contentView addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:additionalVerticalFormat
                               options:0
                               metrics:nil
                               views:views]];

    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.7
                        options:0
                     animations:^{
        [self.contentView layoutIfNeeded];
    } completion:NULL];
}

- (NSArray *)shuffledArrayFromArray:(NSArray *)array
{
    NSMutableArray *shuffleArray = [array mutableCopy];
    NSUInteger count = [shuffleArray count];

    for (NSUInteger i = 0; i < count; ++i) {
        NSUInteger nElements = count - i;
        NSUInteger n = arc4random_uniform((uint32_t)nElements) + i;
        [shuffleArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }

    return [shuffleArray copy];
}

@end
