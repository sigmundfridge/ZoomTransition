//
//  CHWZoomTransitionAnimator.m
//  ChwarelHospital
//
//  Created by Nicholas Jones on 18/07/2017.
//  Copyright © 2017 Richard Wylie. All rights reserved.
//

#import "CHWZoomTransitionAnimator.h"
#import "UIView+VisualEffects.h"
#import "InternalViewTransitionViewController.h"

@interface CHWZoomTransitionAnimator()
@property (nonatomic) CGPoint zoomPoint;
@property (nonatomic) CGSize zoomSize;
@end

@implementation CHWZoomTransitionAnimator

- (instancetype)init{
    return [self initWithPresenting:YES zoomPoint:CGPointMake(0, 0) zoomSize:CGSizeMake(10, 10)];
}


-(instancetype)initWithPresenting:(BOOL)isPresenting zoomPoint:(CGPoint)zoomPoint zoomSize:(CGSize)zoomSize {
    if(self = [super init]) {
        _isPresenting = isPresenting;
        _zoomSize = zoomSize;
        _zoomPoint = zoomPoint;
    }
    return self;
}

//| ----------------------------------------------------------------------------
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0;
}


//| ----------------------------------------------------------------------------
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    // For a Presentation:
    //      fromView = The presenting view.
    //      toView   = The presented view.
    // For a Dismissal:
    //      fromView = The presented view.
    //      toView   = The presenting view.
    UIView *fromView;
    UIView *toView;
    
    // In iOS 8, the viewForKey: method was introduced to get views that the
    // animator manipulates.  This method should be preferred over accessing
    // the view of the fromViewController/toViewController directly.
    // It may return nil whenever the animator should not touch the view
    // (based on the presentation style of the incoming view controller).
    // It may also return a different view for the animator to animate.
    //
    // Imagine that you are implementing a presentation similar to form sheet.
    // In this case you would want to add some shadow or decoration around the
    // presented view controller's view. The animator will animate the
    // decoration view instead and the presented view controller's view will
    // be a child of the decoration view.
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    
    fromView.frame = [transitionContext initialFrameForViewController:fromViewController];
    toView.frame = [transitionContext finalFrameForViewController:toViewController];

    
    if (self.isPresenting && [fromViewController conformsToProtocol:@protocol(ZoomTransitionDelegate)]) {
        //do transition
        
        UIViewController <ZoomTransitionDelegate>* zoomFromVC = (UIViewController <ZoomTransitionDelegate>*)fromViewController;

        UIView *fromSnapShot = [fromView snapshotViewAfterScreenUpdates:YES];
        
        UIView *zoomContainer = [[UIView alloc] initWithFrame:fromView.frame];
        [zoomContainer addSubview:fromSnapShot];
        // We are responsible for adding the incoming view to the containerView
        // for the presentation/dismissal.
        toView.alpha = 0;
        [containerView addSubview:toView];
        [containerView addSubview:zoomContainer];
        [containerView bringSubviewToFront:zoomContainer];
        
        NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
        NSTimeInterval zoomDuration = 2.0 * transitionDuration / 3.0;
        NSTimeInterval fadeDuration = 1.0 * transitionDuration / 3.0;
        [zoomContainer zoomToPoint:[zoomFromVC zoomToPoint] size:[zoomFromVC zoomToSize] zoomAxis:CHWUIViewZoomYAxis duration:zoomDuration completion:^(BOOL finished) {
            toView.alpha = 1.0;
            [UIView animateWithDuration:fadeDuration animations:^{
                zoomContainer.alpha = 0;
            } completion:^(BOOL finished) {
                [zoomContainer removeFromSuperview];
                [transitionContext completeTransition:finished];
            }];
        }];
    }
/*    else if (!self.isPresenting && [toViewController conformsToProtocol:@protocol(ZoomTransitionDelegate)]) {
        //back transition
        UIViewController <ZoomTransitionDelegate>* zoomToVC = (UIViewController <ZoomTransitionDelegate>*)toViewController;
        toView.frame = CGRectMake(toView.frame.origin.x + toView.frame.size.width, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.width);

        UIView *zoomContainer = [[UIView alloc] initWithFrame:fromView.frame];
//        UIView *fromSnapshot = [fromView snapshotViewAfterScreenUpdates:YES];
        // We are responsible for adding the incoming view to the containerView
        // for the presentation/dismissal.
//        fromView.alpha = 0.0;
//        fromSnapshot.alpha = 1.0;
        
        toView.alpha = 1.0;
        zoomContainer.alpha = 0.0;

        [containerView addSubview:toView];
//        [containerView addSubview:fromSnapshot];
        [containerView addSubview:zoomContainer];
        [containerView bringSubviewToFront:zoomContainer];
        UIView *toSnapshot = [toView snapshotViewAfterScreenUpdates:YES];
        [zoomContainer addSubview:toSnapshot];
//        [containerView bringSubviewToFront:fromSnapshot];
//        toView.alpha = 0.0;
        NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
        NSTimeInterval zoomDuration = 2.0 * transitionDuration / 3.0;
        NSTimeInterval fadeDuration = 1.0 * transitionDuration / 3.0;
        zoomContainer.alpha = 1.0;
        
        toSnapshot.frame = [transitionContext finalFrameForViewController:toViewController];
        [zoomContainer zoomToPoint:[zoomToVC zoomToPoint] size:[zoomToVC zoomToSize] zoomAxis:CHWUIViewZoomYAxis duration:0.0 completion:^(BOOL finished) {
            fromView.alpha = 0.0;
            toView.frame = [transitionContext finalFrameForViewController:toViewController];
            [zoomContainer zoomOutToFullScreenWithDuration:zoomDuration completion:^(BOOL finished) {
                toView.alpha = 1.0;
                [zoomContainer removeFromSuperview];
//                    [fromSnapshot removeFromSuperview];
                [transitionContext completeTransition:finished];
            }];
            }];
    }*/
    else {
    //do basic fade transition instead.....
        UIView *snapShot = [fromView snapshotViewAfterScreenUpdates:YES];
        snapShot.alpha = 1.0f;
        toView.alpha = 0.0f;
        
        // We are responsible for adding the incoming view to the containerView
        // for the presentation/dismissal.
        [containerView addSubview:toView];
        [containerView addSubview:snapShot];
        
        NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
        
        [UIView animateWithDuration:transitionDuration animations:^{
            snapShot.alpha = 0.0f;
            toView.alpha = 1.0;
        } completion:^(BOOL finished) {
            // When we complete, tell the transition context
            // passing along the BOOL that indicates whether the transition
            // finished or not.
            BOOL success = ![transitionContext transitionWasCancelled];
            //        if(success && !self.isPresenting) {
            //            [toView removeFromSuperview];
            //        }
            [snapShot removeFromSuperview];
            [transitionContext completeTransition:success];
        }];
    }
    
    
    
}

@end
