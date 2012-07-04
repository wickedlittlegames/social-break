//
//  GameOver.h
//  Social Breakout
//
//  Created by Andrew Girvan on 19/01/2012.
//  Copyright (c) 2012 Wicked Little Websites. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "Game.h"
#import "User.h"
#import "MainMenu.h"

@interface GameOver : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tblTweets;
    User *user;
}

@property (nonatomic) int score_game;
@property (strong, nonatomic) NSString *game_mode;
@property (strong, nonatomic) NSMutableArray *tweet_data;
@property (strong, nonatomic) IBOutlet UILabel *label_score_game;
@property (strong, nonatomic) IBOutlet UILabel *label_score_best;
@property (strong, nonatomic) IBOutlet UIImageView *label_tweets, *imgTweetsBg, *label_try_online;

- (IBAction)tweetHighscore:(id)sender;
- (IBAction)click_restartGame:(id)sender;
- (IBAction)click_mainMenu;
- (IBAction)click_uploadScore:(id)sender;

@end
