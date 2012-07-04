//
//  User.m
//  Social Breakout
//
//  Created by Andrew Girvan on 02/07/2012.
//  Copyright (c) 2012 Wicked Little Websites. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize udata, tweets_collected_overall,powerup_score,powerup_small,powerup_bigger,powerup_oneup,powerup_reverse,powerup_random;

-(User *) init {
    
    
    if((self = [super init])){   
        
        self.udata = [NSUserDefaults standardUserDefaults];
        
        if ( [self.udata boolForKey:@"CREATED"] == FALSE )
        {
            [self create];
        }
        
        self.powerup_score = [self.udata integerForKey:@"POWERUP_SCORE"];
        self.powerup_small = [self.udata integerForKey:@"POWERUP_SMALL"];
        self.powerup_bigger = [self.udata integerForKey:@"POWERUP_BIGGER"];
        self.powerup_oneup = [self.udata integerForKey:@"POWERUP_ONEUP"];
        self.powerup_reverse = [self.udata integerForKey:@"POWERUP_REVERSE"];
        self.powerup_random = [self.udata integerForKey:@"POWERUP_RANDOM"];

        self.tweets_collected_overall = [self.udata integerForKey:@"TWEETS_COLLECTED"];
        
        NSLog(@"%d",[self.udata boolForKey:@"HIGHSCORE_1000"]);
    }
    
    return self;
}


- (void) create 
{
    NSLog(@"CREATED");
    
    [self.udata setInteger:0 forKey:@"TWEETS_COLLECTED"];
    [self.udata setBool:TRUE forKey:@"CREATED"];
    [self.udata setInteger:0 forKey:@"POWERUP_SCORE"];
    [self.udata setInteger:0 forKey:@"POWERUP_SMALL"];
    [self.udata setInteger:0 forKey:@"POWERUP_BIGGER"];    
    [self.udata setInteger:0 forKey:@"POWERUP_ONEUP"];    
    [self.udata setInteger:0 forKey:@"POWERUP_REVERSE"];    
    [self.udata setInteger:0 forKey:@"POWERUP_RANDOM"];
    
    [self.udata setBool:FALSE forKey:@"HIGHSCORE_1000"];
    [self.udata setBool:FALSE forKey:@"HIGHSCORE_10000"];
    [self.udata setBool:FALSE forKey:@"HIGHSCORE_100000"];
    [self.udata setBool:FALSE forKey:@"MAX_TWEETS"];
    [self.udata setBool:FALSE forKey:@"SPIN"];
    [self.udata setBool:FALSE forKey:@"TWEETS_COLLECTED"];
    [self.udata setBool:FALSE forKey:@"TWEETED"];
    [self.udata setBool:FALSE forKey:@"TWEET_BLOCK_HIT"];
    [self.udata setBool:FALSE forKey:@"ALL_POWERUPS"];
    
    [self.udata synchronize];
}

- (void) sync
{
    [self.udata setInteger:self.tweets_collected_overall forKey:@"TWEETS_COLLECTED"];

    [self.udata setInteger:self.powerup_score forKey:@"POWERUP_SCORE"];
    [self.udata setInteger:self.powerup_score forKey:@"POWERUP_SMALL"];
    [self.udata setInteger:self.powerup_score forKey:@"POWERUP_BIGGER"];    
    [self.udata setInteger:self.powerup_score forKey:@"POWERUP_ONEUP"];    
    [self.udata setInteger:self.powerup_score forKey:@"POWERUP_REVERSE"];    
    [self.udata setInteger:self.powerup_score forKey:@"POWERUP_RANDOM"];
    
    [self.udata synchronize];
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
                         NSLog(@"PERCENT: %f",percent);
                         if ( percent == 100.0 )
                             
                         {   
                             NSLog(@"%d",[self.udata boolForKey:@"HIGHSCORE_1000"]);
                             // notify the user
                             if (identifier == @"MAX_TWEETS" && [self.udata boolForKey:@"MAX_TWEETS"] == 0)
                             {
                                [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"Extreme Social Breaker" andMessage:@"You are an EXTREME Social Breaker"];
                                [self.udata setBool:1 forKey:@"MAX_TWEETS"];
                             }
                             if (identifier == @"HIGHSCORE_1000" && [self.udata boolForKey:@"HIGHSCORE_1000"] == 0)
                             {
                                 [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"Casual" andMessage:@"Score 1000 points or more."];
                                 [self.udata setBool:1 forKey:@"HIGHSCORE_1000"];
                                 [self.udata synchronize];
                             }
                             if (identifier == @"HIGHSCORE_10000" && [self.udata boolForKey:@"HIGHSCORE_10000"] == 0)
                             {
                                 [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"Addicted" andMessage:@"Score 10000 points or more."];
                                 [self.udata setBool:TRUE forKey:@"HIGHSCORE_10000"];
                             }
                             if (identifier == @"HIGHSCORE_100000" && [self.udata boolForKey:@"HIGHSCORE_100000"] == 0)
                             {
                                 [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"Hardcore" andMessage:@"Score 100000 points or more."];
                                 [self.udata setBool:TRUE forKey:@"HIGHSCORE_100000"];
                             }                             
                             if (identifier == @"SPIN" && [self.udata boolForKey:@"SPIN"] == 0)
                             {
                                 [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"You've Played This Before" andMessage:@"Spin the ball!"];
                                 [self.udata setBool:TRUE forKey:@"SPIN"];
                             }
                             if (identifier == @"TWEETS_COLLECTED" && [self.udata boolForKey:@"TWEETS_COLLECTED"] == 0)
                             {
                                 [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"Who Needs TweetDeck?" andMessage:@"You collected more than 100 tweets in Online Mode!"];
                                 [self.udata setBool:TRUE forKey:@"TWEETS_COLLECTED"];
                             }
                             if (identifier == @"TWEETED" && [self.udata boolForKey:@"TWEETED"] == 0)
                             {
                                 [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"Spread The Word!" andMessage:@"You tweeted your high-score to all your friends!"];
                                 [self.udata setBool:TRUE forKey:@"TWEETED"];
                             }
                             if (identifier == @"TWEET_BLOCK_HIT" && [self.udata boolForKey:@"TWEET_BLOCK_HIT"] == 0)
                             {
                                 [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"Social Breaker" andMessage:@"You collected a tweet by hitting a tweet block!"];
                                 [self.udata setBool:TRUE forKey:@"TWEET_BLOCK_HIT"];
                             }
                             if (identifier == @"ALL_POWERUPS" && [self.udata boolForKey:@"ALL_POWERUPS"] == 0)
                             {
                                 [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"Collector" andMessage:@"You have collected one of each of the powerups!"];
                                 [self.udata setBool:TRUE forKey:@"ALL_POWERUPS"];
                             }
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
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error){}];
}

@end
