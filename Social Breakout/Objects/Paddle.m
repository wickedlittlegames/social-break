//
//  Paddle.m
//  Social Breakout
//
//  Created by Andrew Girvan on 11/01/2012.
//  Copyright (c) 2012 Wicked Little Websites. All rights reserved.
//

#import "Paddle.h"

@implementation Paddle

-(Paddle *) init {
    
    
    if((self = [super init])){
        
    }
    
    return self;
}

- (BOOL) isImpactWithBall:(CGRect)ball
{
    if( CGRectIntersectsRect(self.frame, ball) )
   {
       if ( ball.origin.y > (self.frame.origin.y - (self.frame.size.height/2)) )
       {
               //NSLog(@"Bounce!");
       }
       return YES;
   }
   else
   {
       return NO;
   }
}

+ (Paddle *) blockAtPosition:(CGPoint) position withImageNamed:(NSString *) imgName {
    
    return [[Paddle alloc] initAtPosition:position withImageNamed:imgName];
    
}

- (void) resetAtPosition:(CGPoint) position {
    
    self.frame = CGRectMake(position.x, position.y, blockView.frame.size.width, blockView.frame.size.height);
}

- (void) increaseSize 
{
     CGRect bounds;
     bounds.origin = CGPointZero;
     
     UIImage *paddle_big = [UIImage imageNamed:@"paddle_big.png"];
     bounds.size = paddle_big.size;
     
    blockView.bounds = bounds;
    blockView.image = paddle_big;

}

- (void) decreaseSize
{
    CGRect bounds;
    bounds.origin = CGPointZero;
    
    UIImage *paddle_small = [UIImage imageNamed:@"paddle_small.png"];
    bounds.size = paddle_small.size;
    
    blockView.bounds = bounds;
    blockView.image = paddle_small;
}

- (void) resetSize
{
    CGRect bounds;
    bounds.origin = CGPointZero;
    
    UIImage *paddle_normal = [UIImage imageNamed:@"paddle.png"];
    bounds.size = paddle_normal.size;
    
    blockView.bounds = bounds;
    blockView.image = paddle_normal;
}


@end
