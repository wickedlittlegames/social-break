//
//  Ball.h
//  Social Breakout
//
//  Created by Andrew Girvan on 11/01/2012.
//  Copyright (c) 2012 Wicked Little Websites. All rights reserved.
//

#import "Block.h"
#import "InternetImage.h"

#define kLifeLineY 440

@interface Ball : UIView
{
    UIImageView *ballView;
    CGFloat bouncyness; //Not used.
    CGPoint speed, save_speed;
    CGFloat accelleration; //Not used.
    CGPoint direction;
    InternetImage *asynchImage;
}

@property (nonatomic) CGPoint speed, direction;
@property (nonatomic) bool tweetPanelAnimating;

- (Ball *) initWithPosition:(CGPoint) position; //Initiates the ball at a given position.
- (void) update; //Moves the ball accordingly.
- (BOOL) isPositionValid; //Checks for the validity of the ball's position.
- (BOOL) isWithinStageBounds; //Checks if the ball is within the bounds of the stage.
- (BOOL) isAboveLifeLine; //Checks if the ball is above the paddle.
- (CGPoint) nextPosition; //Returns the ball's next position.
- (void) bounce; //Changes the direction of the ball.
- (void) bouncedown; //Changes the direction of the ball.
- (void) resetAtPosition:(CGPoint) position; //Resets the ball at a given position. 
- (void) slowMoBeginwithTweet:(NSArray*)tweet_data withLabelUser:(UILabel*)userLabel withLabelTweet:(UILabel*)tweetLabel withAvatar:(UIImageView*)avatarImage withPanel:(UIImageView*)panelImage;
- (void) slowMoEnd:(NSTimer*)theTimer;

- (void) downloadImageFromInternet:(NSString*) urlToImage;
- (void) internetImageReady:(InternetImage*)downloadedImage;

@end
