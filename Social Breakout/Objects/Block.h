//
//  Block.h
//  Social Breakout
//
//  Created by Andrew Girvan on 11/01/2012.
//  Copyright (c) 2012 Wicked Little Websites. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InternetImage.h"

#define HIT YES
#define NO_HIT NO
#define kBlockMaxHealth 4
#define kBlockHeight 25
#define kBlockWidth 25  

@interface Block : UIView
{
    
    UIImageView *blockView;
    short int maxHealth;
    short int currentHealth;
    NSString *tweet_text; 
    NSArray *tweet_data;
    InternetImage *asynchImage;
}

@property (nonatomic,retain) NSString *tweet_text;
@property (nonatomic,retain) NSArray *tweet_data;

- (BOOL) isImpactWithBallAtPosition:(CGPoint) ballPosition; //Checks for block-ball impact.
- (BOOL) isImpactWithBallOnSides:(CGRect)ball;
- (int) update; //Updates the position of the ball accordingly.

+ (Block *) blockAtPosition:(CGPoint) position;
+ (Block *) blockAtPosition:(CGPoint) position withImageNamed:(NSString *) imgName;
+ (Block *) blockAtPosition:(CGPoint) position withExternalImageNamed:(NSString *) imgName;
- (Block *) initAtPosition:(CGPoint) position;
- (Block *) initAtPosition:(CGPoint) position withImageNamed:(NSString *) imgName;
- (Block *) initAtPosition:(CGPoint) position withExternalImageNamed:(NSString *) imgName;

- (void) downloadImageFromInternet:(NSString*) urlToImage;
- (void) internetImageReady:(InternetImage*)downloadedImage;
- (BOOL) isImpactWithBall:(CGRect)ballRect;
@end
