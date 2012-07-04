//
//  Powerup.m
//  Social Breakout
//
//  Created by Andrew Girvan on 13/01/2012.
//  Copyright (c) 2012 Wicked Little Websites. All rights reserved.
//

#import "Powerup.h"

@implementation Powerup
@synthesize powerupType, active_icon, active_effect;


- (Powerup *) initAtPosition:(CGPoint) position {
    
    if((self = [super init])){

        int random = arc4random()%100;
        if ( random > setting_powerup_chance )
        {
            int powerup_Type = arc4random()%6;
            
            if ( powerup_Type == 0 )
            {
                powerupView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"powerup_score.png"]];
            }
            else if ( powerup_Type == 1 )
            {
                powerupView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"powerup_smaller.png"]];
            }
            else if ( powerup_Type == 2 )
            {
                powerupView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"powerup_bigger.png"]];
            }
            else if ( powerup_Type == 3 )
            {
                powerupView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"powerup_oneup.png"]];
            }
            else if ( powerup_Type == 4 )
            {
                powerupView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"powerup_reverse.png"]];
            }
            else 
            {
                powerup_Type = arc4random()%3;
                powerupView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"powerup_random.png"]];
            }
            
            self.powerupType = powerup_Type;
            active_icon = YES;
            self.frame = CGRectMake((position.x - 12.5),position.y, powerupView.frame.size.width, powerupView.frame.size.height);
            [self addSubview:powerupView];
        }
        else
        {
            //NSLog(@"Not powerup");
            return NULL;
        }
    }
    
    return self;
    
}

- (BOOL) paddleIntersectsPowerup:(Paddle *)paddle powerup:(Powerup *)powerupIcon
{
    return YES;
}

- (void) update
{
    if( self.center.y > 500 && self.hidden == NO && active_icon)
    {
        active_icon = NO;
    }
    if ( self.center.y <= 500 && self.hidden == NO ) 
    {
        self.center = CGPointMake(self.center.x, self.center.y + 1.5);
    }
    else 
    {
        self.hidden =  YES;
        self.center = CGPointMake(0,600);
    }
}

@end
