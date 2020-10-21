//
//  APPViewController.m
//  PageApp
//
//  Created by Rafael Garcia Leiva on 10/06/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "APPViewController.h"
#import "APPChildViewController.h"

@interface APPViewController ()

@end

@implementation APPViewController


/*

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    APPChildViewController *initialViewController = [[APPChildViewController alloc]init];//[self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    //[self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (APPChildViewController *)viewControllerAtIndex:(NSUInteger)index {
        
    APPChildViewController *childViewController = [[APPChildViewController alloc] initWithNibName:@"APPChildViewController" bundle:nil];
    childViewController.index = index;
    
    return childViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(APPChildViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    APPChildViewController *initialViewController = [[APPChildViewController alloc]init];//[self viewControllerAtIndex:0];
    return initialViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(APPChildViewController *)viewController index];
    
    index++;
    
    if (index == 4) {
        return nil;
    }
    
    APPChildViewController *initialViewController = [[APPChildViewController alloc]init];//[self viewControllerAtIndex:0];
    return initialViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 4;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}











*/









/*


#pragma mark - UIPageViewControllerDataSource Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.modelArray indexOfObject:[(ContentViewController *)viewController textContents]];
    if(currentIndex == 0)
    {
        return nil;
    }
    ContentViewController *contentViewController = [[ContentViewController alloc] init];
    contentViewController.textContents = [self.modelArray objectAtIndex:currentIndex - 1];
    return contentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.modelArray indexOfObject:[(ContentViewController *)viewController textContents]];
    if(currentIndex == self.modelArray.count-1)
    {
        return nil;
    }
    ContentViewController *contentViewController = [[ContentViewController alloc] init];
    contentViewController.textContents = [self.modelArray objectAtIndex:currentIndex + 1];
    
    return contentViewController;
}




//#pragma mark - UIPageViewControllerDelegate Methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if(UIInterfaceOrientationIsPortrait(orientation))
    {
        //Set the array with only 1 view controller
        UIViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
        NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
        
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        //Important- Set the doubleSided property to NO.
        self.pageViewController.doubleSided = NO;
        //Return the spine location
        return UIPageViewControllerSpineLocationMin;
    }
    else
    {
        NSArray *viewControllers = nil;
        ContentViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
        
        NSUInteger currentIndex = [self.modelArray indexOfObject:[(ContentViewController *)currentViewController textContents]];
        if(currentIndex == 0 || currentIndex %2 == 0)
        {
            UIViewController *nextViewController = [self pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
            viewControllers = [NSArray arrayWithObjects:currentViewController, nextViewController, nil];
        }
        else
        {
            UIViewController *previousViewController = [self pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
            viewControllers = [NSArray arrayWithObjects:previousViewController, currentViewController, nil];
        }
        //Now, set the viewControllers property of UIPageViewController
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        return UIPageViewControllerSpineLocationMid;
    }
}

*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    //Instantiate the model array
    self.modelArray = [[NSMutableArray alloc] init];
    self.vcs = [[NSMutableArray alloc]init];
    
    for (int index = 1; index <= 2 ; index++)
    {
        [self.modelArray addObject:[NSString stringWithFormat:@"Page %d",index]];
    }
    
    //Step 1
    //Instantiate the UIPageViewController.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    //Step 2:
    //Assign the delegate and datasource as self.
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    //Step 3:
    //Set the initial view controllers.
    
    //appDelegate.contentViewController.textContents = [self.modelArray objectAtIndex:0];
    APPChildViewController *initialViewController = [[APPChildViewController alloc]init];//[self viewControllerAtIndex:0];

    
    //NSArray *viewControllers = @[initialViewController];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];

    
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    
    //Step 4:
    //ViewController containment steps
    //Add the pageViewController as the childViewController
    [self addChildViewController:self.pageViewController];
    
    //Add the view of the pageViewController to the current view
    [self.view addSubview:self.pageViewController.view];
    
    //Call didMoveToParentViewController: of the childViewController, the UIPageViewController instance in our case.
    [self.pageViewController didMoveToParentViewController:self];
    
    //Step 5:
    // set the pageViewController's frame as an inset rect.
    CGRect pageViewRect = self.view.bounds;
    pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0);
    self.pageViewController.view.frame = pageViewRect;
    
    //Step 6:
    //Assign the gestureRecognizers property of our pageViewController to our view's gestureRecognizers property.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}









@end
