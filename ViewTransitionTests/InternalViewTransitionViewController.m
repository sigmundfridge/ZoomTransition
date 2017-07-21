//
//  InternalViewTransitionViewController.m
//  ViewTransitionTests
//
//  Created by Nicholas Jones on 21/07/2017.
//  Copyright © 2017 touchsoft. All rights reserved.
//

#import "InternalViewTransitionViewController.h"
#import "UIView+VisualEffects.h"

@interface InternalViewTransitionViewController ()

@end

@implementation InternalViewTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.zoomToView showViewFrame];
    [self.zoomToView showZoomCenterPoint];
    [self.zoomAreaView showViewFrame];
    [self.zoomAreaView showZoomCenterPoint];
    [self.zoomAreaSibling showViewFrame];
    [self.zoomAreaSibling showZoomCenterPoint];
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
    [self.zoomAreaView beginZoomToView:_zoomToView zoomAxis:(CHWUIViewZoomBothAxis) completion:^(BOOL finished) {
        
    }];
}

- (IBAction)zoomOutPressed:(id)sender {
    [self.zoomAreaView zoomOutToFullScreenFromView:_zoomToView zoomAxis:CHWUIViewZoomBothAxis completion:^(BOOL finished) {
    }];

}

@end
