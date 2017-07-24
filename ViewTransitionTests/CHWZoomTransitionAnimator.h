//
//  CHWZoomTransitionAnimator.h
//  ChwarelHospital
//
//  Created by Nicholas Jones on 18/07/2017.
//  Copyright © 2017 Richard Wylie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHWZoomTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic) BOOL isPresenting;

-(instancetype)initWithPresenting:(BOOL)isPresenting zoomPoint:(CGPoint)zoomPoint zoomSize:(CGSize)zoomSize;

@end
