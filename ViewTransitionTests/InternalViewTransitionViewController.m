//
//  InternalViewTransitionViewController.m
//  ViewTransitionTests
//
//  Created by Nicholas Jones on 21/07/2017.
//  Copyright © 2017 touchsoft. All rights reserved.
//

#import "InternalViewTransitionViewController.h"
#import "UIView+VisualEffects.h"
#import "CHWZoomTransitionAnimator.h"

@interface InternalViewTransitionViewController () <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, ZoomTransitionDelegate>

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
    self.transitioningDelegate = self;
    self.navigationController.delegate = self;
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

-(CGPoint)zoomToPoint {
    return [self.view.superview convertPoint:self.zoomToView.center toView:self.view];
}

-(CGSize)zoomToSize {
    return self.zoomToView.frame.size;
}

-(CGPoint)zoomFromPoint {
    return [self zoomToPoint];
}

-(CGSize)zoomFromSize {
    return [self zoomToSize];
}


- (IBAction)zoomInPressed:(id)sender {
    [self.zoomAreaView zoomToPoint:[self zoomToPoint] size:[self zoomToSize] zoomAxis:CHWUIViewZoomYAxis duration:2.0 completion:^(BOOL finished) {
    }];
}

- (IBAction)zoomOutPressed:(id)sender {
    [self.zoomAreaView zoomOutToFullScreenWithDuration:2.0 completion:^(BOOL finished) {
    }];
}


- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[CHWZoomTransitionAnimator alloc] initWithPresenting:YES zoomPoint:[self zoomToPoint] zoomSize:[self zoomToSize]];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[CHWZoomTransitionAnimator alloc] initWithPresenting:NO zoomPoint:[self zoomToPoint] zoomSize:[self zoomToSize]];
}

- (id<UIViewControllerAnimatedTransitioning>)
navigationController:(UINavigationController *)navigationController
animationControllerForOperation:(UINavigationControllerOperation)operation
fromViewController:(UIViewController*)fromVC
toViewController:(UIViewController*)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        return [[CHWZoomTransitionAnimator alloc] initWithPresenting:YES zoomPoint:[self zoomToPoint] zoomSize:[self zoomToSize]];
    }
    else if (operation == UINavigationControllerOperationPop) {
        return [[CHWZoomTransitionAnimator alloc] initWithPresenting:NO zoomPoint:[self zoomToPoint] zoomSize:[self zoomToSize]];
    }
    return nil;
}

- (IBAction)modalTransition:(id)sender {
    [self performSegueWithIdentifier:@"modal" sender:self];
}
- (IBAction)navTransition:(id)sender {
    [self performSegueWithIdentifier:@"nav" sender:self];
}

@end
