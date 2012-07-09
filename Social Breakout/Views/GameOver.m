//
//  GameOver.m
//  Social Breakout
//
//  Created by Andrew Girvan on 19/01/2012.
//  Copyright (c) 2012 Wicked Little Websites. All rights reserved.
//

#import "GameOver.h"

@implementation GameOver
@synthesize label_score_best, label_score_game, label_tweets, score_game, game_mode, tweet_data, imgTweetsBg, label_try_online;

UIImageView *avatarImageRetain;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [tweet_data count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
   NSArray *tweet_data_single = [tweet_data objectAtIndex:indexPath.row];
   [[UIApplication sharedApplication] openURL:[tweet_data_single objectAtIndex:4]];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.delegate=self;
    tableView.dataSource=self;

    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.userInteractionEnabled = YES;
    cell.imageView.image = [UIImage imageNamed:@"block_tweet_list.png"];
    
    NSArray *tweet_data_single = [tweet_data objectAtIndex:indexPath.row];
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in bg
    dispatch_async(concurrentQueue, ^{        
        NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[tweet_data_single objectAtIndex:1]]];
        
        //this will set the image when loading is finished
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = [UIImage imageWithData:image];
        });
    });

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
    
    cell.textLabel.text = [NSString stringWithFormat:@"@%@:",[tweet_data_single objectAtIndex:2]];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[tweet_data_single objectAtIndex:0]];
    
    [cell sizeToFit];
    
    return cell;
}



- (IBAction)click_restartGame:(id)sender 
{
    Game *gameViewController = [[Game alloc] initWithNibName:@"Game" bundle:[NSBundle mainBundle] gameMode:game_mode];
    gameViewController.modalTransitionStyle = transition;
    [self presentViewController:gameViewController animated:YES completion:nil];

}

- (IBAction)click_mainMenu
{
    MainMenu *controller = [[UIStoryboard storyboardWithName:@"MainMenu" bundle:NULL] instantiateViewControllerWithIdentifier:@"MainMenu"];
    controller.modalTransitionStyle = transition;
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)click_uploadScore:(id)sender
{
    
}

- (IBAction)tweetHighscore:(id)sender 
{
    if ( [TWTweetComposeViewController canSendTweet] ) 
    {
        // Create the view controller
        TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
        [twitter setInitialText:[NSString stringWithFormat:@"I just scored %d points playing Social Break, at the same time as checking Twitter! #socialbreak http://bit.ly/socialbreak", score_game]];
        [self presentModalViewController:twitter animated:YES];
        [user reportAchievementIdentifier:@"ACH_TWEETED" percentComplete:100.0];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:@"Sorry"                                                             
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"                                                          
                                  delegate:self                                              
                                  cancelButtonTitle:@"OK"                                                   
                                  otherButtonTitles:nil];
        [alertView show];
    }
 
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    user = [[User alloc] init];
    
    if ( game_mode != @"online" || tweet_data == NULL)
    {
        label_tweets.hidden = YES;
        tblTweets.hidden = YES;
        imgTweetsBg.hidden = YES;
        label_try_online.hidden = NO;
    }
    
    // new high score
    int highscore_check = [user.udata integerForKey:@"HIGHSCORE_NORMAL"];
    int highscore_check_extreme = [user.udata integerForKey:@"HIGHSCORE_EXTREME"];
    
    if ( score_game > 1000 ) [user reportAchievementIdentifier:@"ACH_HIGHSCORE_1000" percentComplete:100.0];
    if ( score_game > 10000 ) [user reportAchievementIdentifier:@"ACH_HIGHSCORE_10000" percentComplete:100.0];
    if ( score_game > 100000 ) [user reportAchievementIdentifier:@"ACH_HIGHSCORE_100000" percentComplete:100.0];   

    if ( game_mode == @"extreme" )
    {
        if ( score_game > 50000 ) [user reportAchievementIdentifier:@"ACH_EXTREME" percentComplete:100.0];
        if ( score_game > highscore_check_extreme )
        {
            [user.udata setInteger:score_game forKey:@"HIGHSCORE_EXTREME"];
            [self reportHighscoreForCategory:@"2"];
            [label_score_best setText:[NSString stringWithFormat:@"%d",score_game]];
        }
        else 
        {
            [label_score_best setText:[NSString stringWithFormat:@"%d",highscore_check_extreme]];
        }
    }
    else 
    {
        if ( score_game > highscore_check )
        {
            [user.udata setInteger:score_game forKey:@"HIGHSCORE_NORMAL"];
            [self reportHighscoreForCategory:@"1"];
            [label_score_best setText:[NSString stringWithFormat:@"%d",score_game]];
        }
        else 
        {
            [label_score_best setText:[NSString stringWithFormat:@"%d",highscore_check]];
        }
    }

    label_score_game.text = [NSString stringWithFormat:@"%d",score_game];
    
    [user.udata synchronize];    
}

- (void) reportHighscoreForCategory:(NSString*)category
{
    if([[[UIDevice currentDevice] systemVersion] compare:@"4.3" options:NSNumericSearch] == NSOrderedDescending)
    {
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
            if(localPlayer.isAuthenticated) 
            {
                GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
                scoreReporter.value = score_game;
                
                [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
                    if (error != nil)
                    {
                        // handle the reporting error
                    }
                }];
            }
        }];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
