//
//  Block.m
//  Social Breakout
//
//  Created by Andrew Girvan on 11/01/2012.
//  Copyright (c) 2012 Wicked Little Websites. All rights reserved.
//

#import "Block.h"

@implementation Block
@synthesize tweet_text, tweet_data;

- (Block *) initAtPosition:(CGPoint) position {
    
    if((self = [super init])){
        currentHealth = 1;
        int colorpick = rand()%5;
        if ( colorpick == 3 )
        {
            blockView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"block_green.png"]];
        }
        else if ( colorpick == 2 )
        {
            blockView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"block_blue.png"]];
        }
        else if ( colorpick == 1 )
        {
            blockView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"block_pink.png"]];
        }
        else if ( colorpick == 4 )
        {
            blockView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"block_purple.png"]];
        }
        else
        {
            blockView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"block_red.png"]];
        }
        self.frame = CGRectMake(position.x, position.y, blockView.frame.size.width, blockView.frame.size.height);
        [self addSubview:blockView];
    }
    
    return self;
    
}

- (Block *) initAtPosition:(CGPoint) position withImageNamed:(NSString *) imgName {
    
    if((self = [super init])){
        currentHealth = 1;
        blockView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        //self.frame = CGRectMake(position.x, position.y, blockView.frame.size.width, blockView.frame.size.height);
        self.frame = CGRectMake(position.x, position.y, blockView.frame.size.width, blockView.frame.size.height);        
        [self addSubview:blockView];
    }
    
    return self;
    
}

- (Block *) initAtPosition:(CGPoint) position withExternalImageNamed:(NSString *) imgName {
    
    if((self = [super init])){
        
        maxHealth = 1; //No Zero health Blocks
        currentHealth = maxHealth;
        blockView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"block_red.png"]];
        
        [self downloadImageFromInternet:imgName];
        self.frame = CGRectMake(position.x, position.y, blockView.frame.size.width, blockView.frame.size.height);
        [self addSubview:blockView];
    }
    
    return self;
    
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
	[blockView setImage:downloadedImage.Image];
}


+ (Block *) blockAtPosition:(CGPoint) position {
    
    return [[Block alloc] initAtPosition:position];
    
}

+ (Block *) blockAtPosition:(CGPoint) position withImageNamed:(NSString *) imgName {
    
    return [[Block alloc] initAtPosition:position withImageNamed:imgName];
    
}

+ (Block *) blockAtPosition:(CGPoint) position withExternalImageNamed:(NSString *) imgName {
    
    return [[Block alloc] initAtPosition:position withExternalImageNamed:imgName];
    
}

- (BOOL) isImpactWithBallOnSides:(CGRect)ball
{
    if ( ball.origin.y <= self.frame.origin.y - (25/2) )
    {
        return NO;
    }
    if  ( ball.origin.y >= self.center.y + (25/2) )
    {
        return NO;
    }
    if ( ball.origin.x < self.center.x )
    {
        return YES;
    }
    if ( ball.origin.x > self.center.x ) 
    {
        return YES;
    }
    
    return NO;
}

- (BOOL) isImpactWithBallAtPosition:(CGPoint) ballPosition {
    
    
    //Check for a ball impact.
    if(ballPosition.y >= self.center.y - self.frame.size.height/2 && 
       ballPosition.y <= self.center.y + self.frame.size.height/2){
        
        if(ballPosition.x >= self.center.x - self.frame.size.width/2 && 
           ballPosition.x <= self.center.x + self.frame.size.width/2){
            
            return HIT;
            
        }
    }
    
    
    return NO_HIT;    
}

- (BOOL) isImpactWithBall:(CGRect)ballRect
{
    return CGRectIntersectsRect(ballRect, self.frame);
    
}

- (int) update{ return --currentHealth; }

@end
