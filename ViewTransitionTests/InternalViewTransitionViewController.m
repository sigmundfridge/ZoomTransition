//
//  InternalViewTransitionViewController.m
//  ViewTransitionTests
//
//  Created by Nicholas Jones on 21/07/2017.
//  Copyright © 2017 touchsoft. All rights reserved.
//

#import "InternalViewTransitionViewController.h"
#import "UIView+VisualEffects.h"

@interface InternalViewTransitionViewController () <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

@end

@implementation InternalViewTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.zoomToView showViewFrame];
//    [self.zoomToView showZoomCenterPoint];
    [self.zoomAreaView showViewFrame];
    [self.zoomAreaView showAnchor];
    [self.zoomAreaSibling showViewFrame];
//    [self.zoomAreaSibling showZoomCenterPoint];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)zoomInPressed:(id)sender {
    [self.zoomAreaView beginZoomToView:_zoomToView zoomAxis:(CHWUIViewZoomYAxis) completion:^(BOOL finished) {
        
    }];
}

- (IBAction)zoomOutPressed:(id)sender {
    [self.zoomAreaView zoomOutToFullScreenCompletion:^(BOOL finished) {
    }];

}


- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [self transitionForType:self.transitionType presenting:YES];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [self transitionForType:self.transitionType presenting:NO];
}

- (id<UIViewControllerAnimatedTransitioning>)
navigationController:(UINavigationController *)navigationController
animationControllerForOperation:(UINavigationControllerOperation)operation
fromViewController:(UIViewController*)fromVC
toViewController:(UIViewController*)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        return [self transitionForType:self.transitionType presenting:YES];
    }
    else if (operation == UINavigationControllerOperationPop) {
        return [self transitionForType:self.transitionType presenting:NO];
    }
    return nil;
}

-(void)setTransition:(CHWTransitionType)transition {
    self.transitionType = transition;
}

@end
