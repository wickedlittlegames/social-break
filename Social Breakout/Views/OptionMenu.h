//
//  OptionMenu.h
//  Social Breakout
//
//  Created by Andrew Girvan on 11/01/2012.
//  Copyright (c) 2012 Wicked Little Websites. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionMenu : UIViewController
{
    UILabel *tweetCountLabel, *tweetTimeLabel;
    UISlider *tweetCountSlider, *tweetTimeSlider;
}

@property (strong, retain) IBOutlet UILabel *tweetCountLabel, *tweetTimeLabel;
@property (strong, retain) IBOutlet UISlider *tweetCountSlider, *tweetTimeSlider;

-(IBAction)tweetSliderChanged:(id)sender;
-(IBAction)tweetTimerSliderChanged:(id)sender;


@end
