//
//  CanvasViewController.m
//  Canvas
//
//  Created by Tejas Lagvankar on 2/12/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import "CanvasViewController.h"

@interface CanvasViewController ()
@property(nonatomic, weak) IBOutlet UIImageView *drawerHandleImage;
@property (weak, nonatomic) IBOutlet UIView *drawerView;
@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, assign) BOOL drawerOpen;

@end

@implementation CanvasViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.drawerOpen = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)onDrawerPanned:(UIPanGestureRecognizer *)sender {

    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];

    if (sender.state == UIGestureRecognizerStateBegan) {
        self.originalCenter = self.drawerView.center;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.drawerView.center = CGPointMake(self.originalCenter.x, self.originalCenter.y + translation.y);
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (velocity.y > 0) { // snap down
            [self closeDrawer];
        } else { //Snap up
            [self openDrawer];
        }
    }
}
- (IBAction)drawerHandleTapped:(UITapGestureRecognizer *)sender {
    if (self.drawerOpen) {
        [self closeDrawer];
    } else {
        [self openDrawer];
    }
}

- (void)closeDrawer {
    CGRect frame = self.drawerView.frame;
    frame.origin.y = self.view.frame.size.height - 50;
    [UIView animateWithDuration:0.3 animations:^{
        self.drawerView.frame = frame;
        self.drawerHandleImage.transform = CGAffineTransformRotate(self.drawerHandleImage.transform, M_PI);
    }];

    self.drawerOpen = NO;
}

- (void)openDrawer {
    CGRect frame = self.drawerView.frame;
    frame.origin.y = self.view.frame.size.height - self.drawerView.frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.drawerView.frame = frame;
        self.drawerHandleImage.transform = CGAffineTransformRotate(self.drawerHandleImage.transform, M_PI);
    }];

    self.drawerOpen = YES;
}


@end
