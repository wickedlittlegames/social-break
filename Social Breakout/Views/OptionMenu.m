//
//  OptionMenu.m
//  Social Breakout
//
//  Created by Andrew Girvan on 11/01/2012.
//  Copyright (c) 2012 Wicked Little Websites. All rights reserved.
//

#import "OptionMenu.h"

@implementation OptionMenu
@synthesize tweetCountLabel, tweetTimeLabel, tweetCountSlider, tweetTimeSlider;

-(IBAction)tweetSliderChanged:(id)sender 
{
    UISlider *slider = (UISlider *)sender;
    int slider_progress = (int)slider.value;
    
    NSString *text_update = @"Extreme"; 
    if (slider_progress <= 75) text_update = @"High";
    if (slider_progress <= 50) text_update = @"Medium";
    if (slider_progress <= 20) text_update = @"Low";
    
    NSString *text_update2 = [NSString stringWithFormat:@"%d", slider_progress];    
    tweetCountLabel.text = text_update;
    
    [user.udata setValue:text_update2 forKey:@"SETTING_TWEETCOUNT"];
    [user.udata synchronize];
}

-(IBAction)tweetTimerSliderChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    int slider_progress = (int)slider.value;
    NSString *text_update = ( slider_progress == 1 ? [NSString stringWithFormat:@"%d second", slider_progress] : [NSString stringWithFormat:@"%d seconds", slider_progress]);
    NSString *text_update2 = [NSString stringWithFormat:@"%d", slider_progress]; 
    tweetTimeLabel.text = text_update;
    
    [user.udata setValue:text_update2 forKey:@"SETTING_READTIME"];
    [user.udata synchronize];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    int tweetCount = ([user.udata integerForKey:@"SETTING_TWEETCOUNT"] ? [user.udata integerForKey:@"SETTING_TWEETCOUNT"] : 40);
    int tweetTimer = ([user.udata integerForKey:@"SETTING_READTIME"] ? [user.udata integerForKey:@"SETTING_READTIME"] : 3);
    
    NSString *tweetCountText = @"Extreme"; 
    if (tweetCount <= 75)
    {
        tweetCountText = @"High";
    }
    if (tweetCount <= 50)
    {
        tweetCountText = @"Medium";
    }
    if (tweetCount <= 20) 
    {
        tweetCountText = @"Low";
    }
    
    NSString *tweetTimerText = [NSString stringWithFormat:@"%d seconds", tweetTimer];
    
    tweetTimeLabel.text = tweetTimerText;
    tweetCountLabel.text = tweetCountText;

    tweetCountSlider.value = tweetCount;
    tweetTimeSlider.value = tweetTimer;
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
