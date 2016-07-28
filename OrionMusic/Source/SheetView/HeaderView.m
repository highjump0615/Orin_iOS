//
//  HeaderView.m
//  Orin
//
//  Created by TianHang on 2/26/14.
//  Copyright (c) 2014 234 Digital Limited. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {

    CGPoint pt = [self convertPoint:point toView:self];
    int nHeightThreshold = self.frame.size.height / 82.0 * 48.0;
    
    if (pt.y > nHeightThreshold) {
        return NO;
    }
    else {
        return YES;
    }
}

@end
