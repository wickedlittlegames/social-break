//
//  AppDelegate.h
//  Social Breakout
//
//  Created by Andrew Girvan on 11/01/2012.
//  Copyright (c) 2012 Wicked Little Websites. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlurryAnalytics.h"
#import "Game.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Game *stageViewController;
}

@property (strong, nonatomic) UIWindow *window;

@end
