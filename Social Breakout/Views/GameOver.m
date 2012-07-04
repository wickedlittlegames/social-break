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
        
        // Optional: set an image, url and initial text
        [twitter setInitialText:[NSString stringWithFormat:@"I just scored %d points playing Social Break, at the same time as checking Twitter! #socialbreak http://bit.ly/socialbreak", score_game]];
        
        // Show the controller
        [self presentModalViewController:twitter animated:YES];
        
        // gc
        [user reportAchievementIdentifier:@"TWEETED" percentComplete:100.0];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    user = [User alloc];
    
    // new high score
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int highscore_check = [prefs integerForKey:@"score_best"];
    int highscore_check_extreme = [prefs integerForKey:@"extreme_score_best"];
    int tweetCount = [[[NSUserDefaults standardUserDefaults] valueForKey:@"tweetCount"] intValue];
    
    
    if ( highscore_check >= 1000 || score_game >= 1000 )
    {
        [user reportAchievementIdentifier:@"HIGHSCORE_1000" percentComplete:100];
    }
    if ( highscore_check >= 10000 || score_game >= 10000  )
    {
        [user reportAchievementIdentifier:@"HIGHSCORE_10000" percentComplete:100];
    }
    if ( highscore_check >= 100000 || score_game >= 100000  )
    {
        [user reportAchievementIdentifier:@"HIGHSCORE_100000" percentComplete:100];
    }
    if ( highscore_check_extreme >= 100000 || score_game > 100000 )
    {
        if ( game_mode == @"extreme")
        {
            [user reportAchievementIdentifier:@"EXTREME" percentComplete:100];
        }
    }
    
    if ( tweetCount >= 90 )
    {
        [user reportAchievementIdentifier:@"MAX_TWEETS" percentComplete:100];
    }
    
    if (user.powerup_oneup >= 1 && user.powerup_bigger >= 1 && user.powerup_reverse
        && user.powerup_score >= 1 && user.powerup_small >= 1 )
    {
        [user reportAchievementIdentifier:@"ALL_POWERUPS" percentComplete:100.0];
    }
    if ( score_game > highscore_check_extreme )
    {
        [prefs setInteger:score_game forKey:@"score_best"];
        [prefs synchronize];
        
        if([[[UIDevice currentDevice] systemVersion] compare:@"4.3" options:NSNumericSearch] == NSOrderedDescending)
        {
            GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
            [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
                if(localPlayer.isAuthenticated) 
                {
                    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:@"2"];
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
        
        label_score_best.text = [NSString stringWithFormat:@"%d",score_game];
    }
    else
    {
        label_score_best.text = [NSString stringWithFormat:@"%d",highscore_check_extreme];
    }
    
    if ( score_game > highscore_check )
    {
        [prefs setInteger:score_game forKey:@"score_best"];
        [prefs synchronize];
        
        if([[[UIDevice currentDevice] systemVersion] compare:@"4.3" options:NSNumericSearch] == NSOrderedDescending)
        {
            GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
            [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
                if(localPlayer.isAuthenticated) 
                {
                    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:@"1"];
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
                
        label_score_best.text = [NSString stringWithFormat:@"%d",score_game];
    }
    else
    {
        label_score_best.text = [NSString stringWithFormat:@"%d",highscore_check];
    }
    
    // gets the passed through score
    label_score_game.text = [NSString stringWithFormat:@"%d",score_game];
    
    if ( game_mode != @"online" || tweet_data == NULL)
    {
        label_tweets.hidden = YES;
        tblTweets.hidden = YES;
        imgTweetsBg.hidden = YES;
        label_try_online.hidden = NO;
    }
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
