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
        
        if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"CREATED"] == FALSE )
        {
            [self create];
        }
        
        self.powerup_score = [[NSUserDefaults standardUserDefaults] integerForKey:@"POWERUP_SCORE"];
        self.powerup_small = [[NSUserDefaults standardUserDefaults] integerForKey:@"POWERUP_SMALL"];
        self.powerup_bigger = [[NSUserDefaults standardUserDefaults] integerForKey:@"POWERUP_BIGGER"];
        self.powerup_oneup = [[NSUserDefaults standardUserDefaults] integerForKey:@"POWERUP_ONEUP"];
        self.powerup_reverse = [[NSUserDefaults standardUserDefaults] integerForKey:@"POWERUP_REVERSE"];
        self.powerup_random = [[NSUserDefaults standardUserDefaults] integerForKey:@"POWERUP_RANDOM"];

        self.tweets_collected_overall = [[NSUserDefaults standardUserDefaults] integerForKey:@"TWEETS_COLLECTED"];
        
        [self _log];
    }
    
    return self;
}

- (void) create 
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"TWEETS_COLLECTED"];
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"CREATED"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"POWERUP_SCORE"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"POWERUP_SMALL"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"POWERUP_BIGGER"];    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"POWERUP_ONEUP"];    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"POWERUP_REVERSE"];    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"POWERUP_RANDOM"];
    
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"HIGHSCORE_1000"];
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"HIGHSCORE_10000"];
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"HIGHSCORE_100000"];
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"MAX_TWEETS"];
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"SPIN"];
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"TWEETS_COLLECTED"];
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"TWEETED"];
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"TWEET_BLOCK_HIT"];
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"ALL_POWERUPS"];
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"INDESTRUCTABLE"];    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) reset
{
    [self create];
}

- (void) _log
{
    NSLog(@"TWEETS_COLLECTED: %i",[[NSUserDefaults standardUserDefaults] integerForKey:@"TWEETS_COLLECTED"]);
    NSLog(@"CREATED: %i",[[NSUserDefaults standardUserDefaults] boolForKey:@"CREATED"]);
    NSLog(@"POWERUP_SCORE: %i",[[NSUserDefaults standardUserDefaults] integerForKey:@"POWERUP_SCORE"]);
    NSLog(@"POWERUP_SMALL: %i",[[NSUserDefaults standardUserDefaults] integerForKey:@"POWERUP_SMALL"]);
    NSLog(@"POWERUP_BIGGER: %i",[[NSUserDefaults standardUserDefaults] integerForKey:@"POWERUP_BIGGER"]);
    NSLog(@"POWERUP_ONEUP: %i",[[NSUserDefaults standardUserDefaults] integerForKey:@"POWERUP_ONEUP"]);
    NSLog(@"POWERUP_REVERSE: %i",[[NSUserDefaults standardUserDefaults] integerForKey:@"POWERUP_REVERSE"]);
    NSLog(@"POWERUP_RANDOM: %i",[[NSUserDefaults standardUserDefaults] integerForKey:@"POWERUP_RANDOM"]);
    
    NSLog(@"HIGHSCORE_1000: %i",[[NSUserDefaults standardUserDefaults] boolForKey:@"HIGHSCORE_1000"]);    
    NSLog(@"HIGHSCORE_10000: %i",[[NSUserDefaults standardUserDefaults] boolForKey:@"HIGHSCORE_10000"]);    
    NSLog(@"HIGHSCORE_100000: %i",[[NSUserDefaults standardUserDefaults] boolForKey:@"HIGHSCORE_100000"]);    
    NSLog(@"MAX_TWEETS: %i",[[NSUserDefaults standardUserDefaults] boolForKey:@"MAX_TWEETS"]);    
    NSLog(@"SPIN: %i",[[NSUserDefaults standardUserDefaults] boolForKey:@"SPIN"]);    
    NSLog(@"TWEETS_COLLECTED: %i",[[NSUserDefaults standardUserDefaults] boolForKey:@"TWEETS_COLLECTED"]);    
    NSLog(@"TWEETED: %i",[[NSUserDefaults standardUserDefaults] boolForKey:@"TWEETED"]);    
    NSLog(@"TWEET_BLOCK_HIT: %i",[[NSUserDefaults standardUserDefaults] boolForKey:@"TWEET_BLOCK_HIT"]);    
    NSLog(@"ALL_POWERUPS: %i",[[NSUserDefaults standardUserDefaults] boolForKey:@"ALL_POWERUPS"]);    
}

- (void) sync
{
    [[NSUserDefaults standardUserDefaults] setInteger:self.tweets_collected_overall forKey:@"TWEETS_COLLECTED"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.powerup_score forKey:@"POWERUP_SCORE"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.powerup_small forKey:@"POWERUP_SMALL"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.powerup_bigger forKey:@"POWERUP_BIGGER"];    
    [[NSUserDefaults standardUserDefaults] setInteger:self.powerup_oneup forKey:@"POWERUP_ONEUP"];    
    [[NSUserDefaults standardUserDefaults] setInteger:self.powerup_reverse forKey:@"POWERUP_REVERSE"];    
    [[NSUserDefaults standardUserDefaults] setInteger:self.powerup_random forKey:@"POWERUP_RANDOM"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
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
                             if (identifier == @"MAX_TWEETS" && [[NSUserDefaults standardUserDefaults] boolForKey:@"MAX_TWEETS"] == FALSE)
                             {
                                [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"Extreme Social Breaker" andMessage:@"You are an EXTREME Social Breaker"];
                                [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"MAX_TWEETS"];
                             }
                             if (identifier == @"HIGHSCORE_1000" && [[NSUserDefaults standardUserDefaults] boolForKey:@"HIGHSCORE_1000"] == FALSE)
                             {
                                 NSLog(@"DO THIS!!");
                                 [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"HIGHSCORE_1000"];                                                                  
                                  [[NSUserDefaults standardUserDefaults] synchronize];
                                 [self _log];
                                 [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"Casual" andMessage:@"Score 1000 points or more."];
                             }
                             if (identifier == @"HIGHSCORE_10000" && [[NSUserDefaults standardUserDefaults] boolForKey:@"HIGHSCORE_10000"] == FALSE)
                             {
                                 [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"Addicted" andMessage:@"Score 10000 points or more."];
                                 [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"HIGHSCORE_10000"];
                             }
                             if (identifier == @"HIGHSCORE_100000" && [[NSUserDefaults standardUserDefaults] boolForKey:@"HIGHSCORE_100000"] == FALSE)
                             {
                                 [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"Hardcore" andMessage:@"Score 100000 points or more."];
                                 [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"HIGHSCORE_100000"];
                             }                             
                             if (identifier == @"SPIN" && [[NSUserDefaults standardUserDefaults] boolForKey:@"SPIN"] == FALSE)
                             {
                                 [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"You've Played This Before" andMessage:@"Spin the ball!"];
                                 [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"SPIN"];
                             }
                             if (identifier == @"TWEETS_COLLECTED" && [[NSUserDefaults standardUserDefaults] boolForKey:@"TWEETS_COLLECTED"] == FALSE)
                             {
                                 [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"Who Needs TweetDeck?" andMessage:@"You collected more than 100 tweets in Online Mode!"];
                                 [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"TWEETS_COLLECTED"];
                             }
                             if (identifier == @"TWEETED" && [[NSUserDefaults standardUserDefaults] boolForKey:@"TWEETED"] == FALSE)
                             {
                                 [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"Spread The Word!" andMessage:@"You tweeted your high-score to all your friends!"];
                                 [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"TWEETED"];
                             }
                             if (identifier == @"TWEET_BLOCK_HIT" && [[NSUserDefaults standardUserDefaults] boolForKey:@"TWEET_BLOCK_HIT"] == FALSE)
                             {
                                 [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"Social Breaker" andMessage:@"You collected a tweet by hitting a tweet block!"];
                                 [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"TWEET_BLOCK_HIT"];
                             }
                             if (identifier == @"INDESTRUCTABLE" && [[NSUserDefaults standardUserDefaults] boolForKey:@"INDESTRUCTABLE"] == FALSE)
                             {
                                 [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"Indestructible" andMessage:@"You managed to hold on to 10 lives!"];
                                 [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"INDESTRUCTABLE"];
                             }
                             //if (identifier == @"ALL_POWERUPS" && [[NSUserDefaults standardUserDefaults] boolForKey:@"ALL_POWERUPS"] == FALSE)
                             //{
                             //    [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"Collector" andMessage:@"You have collected one of each of the powerups!"];
                             //    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"ALL_POWERUPS"];
                             //}
                             [[NSUserDefaults standardUserDefaults] synchronize];
                            
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
