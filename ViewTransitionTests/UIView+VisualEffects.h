//
//  UIView+VisualEffects.h
//  ChwarelHospital
//
//  Created by Nicholas Jones on 09/06/2017.
//  Copyright © 2017 Richard Wylie. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CHWUIViewZoomAxis) {
    CHWUIViewZoomBothAxis,
    CHWUIViewZoomXAxis,
    CHWUIViewZoomYAxis,
};


@interface UIView (VisualEffects)
- (void)beginZoomToView:(UIView*)view zoomAxis:(CHWUIViewZoomAxis)zoomAxis duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;
- (void)zoomOutToFullScreenWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

-(void)zoomToPoint:(CGPoint)zoomPoint size:(CGSize)zoomAmount zoomAxis:(CHWUIViewZoomAxis)zoomAxis duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;



- (void)showZoomCenterPoint;
- (void)showViewFrame;
- (void)showAnchor;

- (void)horizontalTranslation:(float)pixelDisplacement duration:(NSTimeInterval)duration bothDirections:(BOOL)bothDirections times:(NSInteger)numberOfCycles;

- (void)wobbleView;
- (void)wobbleViewIntensity:(float)intensity times:(NSInteger)numberOfWobbles;
- (void)pulseView;
- (void)pulseViewIntensity:(float)intensity times:(NSInteger)numberOfPulses;

- (void)mutablePulseViewWithMinIntensity:(float)minIntensity maxIntensity:(float)maxIntensity duration:(float)duration times:(NSInteger)numberOfPulses;


-(void)rotateView;
@end
