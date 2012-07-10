//
//  Game.m
//  Social Breakout
//
//  Created by Andrew Girvan on 11/01/2012.
//  Copyright (c) 2012 Wicked Little Websites. All rights reserved.
//

#import "Game.h"

// timer implementations


@implementation Game
@synthesize scoreLabel, livesLabel, playPauseButton, gameOverLabel, playToRestartLabel, tweetTextLabel, loadingScreen, powerupLabel, border_nlol, border_plol, pausedImage, exitButton, tweetPanel, tweetUserLabel, tweetAvatar, spinner, tweetDateLabel, gameModeLabel, extremeLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil gameMode:(NSString*)gameMode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"bong.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"powerup-sfx.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"death.wav"];    
    
    displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(gameLoop:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self playPause];
    
    if (self) 
    {
        
        user = [[User alloc] init];
        
        // Setting up the UI stuff
        score = 0;
        loaderCount = 0;
        playerDied = NO;
        lives = setting_starting_lives; 
        is_gameover = NO;
        scoreMultiplier = 1;
        is_online = (gameMode == @"online") ? 1 : 0;
        is_extreme = (gameMode == @"extreme") ? 1 : 0;
        powerup_countdown = 0;
        powerupActive = NO;
        has_respawned = NO;
        scoreExtraText = @"";
        audioPitch = 1.0;
        pausedImage.hidden = YES;
        paddlehitCount = 0;
        powerupTimer = 5;
        reverseMode = NO;
        
        // Setup the blocks
        blocks = [NSMutableArray arrayWithCapacity:setting_block_max];
        
        // Set up the collected tweets array
        collected_tweets = [[NSMutableArray alloc] init];
        paddle_positions = [[NSMutableArray alloc] initWithCapacity:5];
    
        // Set up the paddle
        paddle = (Paddle *)[Paddle blockAtPosition:CGPointMake(160, 385) withImageNamed:@"paddle.png"];
        paddle.hidden = YES;
        [self.view addSubview:paddle];
        
        // Set up the ball
        ball = [[Ball alloc ] initWithPosition:CGPointMake(80, 280)];
        ball.hidden = YES;
        ball.tweetPanelAnimating = NO;
        [self.view addSubview:ball];
        
        extremeLabel.hidden = YES;
        
        if ( is_extreme ) 
        {
            lives = setting_extreme_starting_lives;
            [paddle decreaseSize];
            ball.speed = CGPointMake(4,4);
            extremeLabel.hidden = NO;
        }
        livesLabel.text = [NSString stringWithFormat:@"%d",lives];
        
        [self spawnBlocks];
    }
    
    return self;
}

- (void) spawnBlocks
{
    if ( is_online )
    {
        // call to twitter to get the latest 100 tweets
        ACAccountStore *store = [[ACAccountStore alloc] init];
        ACAccountType *twitterAccountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        //  Request access from the user for access to his Twitter accounts
        [store requestAccessToAccountsWithType:twitterAccountType withCompletionHandler:^(BOOL granted, NSError *error) 
         {
             if (!granted) 
             {
                 is_twitter_down = YES;
                 is_online = !is_twitter_down;
             } 
             else 
             {
                 // Grab the available accounts
                 NSArray *twitterAccounts = [store accountsWithAccountType:twitterAccountType];
                 
                 if ([twitterAccounts count] > 0) 
                 {
                     SBJsonParser *parser = [[SBJsonParser alloc] init];
                     ACAccount *account = [twitterAccounts objectAtIndex:0];                 
                     NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                     [params setObject:@"0" forKey:@"include_entities"];
                     [params setObject:@"100" forKey:@"count"];
                     
                     NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/home_timeline.json"];
                     
                     TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:params requestMethod:TWRequestMethodGET];
                     
                     [request setAccount:account];
                     [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                      {
                          if (error != nil || [urlResponse statusCode] != 200) 
                          {
                              // inspect the contents of error 
                              is_twitter_down = YES;
                              is_online = !is_twitter_down;
                              gameModeLabel.hidden = NO;
                          } 
                          else 
                          {
                              NSError *jsonError;
                              NSString *json_string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                              NSArray *statuses = [parser objectWithString:json_string error:&jsonError];
                              
                              if (jsonError == nil) 
                              {  
                                  tweet_data = [[NSMutableArray alloc] init];
                                  for (NSDictionary *status in statuses)
                                  {
                                      NSString *tweet_text = [status objectForKey:@"text"];
                                      NSString *tweet_url  = [[status objectForKey:@"user"] objectForKey:@"profile_image_url"];
                                      NSString *tweet_name = [[status objectForKey:@"user"] objectForKey:@"screen_name"];
                                      NSString *tweet_date = [status objectForKey:@"created_at"];
                                      NSString *tweet_id = [status objectForKey:@"id"];
                                      NSString *tweet_page_url_full = [NSString stringWithFormat:@"http://twitter.com/%@/status/%@",tweet_name, tweet_id];
                                      
                                      NSString *tweet_page = [NSURL URLWithString:tweet_page_url_full];
                                      // set to status/username/id
                                      
                                      NSMutableArray *individual_tweet = [[NSMutableArray alloc] 
                                                                          initWithObjects:
                                                                          tweet_text,
                                                                          tweet_url,
                                                                          tweet_name,
                                                                          tweet_date,
                                                                          tweet_page, nil];
                                      [tweet_data addObject:individual_tweet];
                                  }
                              } 
                              else 
                              { 
                                  //NSLog(@"%@", jsonError);
                              }
                              
                          }
                      }];
                 }
             }
         }];
    }
    
    timer_placeBlocks = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                         target:self
                                                       selector:@selector(placeBlocks)
                                                       userInfo:nil
                                                        repeats:YES];
}

- (void) placeBlocks
{
    loaderCount++;

    if ( spinner.hidden )
    {
        spinner.hidden = NO;
        [spinner startAnimating];
    }
    
    //NSLog(@"Placing blocks...");
    if (is_online && !is_twitter_down)
    {
        // This is where the countdown/timeout needs to be. Also show a loader.
        if (loaderCount > 60) 
        {
            is_online = NO;
            is_twitter_down = YES;
            
            return;
        }
        if ( tweet_data != NULL )
        {
            //NSLog(@"Block being placed with tweet data");
            int x = 4;
            int y = 35;
            int counter = 0;
            Block *aBlock;
            for (int i = 0; i < config_blocks_rows; i++)
            {
                for (int j = 0; j < config_blocks_cols; j++)
                {  
                    if(arc4random()%100 < ([user.udata integerForKey:@"SETTING_TWEETCOUNT"]) && counter < [tweet_data count]) 
                    {
                        aBlock = [Block blockAtPosition:CGPointMake(x,y) withImageNamed:@"block_tweet.png"];
                        aBlock.tweet_data = [tweet_data objectAtIndex:counter];
                    }
                    else 
                    {
                        aBlock = [Block blockAtPosition:CGPointMake(x,y)];
                    }
                    aBlock.tag = i;
                    [self.view addSubview:aBlock];
                    [blocks addObject:aBlock];
                    x = x + 26;
                    counter++;
                    
                    //NSLog(@"Added a tweet block: %@", aBlock.tweet_data);
                }
                x = 4;
                y = y + 26;
            }
        }
    }
    else
    {
        if( is_twitter_down && gameModeLabel.hidden == YES )
        {
            gameModeLabel.hidden = NO;
        }
        //NSLog(@"Putting them in normally, no tweets...");
        // just place normally
        int x = 4;
        int y = 35;
        int counter = 0;
        
        Block *aBlock;
        for (int i = 0; i < config_blocks_rows; i++)
        {
            for (int j = 0; j < config_blocks_cols; j++)
            {  
                aBlock = [Block blockAtPosition:CGPointMake(x,y)];
                aBlock.tag = i;
                [self.view addSubview:aBlock];
                [blocks addObject:aBlock];
                x = x + 26;
                counter++;
            }
            x = 4;
            y = y + 26;
        }
    }
    
    if( tweet_data != NULL || !is_online )
    {
        //NSLog(@"Killing the place blocks method");
        // kill all ui elements and the timer
        loadingScreen.hidden =      YES;
        playPauseButton.hidden =    NO;
        
        scoreLabel.hidden =         NO;
        paddle.hidden =             NO;
        ball.hidden =               NO;
        has_respawned =             NO;
        
        //NSLog(@"Checking spinner value");
        if ( spinner.hidden == NO )
        {
            spinner.hidden = YES;
            [spinner stopAnimating];
            [self playPause];
        }
        
        [timer_placeBlocks invalidate];
        timer_placeBlocks = nil;
    }
    
}

- (void) gameLoop:(CADisplayLink *) sender
{
    if ( [ball isAboveLifeLine] ) 
    {
        // do normal game stuff
        if ( paddle_positions.count >= 5 ) 
            [paddle_positions removeAllObjects];
        else
            [paddle_positions addObject:[NSNumber numberWithFloat:paddle.center.x]];
        
        CGPoint nextPosition = [ball nextPosition];
        
        if ( [blocks count] == 0 && ball.nextPosition.y > config_block_line && has_respawned == NO)
        {
            has_respawned = YES;
            spinner.hidden = NO;
            [spinner startAnimating];
            playerDied = YES;
            [self playPause];
            if ( is_extreme ) [user reportAchievementIdentifier:@"ACH_EXTREME_ROUND" percentComplete:100.0];
            [self spawnBlocks];
        }
        
        
        // check for paddle and ball intersection
        if ( [paddle isImpactWithBallAtPosition:nextPosition] && paddlehitCount == 0)
        {
            paddlehitCount++;
            
            if ( ![SimpleAudioEngine sharedEngine].mute )
            {
                [[SimpleAudioEngine sharedEngine] playEffect:@"bong.mp3" pitch:0.75 pan:1 gain:1];
            }
            
            if(ball.speed.x <= 8)
            {
                ball.speed = CGPointMake(ball.speed.x + 0.03, ball.speed.y + 0.03);
            }
            
            if(ball.speed.x == 8)
            {
                [user reportAchievementIdentifier:@"ACH_MAX_SPEED" percentComplete:100.0];
            }
            
            float movement_amount = 0.0;
            
            if ( paddle_positions.count > 0 )
            {
                id first_id = [paddle_positions objectAtIndex:0];
                id last_id  = [paddle_positions objectAtIndex:(paddle_positions.count-1)];
                
                movement_amount = [last_id floatValue] - [first_id floatValue];
                movement_amount = movement_amount / 100;
            }
            
            ball.direction = CGPointMake(ball.direction.x * (1.0), ball.direction.y * (-1.0));
        }
        
        if ( ![ball isWithinStageBounds] )
        {
            paddlehitCount = 0;
        }
        
        // check for paddle intersection with block
        for (Block *block in blocks)
        {   
            if ( [block isImpactWithBall:ball.frame] )
            {
                paddlehitCount = 0;
                [FlurryAnalytics logEvent:@"Block Hit"];
                
                if ( ![SimpleAudioEngine sharedEngine].mute ) 
                {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"bong.mp3" pitch:audioPitch pan:1 gain:1];
                    audioPitch += .01;
                }
                
                if ([block.tweet_data objectAtIndex:0] != nil)
                {
                    // Collect the tweets to send over to GO screen
                    [collected_tweets addObject:block.tweet_data];
                    user.tweets_collected_overall++;
                    tmp_stat_blocks++;
                    
                    [user reportAchievementIdentifier:@"ACH_100_TWEETBLOCK_HIT" percentComplete:user.tweets_collected_overall];
                    [user reportAchievementIdentifier:@"ACH_TWEETBLOCK_HIT" percentComplete:100.0];
                    
                    if( ball.tweetPanelAnimating == NO ) 
                    {
                        // Show the slow motion panel opening
                        [ball slowMoBeginwithTweet:block.tweet_data withLabelUser:tweetUserLabel withLabelTweet:tweetTextLabel withAvatar:tweetAvatar withPanel:tweetPanel];
                        
                        // flag as animated
                        ball.tweetPanelAnimating = YES;
                        
                        // Log Tweet shown
                        [FlurryAnalytics logEvent:@"Tweet Block Hit"];
                    }
                }
                else
                {
                    if (powerupCount == 0 && !powerupActive && !is_extreme)
                    {
                        powerup = [[Powerup alloc] initAtPosition:CGPointMake(block.center.x, block.center.y)];
                        if ( powerup != NULL )
                        {
                            if ( ![SimpleAudioEngine sharedEngine].mute ) 
                            {
                                [[SimpleAudioEngine sharedEngine] playEffect:@"powerup-sfx.mp3"];
                            }
                            
                            [FlurryAnalytics logEvent:@"Powerup Generated"];
                            
                            [self.view addSubview:powerup];
                            powerupCount++;
                        }
                    }
                }
                
                // block direction check
                if ( [block isImpactWithBallOnSides:ball.frame] && ball.direction.y > 0 )
                {
                    [ball bouncedown];
                }
                else
                {   
                    [ball bounce];
                }
                
                // if its a dead block
                if ( [block update] == 0 )
                {
                    [blocks removeObject:block];
                    [block removeFromSuperview];
                    [self updateScore];
                }
                
                break;
                
            }
        }
        
        // check for paddle interesection with powerup
        if ( CGRectIntersectsRect(paddle.frame, powerup.frame) && !powerup.hidden )
        {
            // Log
            [FlurryAnalytics logEvent:@"Powerup Touched"];
            
            powerupActive = YES;
            powerup.active_icon = NO;
            powerup.hidden = YES;
            powerupCount--;
            
            switch ( powerup.powerupType )
            {
                    // double points
                case 0:
                    [FlurryAnalytics logEvent:@"Powerup Activated: Double Points"];
                    scoreMultiplier = 2;
                    powerupTimer = 15;
                    scoreExtraText = @"(2x)";
                    scoreLabel.text = [NSString stringWithFormat:@"%d %@",score,scoreExtraText];
                    border_plol.hidden = NO;
                    break;
                    
                    // smaller paddle
                case 1:
                    [FlurryAnalytics logEvent:@"Powerup Activated: Smaller Paddle"];
                    [paddle decreaseSize];
                    border_nlol.hidden = NO;
                    break;
                    
                    // bigger paddle
                case 2:
                    [FlurryAnalytics logEvent:@"Powerup Activated: Bigger Paddle"];
                    [paddle increaseSize];
                    border_plol.hidden = NO;
                    break;
                    
                    // extra life
                case 3:
                    [FlurryAnalytics logEvent:@"Powerup Activated: Extra Life"];
                    lives++;
                    powerupTimer = 1;
                    border_plol.hidden = NO;
                    livesLabel.text = [NSString stringWithFormat:@"%d",lives];
                    break;
                    
                    // reverse paddle
                case 4:
                    [FlurryAnalytics logEvent:@"Powerup Activated: Reverse Paddle"];
                    powerupTimer = 5;
                    border_nlol.hidden = NO;
                    reverseMode = YES;
                    break;
                    
                default:
                    break;
                    
            }
            
            timer_effects = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                             target:self
                                                           selector:@selector(powerupReset)
                                                           userInfo:nil
                                                            repeats:YES];
        }
        
        // move the powerup down and the ball around
        [powerup update];
        
        if (powerup.center.y > 500 && powerupCount == 1)
        {
            powerupCount--;
        }
        if ( lives >= 10 )
        {
            [user reportAchievementIdentifier:@"ACH_INDESTRUCTIBLE" percentComplete:100];
        }
        [ball update];
    }
    else
    {
        [self gameStateReset];
        
        // this is the end of a life, stuff needs to reset
        if ( [self updateLives] == 0 )
        {
            [self gameOver];
        }
        else
        {
            if ( ![SimpleAudioEngine sharedEngine].mute ) 
                [[SimpleAudioEngine sharedEngine] playEffect:@"death.wav"];
            
            playerDied = YES;
            [self playPause];
            audioPitch = 1.0;
            [ball resetAtPosition:CGPointMake(80,280)];
            [paddle resetAtPosition:CGPointMake(160,385)];
        }
    }
}

-(void) powerupReset
{   
    if ( powerup_countdown <= powerupTimer )
    {
        powerup_countdown++;
    }
    else 
    {
        [self gameStateReset];
    }
}

- (void) gameStateReset
{
    [timer_effects invalidate];
    timer_effects = nil;
    scoreMultiplier = 1;
    powerup_countdown = 0;
    powerupCount = 0;
    powerupTimer = 5;
    reverseMode = NO;
    powerup.hidden = YES;
    powerupActive = NO;
    border_nlol.hidden = YES;
    border_plol.hidden = YES;
    scoreExtraText = @"";
    loaderCount = 0;
    scoreLabel.text = [NSString stringWithFormat:@"%d %@",score,scoreExtraText];    
    [paddle resetSize];
}


- (void) updateScore
{
    score += (setting_score_per_block * scoreMultiplier);
    scoreLabel.text = [NSString stringWithFormat:@"%d %@",score,scoreExtraText];
}

- (int) updateLives
{
    lives--;
    livesLabel.text = [NSString stringWithFormat:@"%d",lives];
    return lives;
}

- (IBAction) playPause
{
    //On resume form game over hide the labels.
    if(is_gameover)
    {
        gameOverLabel.hidden = YES;
        playToRestartLabel.hidden = YES;
    }
    
    if ( playerDied == NO )
    {
    
    if(displayLink.paused)
    {
        for (Block *block in blocks)
        {
            block.alpha = 1;
            
        }
        ball.alpha = 1;
        paddle.alpha = 1;
    }
    else
    {
        for (Block *block in blocks)
        {
            block.alpha = 0.3;
            
        }
        ball.alpha = 0.3;
        paddle.alpha = 0.3;
    }
    
    pausedImage.hidden = displayLink.paused;
    }
    displayLink.paused = !displayLink.paused;
    exitButton.hidden = !displayLink.paused;
    
    [playPauseButton setImage:[UIImage imageNamed:displayLink.isPaused ? @"play.png" : @"pause.png"] forState:UIControlStateNormal];
    
    playerDied = NO;
}

- (void) gameOver 
{
    [user.udata setInteger:([user.udata integerForKey:@"STAT_BLOCKS"] + tmp_stat_blocks) forKey:@"STAT_BLOCKS"];
    [user.udata setInteger:([user.udata integerForKey:@"STAT_POWERUP_BIGGER"] + tmp_stat_powerup_bigger) forKey:@"STAT_POWERUP_BIGGER"];
    [user.udata setInteger:([user.udata integerForKey:@"STAT_POWERUP_ONEUP"] + tmp_stat_powerup_oneup) forKey:@"STAT_POWERUP_ONEUP"];
    [user.udata setInteger:([user.udata integerForKey:@"STAT_POWERUP_RANDOM"] + tmp_stat_powerup_random) forKey:@"STAT_POWERUP_RANDOM"];
    [user.udata setInteger:([user.udata integerForKey:@"STAT_POWERUP_REVERSE"] + tmp_stat_powerup_reverse) forKey:@"STAT_POWERUP_REVERSE"];
    [user.udata setInteger:([user.udata integerForKey:@"STAT_POWERUP_SCORE"] + tmp_stat_powerup_score) forKey:@"STAT_POWERUP_SCORE"];
    [user.udata setInteger:([user.udata integerForKey:@"STAT_POWERUP_SMALLER"] + tmp_stat_powerup_smaller) forKey:@"STAT_POWERUP_SMALLER"];    
    [user.udata setInteger:([user.udata integerForKey:@"STAT_DIED"] + tmp_stat_died) forKey:@"STAT_BLOCKS"];
    [user.udata setInteger:tmp_stat_mostlives forKey:@"STAT_MOSTLIVES"];    
    
    if ( is_online )
    {
        [user.udata setInteger:([user.udata integerForKey:@"STAT_ONLINE_PLAYED"] + 1) forKey:@"STAT_ONLINE_PLAYED"];
    }
    else if ( is_extreme )
    {
        [user.udata setInteger:([user.udata integerForKey:@"STAT_EXTREME_PLAYED"] + 1) forKey:@"STAT_EXTREME_PLAYED"];            
    }
    else 
    {
        [user.udata setInteger:([user.udata integerForKey:@"STAT_OFFLINE_PLAYED"] + 1) forKey:@"STAT_OFFLINE_PLAYED"];
    }
    
    [user.udata synchronize];
    
    [FlurryAnalytics logEvent:@"Game Over"];

    // grab the new view controller
    GameOver *gameOverViewController = [[GameOver alloc] initWithNibName:@"GameOver" bundle:[NSBundle mainBundle]];
    
    // score saving bit
    
    // set its properties
    gameOverViewController.modalTransitionStyle = transition;
    gameOverViewController.score_game = score;
    gameOverViewController.game_mode = (is_online == YES) ? @"online" : @"offline";
    if ( is_extreme )
    {
        gameOverViewController.game_mode = @"extreme";
    }
    gameOverViewController.tweet_data = collected_tweets;
    
    // then show it
    [self presentViewController:gameOverViewController animated:NO completion:nil];
}

- (IBAction) exitGame
{
    loadingScreen.hidden = NO;
    [self dismissModalViewControllerAnimated:YES];
}

- (void)pause 
{
    displayLink.paused = YES;
    [playPauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
}


/* CONTROLLER METHODS */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    
    if(!displayLink.isPaused)
    {
        
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint location = [touch locationInView:self.view];
        
        if ( reverseMode ) 
        {
            int newx = 320 - location.x; 
            paddle.center = CGPointMake(newx, paddle.center.y);
        }
        else
        {
            paddle.center = CGPointMake(location.x, paddle.center.y);
        }
    }
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
	[self touchesBegan:touches withEvent:event];
}

/* IOS SPECFIC METHODS */

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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

