//
//  User.m
//  Social Breakout
//
//  Created by Andrew Girvan on 02/07/2012.
//  Copyright (c) 2012 Wicked Little Websites. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize udata, tweets_collected_overall;

/* 
    USER DATA
    #SETTINGS#
    - SETTING_TWEETCOUNT // user setting for how many tweets to show
    - SETTING_READTIME   // user setting for the reading time
    - SETTING_CREATED
 
    #HIGHSCORES#
    - HIGHSCORE_NORMAL   // highscore for normal mode
    - HIGHSCORE_EXTREME  // highscore for extreme mode
 
    #STATS#
    - STAT_POWERUP_SCORE
    - STAT_POWERUP_SMALLER
    - STAT_POWERUP_BIGGER
    - STAT_POWERUP_ONEUP
    - STAT_POWERUP_REVERSE 
    - STAT_POWERUP_RANDOM
    - STAT_ONLINE_PLAYED
    - STAT_OFFLINE_PLAYED
    - STAT_EXTREME_PLAYED
    - STAT_TWEETBLOCKS
    - STAT_BLOCKS
    - STAT_DIED
    - STAT_MOSTLIVES 
    
    #ACHIEVEMENTS#
    - ACH_HIGHSCORE_1000            // score over 1000 points [done]
    - ACH_HIGHSCORE_10000           // score over 10000 points [done]
    - ACH_HIGHSCORE_100000          // score over 100000 points [done]
    - ACH_TWEETED                   // use the tweet button [done]
    - ACH_TWEETBLOCK_HIT            // tweetblock is hit [done]
    - ACH_100_TWEETBLOCK_HIT        // 100 tweetblocks hit [done]
    - ACH_INDESTRUCTIBLE            // had over 10 lives at one point [done]
    - ACH_EXTREME                   // scored 50,000 in extreme mode [done]
    - ACH_EXTREME_ROUND             // played one full round of extreme [done]
    - ACH_MAX_SPEED                 // max speed achieved
*/

-(User *) init {
    
    if((self = [super init])){   
        
        udata = [NSUserDefaults standardUserDefaults];
        
        if ( [udata boolForKey:@"SETTING_CREATED"] == FALSE )
        {
            [udata setInteger:[udata integerForKey:@"tweetCount"] forKey:@"SETTING_TWEETCOUNT"];            
            [udata setInteger:[udata integerForKey:@"tweetTimer"] forKey:@"SETTING_READTIME"];
            [udata setBool:TRUE forKey:@"SETTING_CREATED"];
            [udata setBool:[udata boolForKey:@"muted"] forKey:@"SETTING_MUTED"];
            
            [udata setInteger:[udata integerForKey:@"score_best"] forKey:@"HIGHSCORE_NORMAL"];
            [udata setInteger:0 forKey:@"HIGHSCORE_EXTREME"];
            
            [udata setInteger:0 forKey:@"STAT_POWERUP_SCORE"];
            [udata setInteger:0 forKey:@"STAT_POWERUP_SMALLER"];
            [udata setInteger:0 forKey:@"STAT_POWERUP_BIGGER"];
            [udata setInteger:0 forKey:@"STAT_POWERUP_ONEUP"];
            [udata setInteger:0 forKey:@"STAT_POWERUP_REVERSE"];
            [udata setInteger:0 forKey:@"STAT_POWERUP_RANDOM"];
            [udata setInteger:0 forKey:@"STAT_ONLINE_PLAYED"];
            [udata setInteger:0 forKey:@"STAT_OFFLINE_PLAYED"];
            [udata setInteger:0 forKey:@"STAT_EXTREME_PLAYED"];
            [udata setInteger:0 forKey:@"STAT_TWEETBLOCKS"];
            [udata setInteger:0 forKey:@"STAT_BLOCKS"];
            [udata setInteger:0 forKey:@"STAT_DIED"];
            [udata setInteger:0 forKey:@"STAT_MOSTLIVES"];        
            
            [udata setBool:FALSE forKey:@"ACH_HIGHSCORE_1000"];
            [udata setBool:FALSE forKey:@"ACH_HIGHSCORE_10000"];
            [udata setBool:FALSE forKey:@"ACH_HIGHSCORE_100000"];
            [udata setBool:FALSE forKey:@"ACH_TWEETED"];
            [udata setBool:FALSE forKey:@"ACH_TWEETBLOCK_HIT"];
            [udata setBool:FALSE forKey:@"ACH_100_TWEETBLOCK_HIT"];
            [udata setBool:FALSE forKey:@"ACH_INDESTRUCTIBLE"];
            [udata setBool:FALSE forKey:@"ACH_EXTREME"];
            [udata setBool:FALSE forKey:@"ACH_EXTREME_ROUND"];
            [udata setBool:FALSE forKey:@"ACH_MAX_SPEED"];

            [udata synchronize];
        }
        
        self.tweets_collected_overall = [udata integerForKey:@"STAT_TWEETBLOCKS"];
    }
    
    return self;
}

- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        
        if(localPlayer.isAuthenticated) 
        {
            GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier: identifier];
            if (achievement)
            {
                if ( achievement.percentComplete != 100 )
                {
                achievement.percentComplete = percent;
                [achievement reportAchievementWithCompletionHandler:^(NSError *error)
                {
                     if (error != nil)
                     {
                         NSLog(@"%@",error);
                     }
                     else 
                     {
                         if ( percent == 100.0 )
                         {   
                             if ( identifier == @"ACH_HIGHSCORE_1000" )
                             {
                                 if ( ![udata boolForKey:identifier] )
                                 {
                                     [[GKAchievementHandler defaultHandler] 
                                        notifyAchievementTitle:@"CASUAL" 
                                        andMessage:@"Scored higher than 1000 points!"];
                                     [udata setBool:TRUE forKey:identifier];
                                 }
                             }
                             if ( identifier == @"ACH_HIGHSCORE_10000" )
                             {
                                 if ( ![udata boolForKey:identifier] )
                                 {
                                     [[GKAchievementHandler defaultHandler] 
                                      notifyAchievementTitle:@"ADDICTED" 
                                      andMessage:@"Scored higher than 10000 points!"];
                                     [udata setBool:TRUE forKey:identifier];
                                 }
                             }
                             if ( identifier == @"ACH_HIGHSCORE_100000" )
                             {
                                 if ( ![udata boolForKey:identifier] )
                                 {
                                     [[GKAchievementHandler defaultHandler] 
                                      notifyAchievementTitle:@"HARDCORE" 
                                      andMessage:@"Scored higher than 100000 points!"];
                                     [udata setBool:TRUE forKey:identifier];
                                 }
                             }
                             if ( identifier == @"ACH_TWEETED" )
                             {
                                 if ( ![udata boolForKey:identifier] )
                                 {
                                     [[GKAchievementHandler defaultHandler] 
                                      notifyAchievementTitle:@"SPREAD THE WORD" 
                                      andMessage:@"You tweeted your score!"];
                                     [udata setBool:TRUE forKey:identifier];
                                 }
                             }
                             if ( identifier == @"ACH_TWEETBLOCK_HIT" )
                             {
                                 if ( ![udata boolForKey:identifier] )
                                 {
                                     [[GKAchievementHandler defaultHandler] 
                                      notifyAchievementTitle:@"SOCIAL BREAKER" 
                                      andMessage:@"You hit a Tweet Block!"];
                                     [udata setBool:TRUE forKey:identifier];
                                 }
                             }
                             if ( identifier == @"ACH_100_TWEETBLOCK_HIT" )
                             {
                                 if ( ![udata boolForKey:identifier] )
                                 {
                                     [[GKAchievementHandler defaultHandler] 
                                      notifyAchievementTitle:@"MEGA SOCIAL BREAKER" 
                                      andMessage:@"You hit over 100 Tweet Blocks!"];
                                     [udata setBool:TRUE forKey:identifier];
                                 }
                             }
                             if ( identifier == @"ACH_INDESTRUCTIBLE" )
                             {
                                 if ( ![udata boolForKey:identifier] )
                                 {
                                     [[GKAchievementHandler defaultHandler] 
                                      notifyAchievementTitle:@"INDESTRUCTIBLE" 
                                      andMessage:@"You collected more than 10 lives!"];
                                     [udata setBool:TRUE forKey:identifier];
                                 }
                             }
                             if ( identifier == @"ACH_EXTREME_ROUND" )
                             {
                                 if ( ![udata boolForKey:identifier] )
                                 {
                                     [[GKAchievementHandler defaultHandler] 
                                      notifyAchievementTitle:@"ALMOST EXTREME SOCIAL BREAKER" 
                                      andMessage:@"You completed a full round of EXTREME MODE!"];
                                     [udata setBool:TRUE forKey:identifier];
                                 }
                             }
                             if ( identifier == @"ACH_EXTREME" )
                             {
                                 if ( ![udata boolForKey:identifier] )
                                 {
                                     [[GKAchievementHandler defaultHandler] 
                                      notifyAchievementTitle:@"EXTREME SOCIAL BREAKER" 
                                      andMessage:@"Whoa! You scored more than 50,000 in EXTREME MODE!"];
                                     [udata setBool:TRUE forKey:identifier];
                                 }
                             }   
                             if ( identifier == @"ACH_MAX_SPEED" )
                             {
                                 if ( ![udata boolForKey:identifier] )
                                 {
                                     [[GKAchievementHandler defaultHandler] 
                                      notifyAchievementTitle:@"SPEEDY" 
                                      andMessage:@"You achieved maximum velocity!"];
                                     [udata setBool:TRUE forKey:identifier];
                                 }
                             }
                             [udata synchronize];
                         }
                     }
                 }];
                }
            }
        }
    }];
}

- (void) resetAchievements
{
    [udata setInteger:[udata integerForKey:@"tweetCount"] forKey:@"SETTING_TWEETCOUNT"];            
    [udata setInteger:[udata integerForKey:@"tweetTimer"] forKey:@"SETTING_READTIME"];
    [udata setBool:FALSE forKey:@"SETTING_CREATED"];
    [udata setBool:TRUE forKey:@"SETTING_MUTED"];
    
    [udata setInteger:0 forKey:@"HIGHSCORE_NORMAL"];
    [udata setInteger:0 forKey:@"HIGHSCORE_EXTREME"];
    
    [udata setInteger:0 forKey:@"STAT_POWERUP_SCORE"];
    [udata setInteger:0 forKey:@"STAT_POWERUP_SMALLER"];
    [udata setInteger:0 forKey:@"STAT_POWERUP_BIGGER"];
    [udata setInteger:0 forKey:@"STAT_POWERUP_ONEUP"];
    [udata setInteger:0 forKey:@"STAT_POWERUP_REVERSE"];
    [udata setInteger:0 forKey:@"STAT_POWERUP_RANDOM"];
    [udata setInteger:0 forKey:@"STAT_ONLINE_PLAYED"];
    [udata setInteger:0 forKey:@"STAT_OFFLINE_PLAYED"];
    [udata setInteger:0 forKey:@"STAT_EXTREME_PLAYED"];
    [udata setInteger:0 forKey:@"STAT_TWEETBLOCKS"];
    [udata setInteger:0 forKey:@"STAT_BLOCKS"];
    [udata setInteger:0 forKey:@"STAT_DIED"];
    [udata setInteger:0 forKey:@"STAT_MOSTLIVES"];        
    
    [udata setBool:FALSE forKey:@"ACH_HIGHSCORE_1000"];
    [udata setBool:FALSE forKey:@"ACH_HIGHSCORE_10000"];
    [udata setBool:FALSE forKey:@"ACH_HIGHSCORE_100000"];
    [udata setBool:FALSE forKey:@"ACH_TWEETED"];
    [udata setBool:FALSE forKey:@"ACH_TWEETBLOCK_HIT"];
    [udata setBool:FALSE forKey:@"ACH_100_TWEETBLOCK_HIT"];
    [udata setBool:FALSE forKey:@"ACH_INDESTRUCTIBLE"];
    [udata setBool:FALSE forKey:@"ACH_EXTREME"];
    [udata setBool:FALSE forKey:@"ACH_EXTREME_ROUND"];
    [udata setBool:FALSE forKey:@"ACH_MAX_SPEED"];
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error){}];
}

@end
