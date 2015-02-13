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
@property (nonatomic, assign) CGPoint originalDrawerCenter;
@property (nonatomic, assign) BOOL drawerOpen;

@property (nonatomic, assign) CGFloat scaleFactor;

@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;
@property (weak, nonatomic) IBOutlet UIImageView *img5;
@property (weak, nonatomic) IBOutlet UIImageView *img6;

@property (nonatomic, assign) CGPoint originalImgCenter;
@property (nonatomic, strong) UIImageView *imageBeingPanned;


@end

@implementation CanvasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scaleFactor = 1.5;

    [self setUpImgPanGestureRecognizer];

    self.drawerOpen = YES;
}

- (void)setUpImgPanGestureRecognizer {
    // The onCustomPan: method will be defined in Step 3 below.
    UIPanGestureRecognizer *panGestureRecognizer1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onImageFromDrawerPanned:)];
    [self.img1 addGestureRecognizer:panGestureRecognizer1];

    UIPanGestureRecognizer *panGestureRecognizer2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onImageFromDrawerPanned:)];
    [self.img2 addGestureRecognizer:panGestureRecognizer2];

    UIPanGestureRecognizer *panGestureRecognizer3 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onImageFromDrawerPanned:)];
    [self.img3 addGestureRecognizer:panGestureRecognizer3];

    UIPanGestureRecognizer *panGestureRecognizer4 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onImageFromDrawerPanned:)];
    [self.img4 addGestureRecognizer:panGestureRecognizer4];

    UIPanGestureRecognizer *panGestureRecognizer5 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onImageFromDrawerPanned:)];
    [self.img5 addGestureRecognizer:panGestureRecognizer5];

    UIPanGestureRecognizer *panGestureRecognizer6 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onImageFromDrawerPanned:)];
    [self.img6 addGestureRecognizer:panGestureRecognizer6];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)onDrawerPanned:(UIPanGestureRecognizer *)sender {

    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];

    if (sender.state == UIGestureRecognizerStateBegan) {
        self.originalDrawerCenter = self.drawerView.center;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.drawerView.center = CGPointMake(self.originalDrawerCenter.x, self.originalDrawerCenter.y + translation.y);
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


- (void)onImageFromDrawerPanned:(UIPanGestureRecognizer *)panGestureRecognizer {

    /*
    if ([panGestureRecognizer.view isEqual:self.img1]) {
        NSLog(@"Panning image1");
    } else if ([panGestureRecognizer.view isEqual:self.img2]) {
        NSLog(@"Panning image2");
    } else if ([panGestureRecognizer.view isEqual:self.img3]) {
        NSLog(@"Panning image3");
    } else if ([panGestureRecognizer.view isEqual:self.img4]) {
        NSLog(@"Panning image4");
    } else if ([panGestureRecognizer.view isEqual:self.img5]) {
        NSLog(@"Panning image5");
    } else if ([panGestureRecognizer.view isEqual:self.img6]) {
        NSLog(@"Panning image6");
    }
    */

    CGPoint translation = [panGestureRecognizer translationInView:self.view];

    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.imageBeingPanned = [[UIImageView alloc] initWithFrame:panGestureRecognizer.view.frame];
        [self.imageBeingPanned setUserInteractionEnabled:YES];
        self.imageBeingPanned.image = [(UIImageView *)panGestureRecognizer.view image];
        [self.view addSubview:self.imageBeingPanned];
        CGPoint center = CGPointMake(panGestureRecognizer.view.center.x, panGestureRecognizer.view.center.y + self.drawerView.frame.origin.y);
        self.imageBeingPanned.center = center;
        self.originalImgCenter = self.imageBeingPanned.center;

        self.imageBeingPanned.transform = CGAffineTransformMakeScale(self.scaleFactor, self.scaleFactor);

    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.imageBeingPanned.center = CGPointMake(self.originalImgCenter.x + translation.x, self.originalImgCenter.y + translation.y);
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.imageBeingPanned.transform = CGAffineTransformMakeScale(1, 1);
        [self configureNewImage:self.imageBeingPanned];
    }
}

-(void)configureNewImage:(UIImageView *)image {
    UIPanGestureRecognizer *yetAnotherPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onImagePanned:)];
    [image addGestureRecognizer:yetAnotherPanGestureRecognizer];
}

- (void)onImagePanned:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.originalImgCenter = panGestureRecognizer.view.center;
        panGestureRecognizer.view.transform = CGAffineTransformMakeScale(self.scaleFactor, self.scaleFactor);
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        panGestureRecognizer.view.center = CGPointMake(self.originalImgCenter.x + translation.x, self.originalImgCenter.y + translation.y);
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        panGestureRecognizer.view.transform = CGAffineTransformMakeScale(1, 1);

    }
}

@end
