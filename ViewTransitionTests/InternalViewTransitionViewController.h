//
//  InternalViewTransitionViewController.h
//  ViewTransitionTests
//
//  Created by Nicholas Jones on 21/07/2017.
//  Copyright © 2017 touchsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZoomTransitionDelegate
-(CGPoint)zoomToPoint;
-(CGSize)zoomToSize;
@optional
-(CGPoint)zoomFromPoint;
-(CGSize)zoomFromSize;
@end

@interface InternalViewTransitionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *zoomToView;
@property (weak, nonatomic) IBOutlet UIView *zoomAreaView;
@property (weak, nonatomic) IBOutlet UIView *zoomAreaSibling;

@end
