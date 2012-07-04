//
//  MainMenu.h
//  Social Breakout
//
//  Created by Andrew Girvan on 03/01/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import "FlurryAnalytics.h"
#import "SimpleAudioEngine.h"
#import "Game.h"
#import "Ball.h"
#import "User.h"

@interface MainMenu : UIViewController <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    SimpleAudioEngine *audioPlayer;
    User *user;
    CADisplayLink *displayLink;
    Ball *ball;
}

@property (strong, nonatomic) IBOutlet UILabel *topScore, *lblStats;
@property (strong, nonatomic) IBOutlet UIButton *muteButton, *muteButtonMuted;

- (IBAction)mute:(id)sender;
- (IBAction)tweetHighscore:(id)sender;
- (IBAction)onlinebuttonTapped:(id)sender;
- (IBAction)offlinebuttonTapped:(id)sender;
- (IBAction)extremebuttonTapped:(id)sender;
- (IBAction)clickLeaderboard:(id)sender;
- (IBAction)clickAchievements:(id)sender;
- (IBAction)resetAchievements:(id)sender;
- (void) setDefaultOptions;

@end
