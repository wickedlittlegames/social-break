//
//  Game.h
//  Social Breakout
//
//  Created by Andrew Girvan on 11/01/2012.
//  Copyright (c) 2012 Wicked Little Websites. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Twitter/Twitter.h>
#import <Accounts/ACAccount.h>
#import <Accounts/ACAccountStore.h>
#import <Accounts/ACAccountType.h>
#import "FlurryAnalytics.h"
#import "GameOver.h"
#import "Paddle.h"
#import "Ball.h"
#import "Block.h"
#import "Powerup.h"
#import "User.h"
#import "JSON.h"

#define setting_block_max       84
#define setting_score_per_block 100
#define setting_starting_lives  3
#define setting_extreme_starting_lives 1
#define config_block_line       215
#define config_blocks_rows      5
#define config_blocks_cols      12

#define transition UIModalTransitionStyleCrossDissolve

@interface Game : UIViewController
{
    CADisplayLink *displayLink;

    int score, scoreMultiplier, lives, powerup_countdown, powerupCount, paddlehitCount, loaderCount, powerupTimer;
    
    int tmp_stat_powerup_score, tmp_stat_powerup_smaller, tmp_stat_powerup_bigger, tmp_stat_powerup_oneup;
    int tmp_stat_powerup_reverse, tmp_stat_powerup_random, tmp_stat_tweetblocks, tmp_stat_blocks, tmp_stat_died, tmp_stat_mostlives;
    
    BOOL is_gameover, is_online, is_twitter_down, has_respawned, is_extreme, powerupActive, playerDied, reverseMode;
    float audioPitch;
    
    NSMutableArray *blocks, *powerups, *tweet_data,*collected_tweets, *paddle_positions;
    NSTimer *timer_placeBlocks, *timer_effects;
    NSString *scoreExtraText;
    
    Paddle *paddle;
    Ball *ball;
    Powerup *powerup;
    User *user;
}

// Outlets
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel, *powerupLabel, *livesLabel, *gameOverLabel, *playToRestartLabel, *tweetTextLabel, *tweetUserLabel, *tweetDateLabel, *gameModeLabel;
@property (strong, nonatomic) IBOutlet UIButton *playPauseButton, *exitButton;
@property (strong, nonatomic) IBOutlet UIImageView *loadingScreen, *border_nlol, *border_plol, *tweetPanel, *tweetAvatar, *pausedImage;

// Actions
- (IBAction) playPause;
- (IBAction) exitGame;

// Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil gameMode:(NSString*)gameMode;
- (void) gameLoop:(CADisplayLink *) sender;
- (void) spawnBlocks;
- (void) placeBlocks;
- (void) updateScore;
- (int) updateLives;
- (void) powerupReset;
- (void) gameStateReset;
- (void)pause;
- (void) gameOver;

@end