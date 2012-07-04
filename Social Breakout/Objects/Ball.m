//
//  Ball.m
//  Social Breakout
//
//  Created by Andrew Girvan on 11/01/2012.
//  Copyright (c) 2012 Wicked Little Websites. All rights reserved.
//

#import "Ball.h"

@implementation Ball

@synthesize speed, direction, tweetPanelAnimating;

NSTimer *slowMoTimer;
UIImageView *avatarImageRetain;

- (Ball *) initWithPosition:(CGPoint) position {
    
    if((self = [super init])){
        
        bouncyness = 1.0;
        speed = CGPointMake(3.0, 3.0);
        accelleration = 0.0;
        direction = CGPointMake(1.0, 1.0);
        
        
        ballView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ball.png"]];
        self.frame = CGRectMake(position.x, position.y, ballView.frame.size.width, ballView.frame.size.height);
        [self addSubview:ballView];
    }
    
    return self;
    
}

- (void) update{
    
    //Keep adjusting the ball's position untill a valid one if found.
    while(![self isPositionValid]);
    self.center = [self nextPosition];
    
}

- (BOOL) isPositionValid {
    
    if([self isWithinStageBounds]){
        return YES;
    }
    
    return NO;
    
}

- (BOOL) isWithinStageBounds {
    
    //Check of if the ball is within the bounds of the stage
    
    CGPoint nextPosition = [self nextPosition];
    
    if(nextPosition.x >= self.superview.frame.origin.x + self.frame.size.width/2 && 
       nextPosition.x + self.frame.size.width/2 <=  self.superview.frame.origin.x+self.superview.frame.size.width){
        if (nextPosition.y >= self.superview.frame.origin.y && 
            nextPosition.y + self.frame.size.height/2 <= self.superview.frame.origin.y + self.superview.frame.size.height) {
            return YES;
        } else { 
            direction.y *= -1;
        }
        
    } else { 
        direction.x *= -1;
    }
    
    return NO;
    
}

- (BOOL) isAboveLifeLine {
    
    if(self.center.y > kLifeLineY)
        return NO;
    
    return YES;
}

- (CGPoint) nextPosition {
    
    return CGPointMake(self.center.x+(speed.x*direction.x), self.center.y+(speed.y*direction.y));
    
}

- (void) bounce {   
    direction.x *=1;
    direction.y *=-1;
}
- (void) bouncedown {   
    direction.x *=-1;
    direction.y = 1;
}

- (void) slowMoBeginwithTweet:(NSArray*)tweet_data withLabelUser:(UILabel*)userLabel withLabelTweet:(UILabel*)tweetLabel withAvatar:(UIImageView*)avatarImage withPanel:(UIImageView*)panelImage
{
    if ( slowMoTimer == nil && tweetPanelAnimating == NO)
    {
        avatarImageRetain.image = [UIImage imageNamed:@"block_tweet.png"];
        //tweetLabel.text = @"";
        //[tweetLabel sizeToFit];
        
        tweetLabel.text = [NSString stringWithFormat:@"%@", [tweet_data objectAtIndex:0]];
        //[tweetLabel sizeToFit];

        userLabel.text  = [NSString stringWithFormat:@"@%@ tweeted:", [tweet_data objectAtIndex:2]];
        
        [tweetLabel setAlpha:0];
        [userLabel setAlpha:0];
        [panelImage setAlpha:0];
        [avatarImage setAlpha:0];
        avatarImageRetain = avatarImage;
        [self downloadImageFromInternet:[tweet_data objectAtIndex:1]];
        
        tweetLabel.hidden = NO;
        userLabel.hidden = NO;
        avatarImage.hidden = NO;
        panelImage.hidden = NO;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView setAnimationDuration:0.5];
        [tweetLabel setAlpha:1];
        [userLabel setAlpha:1];
        [panelImage setAlpha:1];
        [avatarImage setAlpha:1];
        [UIView commitAnimations];
        
        save_speed = CGPointMake(speed.x, speed.y);
        //NSLog(@"SET SPEED TO 0.3!!!");
        speed = CGPointMake(0.3,0.3);
        //NSLog(@"SET SPEED TO 0.3!!!"); 
        
        //NSLog(@"Start the slow mo timer to end");
        //NSLog(@"Speed saved: x | y - %f, %f",save_speed.x, save_speed.y);
        //NSLog(@"Speed new: x | y - %f, %f",speed.x, speed.y);        
        tweetPanelAnimating = YES;
        
        NSDictionary *values = [NSDictionary dictionaryWithObjectsAndKeys:
                                tweetLabel,@"tweetlabel",
                                userLabel, @"userlabel",
                                panelImage, @"panelImage", 
                                avatarImage, @"avatarImage", nil];
        
        slowMoTimer = [NSTimer scheduledTimerWithTimeInterval:[[[NSUserDefaults standardUserDefaults] valueForKey:@"tweetTimer"] intValue]
                                                       target:self
                                                     selector:@selector(slowMoEnd:)
                                                     userInfo:values
                                                      repeats:NO];
    }

        
  
}


- (void) slowMoEnd:(NSTimer*)theTimer {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:0.5];
    [[[theTimer userInfo] objectForKey:@"tweetlabel"] setAlpha:0];
    [[[theTimer userInfo] objectForKey:@"userlabel"] setAlpha:0];
    [[[theTimer userInfo] objectForKey:@"panelImage"] setAlpha:0];
    [[[theTimer userInfo] objectForKey:@"avatarImage"] setAlpha:0];
    [UIView commitAnimations];
    tweetPanelAnimating = NO;
    speed = CGPointMake(save_speed.x, save_speed.y);
    tweetPanelAnimating = NO;    
    [slowMoTimer invalidate];
    slowMoTimer = nil;    
}

- (void) downloadImageFromInternet:(NSString*) urlToImage
{
	// Create a instance of InternetImage
	asynchImage = [[InternetImage alloc] initWithUrl:urlToImage];
	
	// Start downloading the image with self as delegate receiver
	[asynchImage downloadImage:self];
}


-(void) internetImageReady:(InternetImage*)downloadedImage
{	
	// The image has been downloaded. Put the image into the UIImageView
	[avatarImageRetain setImage:downloadedImage.Image];
}

- (void) resetAtPosition:(CGPoint) position {
    
    self.frame = CGRectMake(position.x, position.y, ballView.frame.size.width, ballView.frame.size.height);
    direction.x=1;
    direction.y=1;
    bouncyness = 1.0;
    accelleration = 0.0;
    speed = CGPointMake(3.0, 3.0);
}

@end
