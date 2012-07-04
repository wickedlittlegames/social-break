//
//  Paddle.h
//  Social Breakout
//
//  Created by Andrew Girvan on 11/01/2012.
//  Copyright (c) 2012 Wicked Little Websites. All rights reserved.
//

#import "Block.h"

@interface Paddle : Block

- (Paddle *) init;
- (void) resetAtPosition:(CGPoint) position;
+ (Paddle *) blockAtPosition:(CGPoint) position withImageNamed:(NSString *) imgName;
- (void) increaseSize;
- (void) decreaseSize;
- (void) resetSize;
- (BOOL) isImpactWithBall:(CGRect)ball;

@end
