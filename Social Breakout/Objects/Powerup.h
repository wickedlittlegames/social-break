//
//  Powerup.h
//  Social Breakout
//
//  Created by Andrew Girvan on 13/01/2012.
//  Copyright (c) 2012 Wicked Little Websites. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Paddle.h"
#define setting_powerup_chance  80

@interface Powerup : UIView
{
    UIImageView *powerupView;
    int powerupType;
}

@property (nonatomic) int powerupType;
@property (nonatomic) bool active_icon, active_effect;

- (Powerup *) initAtPosition:(CGPoint) position;
- (void) update;

@end
