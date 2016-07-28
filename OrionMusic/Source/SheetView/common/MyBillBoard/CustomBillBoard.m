//
//  CustomBillBoard.m
//  IPhoneCMVideoCS
//
//  Created by apple on 11-6-15.
//  Copyright 2011年 上海网达软件有限公司. All rights reserved.
//

#import "CustomBillBoard.h"

@implementation CustomBillBoard
@synthesize _noticeNameArray;
@synthesize _noticeUrlArray;
@synthesize delegate;
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        UIImage *image = [UIImage imageNamed:@"theme1_billboardback.png"];
        [imageView setImage:image];
        [self addSubview:imageView];
        [imageView release];
        btnTitle = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        btnTitle.backgroundColor = [UIColor clearColor];
        [btnTitle addTarget:self action:@selector(btnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnTitle];
        timer = nil;
    }
    return self;
}

-(void)timerFunc
{
    curTitleIndex++;
    if (curTitleIndex>=kNumberOfTitles) {
        curTitleIndex=0;
    }
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.fillMode = kCAFillModeForwards;
	animation.removedOnCompletion = NO;
    animation.repeatCount = 1;
    [btnTitle setTitle:[_noticeNameArray objectAtIndex:curTitleIndex] forState:UIControlStateNormal];
    animation.type = @"rippleEffect";
	[self.layer addAnimation:animation forKey:@"animation"];
    
}

- (IBAction) btnTouched: (id) sender
{
    if ([_noticeUrlArray count] <= curTitleIndex)
    {
        return;
    }
    [delegate OnBillBoardTouched:[_noticeUrlArray objectAtIndex:curTitleIndex]];

}


-(void) start:(NSMutableArray*)noticeNameArray UrlArray:(NSMutableArray*)noticeUrlArray TimeInterval:(float)interval
{
    
    curTitleIndex = 0;
    self._noticeNameArray = (NSMutableArray *)noticeNameArray;
    self._noticeUrlArray = (NSMutableArray *)noticeUrlArray;
    if ([_noticeNameArray count] <= 0)
    {
        return;
    }
    kNumberOfTitles = [_noticeNameArray count];
    if (timer == nil) {
         timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerFunc) userInfo:nil repeats:YES];
    }
    
    [btnTitle setTitle:[_noticeNameArray objectAtIndex:curTitleIndex] forState:UIControlStateNormal];
    
    
}

- (void)dealloc
{
    [btnTitle release];
    [super dealloc];
}

@end
