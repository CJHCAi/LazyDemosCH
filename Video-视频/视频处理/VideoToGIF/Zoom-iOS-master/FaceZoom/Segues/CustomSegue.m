//  Created by Phillipus on 19/09/2013.
//  Copyright (c) 2013 Dada Beatnik. All rights reserved.
//

#import "CustomSegue.h"

@implementation CustomSegue

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    
    //UIViewController *destinationViewController2 = self.destinationViewController;
    
    
//    [sourceViewController presentViewController:destinationViewController2 animated:NO completion:NULL]; // present VC

    
    
    // Add the destination view as a subview, temporarily
    [sourceViewController.view addSubview:destinationViewController.view];
    
    
   // [destinationViewController.view removeFromSuperview]; // remove from temp super view

    
//    [sourceViewController presentViewController:destinationViewController2 animated:NO completion:NULL]; // present VC

    
    // Transformation start scale
    destinationViewController.view.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    // Store original centre point of the destination view
    CGPoint originalCenter = destinationViewController.view.center;
    // Set center to start point of the button
    destinationViewController.view.center = self.originatingPoint;
    
    
    //[sourceViewController presentViewController:destinationViewController animated:NO completion:NULL]; // present VC

   // [sourceViewController presentModalViewController:destinationViewController animated:NO];

    
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // Grow!
                         destinationViewController.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
                         destinationViewController.view.center = originalCenter;
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                         
                             destinationViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                             //destinationViewController.view.layer.opacity = 0.0;

                         
                         } completion:^(BOOL finished){
                             
                             //[sourceViewController presentViewController:destinationViewController animated:NO completion:NULL]; // present VC
                             [destinationViewController.view removeFromSuperview]; // remove from temp super view

                             [sourceViewController presentViewController:destinationViewController animated:NO completion:^{
                                 //[destinationViewController.view removeFromSuperview]; // remove from temp super view
                                 [destinationViewController removeFromParentViewController];

                             }]; // present VC
                             [destinationViewController.view removeFromSuperview]; // remove from temp super view
                            //[destinationViewController removeFromParentViewController];

                             
                           //  [sourceViewController presentModalViewController:destinationViewController animated:NO];
//                             [destinationViewController removeFromParentViewController];

                             //[sourceViewController showDetailViewController:destinationViewController sender:sourceViewController];
                             
                         
                         }];
                         
                     }];
     
    
     
}

@end
