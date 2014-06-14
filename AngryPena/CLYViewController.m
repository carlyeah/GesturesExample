//
//  CLYViewController.m
//  AngryPena
//
//  Created by Carlos Eduardo López Mercado on 6/12/14.
//  Copyright (c) 2014 Carlos Eduardo López Mercado. All rights reserved.
//

#import "CLYViewController.h"
#import "CLYSystemSounds.h"

@interface CLYViewController ()

@property (strong, nonatomic) UIImageView *lastShot;

@property (nonatomic, strong) NSArray *showSprite;
@property (nonatomic, strong) NSArray *hideSprite;

@property (nonatomic, strong) UIImageView *tapeView;


@end

@implementation CLYViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [[CLYSystemSounds sharedSystemSounds] worstEnglishSpeakingEver];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];

    //Sprites
    self.showSprite = @[
            [UIImage imageNamed: @"tape1.png"],
            [UIImage imageNamed: @"tape2.png"],
            [UIImage imageNamed: @"tape3.png"],
            [UIImage imageNamed: @"tape4.png"]];

    self.hideSprite = @[
            [UIImage imageNamed: @"tape4.png"],
            [UIImage imageNamed: @"tape3.png"],
            [UIImage imageNamed: @"tape2.png"],
            [UIImage imageNamed: @"tape1.png"]];

    //Create recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                          action: @selector(didTap:)];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget: self
                                                                          action: @selector(didPan:)];

    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(didSwipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;

    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(didSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;


    [pan requireGestureRecognizerToFail:rightSwipe];
    [pan requireGestureRecognizerToFail:leftSwipe];

    //add recognizers to view

    [self.view addGestureRecognizer: tap];
    [self.view addGestureRecognizer: pan];
    [self.view addGestureRecognizer: rightSwipe];
    [self.view addGestureRecognizer: leftSwipe];



}

#pragma mark - actions

- (void)didTap:(UITapGestureRecognizer *)tap {
    if(tap.state == UIGestureRecognizerStateRecognized){
        UIImageView *crack =
                [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"crackedGlass.png"]];

        crack.center = [tap locationInView: self.penaView];

        [self.penaView addSubview: crack];

        //play sound

        [self playPunch];
    }
}

- (void)didPan:(UIPanGestureRecognizer *)pan {
    if(pan.state == UIGestureRecognizerStateChanged) {

        CGPoint currentPosition = [pan locationInView: self.penaView];
        CGRect lastShot = self.lastShot.frame;

        if(!CGRectContainsPoint( lastShot, currentPosition)) {

            UIImageView *shot = [[UIImageView alloc]
                    initWithImage:[UIImage imageNamed:@"squashed_tomato.png"]];

            shot.center = [pan locationInView:self.penaView];

            [self.penaView addSubview:shot];

            self.lastShot = shot;
        }
    } else if( pan.state == UIGestureRecognizerStateBegan){
        [[CLYSystemSounds sharedSystemSounds] startTomatoes];
    } else if( pan.state == UIGestureRecognizerStateEnded){
        [[CLYSystemSounds sharedSystemSounds] stopTomatoes];
    }

}

- (void)didSwipe:(UISwipeGestureRecognizer *)swipe {
    if(swipe.state == UIGestureRecognizerStateRecognized){
        if(!self.tapeView && swipe.direction == UISwipeGestureRecognizerDirectionRight){

            [[CLYSystemSounds sharedSystemSounds] putTape];

            //time to draw the tape
            self.tapeView = [[UIImageView alloc] initWithImage: [UIImage imageNamed :@"tape4.png"]];
            self.tapeView.animationImages = self.showSprite;
            self.tapeView.animationRepeatCount = 1; // 0 indicates an infinite loop
            self.tapeView.animationDuration = 0.2; //seconds
            self.tapeView.center = [swipe locationInView: self.penaView];
            [self.penaView addSubview: self.tapeView];
            [self.tapeView startAnimating];

        } else if(swipe.direction == UISwipeGestureRecognizerDirectionLeft){

            [[CLYSystemSounds sharedSystemSounds] removeTape];

            //remove the tape
            self.tapeView.animationImages = self.hideSprite;
            //after an animation, an imageview show the value it has in its image property
            self.tapeView.image = nil;

            [self.tapeView startAnimating];

            double delayInSeconds = 0.4;

            //apply animation after delay of 4 seconds
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delayInSeconds * NSEC_PER_SEC));
            
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                //remove tape
                [self.tapeView removeFromSuperview];
                self.tapeView = nil;
            });

        }
    }
}

#pragma mark - Shake
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if(motion == UIEventSubtypeMotionShake){
        //this is a real shake!
        for (UIView *view in self.penaView.subviews) {
            [view removeFromSuperview];
        }

        self.tapeView = nil;

        [[CLYSystemSounds sharedSystemSounds] putTape];
    }
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - Play
-(void) playPunch{
    [[CLYSystemSounds sharedSystemSounds] punch];
}



@end
