//
//  User.h
//  Social Breakout
//
//  Created by Andrew Girvan on 02/07/2012.
//  Copyright (c) 2012 Wicked Little Websites. All rights reserved.
//
#import <GameKit/GameKit.h>
#import <Foundation/Foundation.h>
#import "GKAchievementHandler.h"

@interface User : NSObject {}

@property (nonatomic, retain) NSUserDefaults *udata;
@property (nonatomic, assign) int tweets_collected_overall,powerup_score,powerup_small,powerup_bigger,powerup_oneup,powerup_reverse,powerup_random;

- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent;
- (void) resetAchievements;

- (void) sync;

@end
