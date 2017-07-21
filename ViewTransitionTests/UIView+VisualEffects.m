//
//  UIView+VisualEffects.m
//  ChwarelHospital
//
//  Created by Nicholas Jones on 09/06/2017.
//  Copyright © 2017 Richard Wylie. All rights reserved.
//

#import "UIView+VisualEffects.h"

@implementation UIView (VisualEffects)

- (void)beginZoomToView:(UIView*)view zoomAxis:(CHWUIViewZoomAxis)zoomAxis completion:(void (^)(BOOL finished))completion {
    CGFloat dX = self.frame.size.width / view.frame.size.width;
    CGFloat dY = self.frame.size.height / view.frame.size.height;

    CGPoint viewCenter = [self convertPoint:view.center toView:self];
    
    switch (zoomAxis) {
        case CHWUIViewZoomXAxis:
            dY = dX;
            break;
        case CHWUIViewZoomYAxis:
            dX = dY;
        default:
            break;
    }
    
    CGAffineTransform tr = CGAffineTransformScale(self.transform, dX, dY);
    
    CGPoint centerAnchor = CGPointMake(viewCenter.x / self.frame.size.width, viewCenter.y / self.frame.size.height);
    [self setAnchorPoint:centerAnchor];
                                       
    NSLog(@"*** ZOOM IN ********************************************");
    NSLog(@"PARENT : %@", self);
    NSLog(@"ZOOM : %@", view);
    NSLog(@"dX dY : %f %f", dX, dY);

    [UIView animateWithDuration:2.5 delay:0 options:0 animations:^{
        self.transform = tr;
    } completion:^(BOOL finished) {
        NSLog(@"*** ZOOM IN COMPLETE ********************************************");
        NSLog(@"PARENT : %@", self);
        NSLog(@"ZOOM : %@", view);
        NSLog(@"dX dY : %f %f", dX, dY);
       completion(finished);
    }];
}

- (void)zoomOutToFullScreenFromView:(UIView*)view zoomAxis:(CHWUIViewZoomAxis)zoomAxis completion:(void (^)(BOOL finished))completion {
    CGFloat dX =  self.superview.frame.size.width / self.frame.size.width;
    CGFloat dY =  self.superview.frame.size.height / self.frame.size.height;
    
    CGPoint viewCenter = [self convertPoint:view.center toView:self];
    
    switch (zoomAxis) {
        case CHWUIViewZoomXAxis:
            dY = dX;
            break;
        case CHWUIViewZoomYAxis:
            dX = dY;
        default:
            break;
    }
    
    CGAffineTransform tr = CGAffineTransformScale(self.transform, dX, dY);
    
    CGPoint centerAnchor = CGPointMake(viewCenter.x / self.frame.size.width, viewCenter.y / self.frame.size.height);
    [self setAnchorPoint:centerAnchor];

    [UIView animateWithDuration:2.5 delay:0 options:0 animations:^{
        self.transform = tr;
    } completion:^(BOOL finished) {
        completion(finished);
        NSLog(@"*** ZOOM OUT COMPLETE ********************************************");
        NSLog(@"PARENT : %@", self);
        NSLog(@"ZOOM : %@", view);
        NSLog(@"dX dY : %f %f", dX, dY);
    }];
    
}


- (void)setAnchorPoint:(CGPoint)anchorPoint
{
    CGPoint newPoint = CGPointMake(self.bounds.size.width * anchorPoint.x, self.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(self.bounds.size.width * self.layer.anchorPoint.x, self.bounds.size.height * self.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, self.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform);
    
    CGPoint position = self.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    self.layer.position = position;
    self.layer.anchorPoint = anchorPoint;
}

- (void)showZoomCenterPoint {
    UIView *doorCenter = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:doorCenter];
    doorCenter.backgroundColor = [UIColor redColor];
    doorCenter.translatesAutoresizingMaskIntoConstraints = false;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:doorCenter attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:doorCenter attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [doorCenter addConstraint:[NSLayoutConstraint constraintWithItem:doorCenter attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20]];
    [doorCenter addConstraint:[NSLayoutConstraint constraintWithItem:doorCenter attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20]];
    
}

- (void)showViewFrame {
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [UIColor redColor].CGColor;
}


- (void)wobbleViewIntensity:(float)intensity times:(NSInteger)numberOfWobbles {
    [self.layer removeAllAnimations];

    CAKeyframeAnimation *rotationAnimation;
    
    rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    float wobbleAngle = M_PI * intensity;
    
    rotationAnimation.values = [NSArray arrayWithObjects:@0, @(-wobbleAngle), @(wobbleAngle), @(0), nil];
    
    rotationAnimation.duration = 1.0f;
    rotationAnimation.cumulative = NO;
    rotationAnimation.repeatCount = numberOfWobbles;
    
    [self.layer addAnimation:rotationAnimation forKey:@"animateWobble"];
}

- (void)wobbleView {
    [self wobbleViewIntensity:0.04 times:8];
}


- (void)pulseView{
    [self pulseViewIntensity:1.1 times:10];
}

- (void)pulseViewIntensity:(float)intensity times:(NSInteger)numberOfPulses {
    [self.layer removeAllAnimations];
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    theAnimation.duration=1.0;
    theAnimation.repeatCount=numberOfPulses;
    theAnimation.autoreverses=YES;
    theAnimation.toValue=[NSNumber numberWithFloat:intensity];
    [self.layer addAnimation:theAnimation forKey:@"animatePulse"];
}

- (void)mutablePulseViewWithMinIntensity:(float)minIntensity maxIntensity:(float)maxIntensity duration:(float)duration times:(NSInteger)numberOfPulses {
    CAKeyframeAnimation *theAnimation;
    float timeOffset = 0;
    if([self.layer animationForKey:@"multableAnimatePulse"]) {
        theAnimation = (CAKeyframeAnimation*)[self.layer animationForKey:@"multableAnimatePulse"];
        timeOffset = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    }
    [self.layer removeAllAnimations];
    theAnimation = [CAKeyframeAnimation animation];
    theAnimation.keyPath = @"transform.scale";
    theAnimation.values = @[@(minIntensity), @(maxIntensity), @(minIntensity)];
    theAnimation.keyTimes = @[@(0), @(0.5), @(1.0)];
    
    theAnimation.timeOffset = timeOffset;
    
    theAnimation.repeatCount = numberOfPulses;
    theAnimation.duration = duration;
    theAnimation.additive = NO;
    theAnimation.autoreverses = NO;
    theAnimation.fillMode = kCAFillModeForwards;
    [theAnimation setRemovedOnCompletion:NO];
    [self.layer addAnimation:theAnimation forKey:@"multableAnimatePulse"];
}

- (void)horizontalTranslation:(float)pixelDisplacement duration:(NSTimeInterval)duration bothDirections:(BOOL)bothDirections times:(NSInteger)numberOfCycles {
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    theAnimation.duration= duration;
    theAnimation.repeatCount= numberOfCycles;
    theAnimation.autoreverses=bothDirections;
    theAnimation.toValue=[NSNumber numberWithFloat:pixelDisplacement];
    [self.layer addAnimation:theAnimation forKey:@"animateXTranslation"];
}

@end
