//
//  MainMenu.m
//  Social Breakout
//
//  Created by Andrew Girvan on 11/01/2012.
//  Copyright (c) 2012 Wicked Little Websites. All rights reserved.
//

#import "MainMenu.h"


@implementation MainMenu
@synthesize topScore, muteButton, muteButtonMuted, lblStats;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {

    }
    return self;
}

// The IBAction that occurs when the online button has been tapped
- (IBAction)onlinebuttonTapped:(id)sender 
{
    // check to see if iphone can tweet, otherwise alert
    if ( [TWTweetComposeViewController canSendTweet] ) 
    {
        [FlurryAnalytics logEvent:@"Online Mode Played"];
        [FlurryAnalytics logEvent:@"Online Game Time" timed:YES];
        Game *gameViewController = [[Game alloc] initWithNibName:@"Game" bundle:[NSBundle mainBundle] gameMode:@"online"];
        gameViewController.modalTransitionStyle = transition;
        [self presentViewController:gameViewController animated:YES completion:nil];
        [displayLink invalidate];
        displayLink = nil;
    }
    else
    {
        [FlurryAnalytics logEvent:@"Online Mode - not authorized"];
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:@"Sorry"                                                             
                                  message:@"You can't use this feature right now, make sure your device has an internet connection and you have at least one Twitter account setup"                                                          
                                  delegate:self                                              
                                  cancelButtonTitle:@"OK"                                                   
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

// The IBAction when the offline button has been tapped
- (IBAction)offlinebuttonTapped:(id)sender 
{
    [FlurryAnalytics logEvent:@"Offline Mode Player"];
    [FlurryAnalytics logEvent:@"Offline Game Time" timed:YES];    
    Game *gameViewController = [[Game alloc] initWithNibName:@"Game" bundle:[NSBundle mainBundle] gameMode:@"offline"];
    gameViewController.modalTransitionStyle = transition;
    [self presentViewController:gameViewController animated:YES completion:nil];
    [displayLink invalidate];
    displayLink = nil;
}

// The IBAction when the offline button has been tapped
- (IBAction)extremebuttonTapped:(id)sender 
{
    [FlurryAnalytics logEvent:@"Extreme Mode Player"];
    Game *gameViewController = [[Game alloc] initWithNibName:@"Game" bundle:[NSBundle mainBundle] gameMode:@"extreme"];
    gameViewController.modalTransitionStyle = transition;
    [self presentViewController:gameViewController animated:YES completion:nil];
    [displayLink invalidate];
    displayLink = nil;
}

- (void) setDefaultOptions 
{
    // tweet count
    if ( [[NSUserDefaults standardUserDefaults] valueForKey:@"tweetCount"] == NULL ) 
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"30" forKey:@"tweetCount"];
    }
    
    // tweet timer
    if ( [[NSUserDefaults standardUserDefaults] valueForKey:@"tweetTimer"] == NULL ) 
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"3" forKey:@"tweetTimer"];
    }

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int highscore_check = [prefs integerForKey:@"score_best"];
    
    if ( highscore_check > 0 )
    {
        topScore.text = [NSString stringWithFormat:@"%d",highscore_check];
    }
    else
    {
        topScore.text = @"0";
    }
    
}

- (IBAction)mute:(id)sender
{
    bool current_mute_status = [[NSUserDefaults standardUserDefaults] boolForKey:@"muted"];
    
    if ( current_mute_status == 0 )
    {
        muteButton.hidden = YES;
        muteButtonMuted.hidden = NO;
        [SimpleAudioEngine sharedEngine].mute = YES;
        [[NSUserDefaults standardUserDefaults] setBool:1 forKey:@"muted"];
    }
    else
    {
        muteButton.hidden = NO;
        muteButtonMuted.hidden = YES;
        [SimpleAudioEngine sharedEngine].mute = NO;        
        [[NSUserDefaults standardUserDefaults] setBool:0 forKey:@"muted"];
    }

    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)tweetHighscore:(id)sender 
{
    if ( [TWTweetComposeViewController canSendTweet] ) 
    {
        // Create the view controller
        TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        int highscore_check = [prefs integerForKey:@"score_best"];
        
        // Optional: set an image, url and initial text
        [twitter setInitialText:[NSString stringWithFormat:@"My top score on Social Break is %d points. Try to beat me whilst checking Twitter at the same time! #socialbreak http://bit.ly/socialbreak", highscore_check]];
        
        // Show the controller
        [self presentModalViewController:twitter animated:YES];
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    lblStats.text = [NSString stringWithFormat:@"%i powerups collected",user.tweets_collected_overall];
    
    // Set up the ball
    ball = [[Ball alloc ] initWithPosition:CGPointMake(80, 280)];
    [self.view addSubview:ball];
    
    user = [[User alloc] init];
    
    [self setDefaultOptions];
    
    if ( ![SimpleAudioEngine sharedEngine].isBackgroundMusicPlaying )
    {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"void.mp3" loop:YES];
    }
    
	[SimpleAudioEngine sharedEngine].mute = [[NSUserDefaults standardUserDefaults] boolForKey:@"muted"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ( [SimpleAudioEngine sharedEngine].mute )
    {
        muteButtonMuted.hidden = NO;
    }
    else
    {
        muteButton.hidden = NO;
    }
    
    if([[[UIDevice currentDevice] systemVersion] compare:@"4.3" options:NSNumericSearch] == NSOrderedDescending)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        int highscore_check = [prefs integerForKey:@"score_best"];
        
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        [localPlayer authenticateWithCompletionHandler:^(NSError *error) {

        if(localPlayer.isAuthenticated) 
        {

            GKScore *scoreReporter = [[GKScore alloc] initWithCategory:@"1"];
            scoreReporter.value = highscore_check;
            
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

- (IBAction)resetAchievements:(id)sender
{
    [user reset];
    [user resetAchievements];
}

- (void) viewDidAppear:(BOOL)animated
{
    displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(gameLoop:)];
[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

}

- (IBAction)clickLeaderboard:(id)sender
{
    [displayLink invalidate];
    displayLink = nil;
    [self showLeaderboard];
}

- (IBAction)clickAchievements:(id)sender
{
    [displayLink invalidate];
    displayLink = nil;
    [self showAchievements];
}

- (void)viewDidUnload
{
    [displayLink invalidate];
    displayLink = nil;
    [super viewDidUnload];
}

- (void) gameLoop:(CADisplayLink *) sender
{
    [ball update];
}

#pragma mark GameKit delegate

- (void) showLeaderboard;
{
	GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	if (leaderboardController != NULL) 
	{
		leaderboardController.category = @"1";
		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
		leaderboardController.leaderboardDelegate = self; 
		[self presentModalViewController: leaderboardController animated: YES];
	}
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	[self dismissModalViewControllerAnimated: YES];
}

- (void) showAchievements
{
	GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
	if (achievements != NULL)
	{
		achievements.achievementDelegate = self;
		[self presentModalViewController: achievements animated: YES];
	}
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;
{
	[self dismissModalViewControllerAnimated: YES];
}

@end
