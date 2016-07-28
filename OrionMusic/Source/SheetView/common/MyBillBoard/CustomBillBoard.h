//
//  CustomBillBoard.h
//  IPhoneCMVideoCS
//
//  Created by apple on 11-6-15.
//  Copyright 2011年 上海网达软件有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol CustomBillBoardDelegate <NSObject>
@optional
- (void)OnBillBoardTouched:(NSString *)sUrl;
@end

@interface CustomBillBoard : UIView {
    NSMutableArray *_noticeNameArray;
    NSMutableArray *_noticeUrlArray;
    
    UIButton *btnTitle;
    int curTitleIndex;
    int kNumberOfTitles;
    id <CustomBillBoardDelegate> delegate;
    NSTimer *timer;
    
    UIImageView *imageView;
}
@property (nonatomic,retain) NSMutableArray *_noticeNameArray;
@property (nonatomic,retain) NSMutableArray *_noticeUrlArray;
@property (nonatomic, retain) id <CustomBillBoardDelegate> delegate;
@property (nonatomic,retain) UIImageView *imageView;

-(void) start:(NSArray*)noticeNameArray UrlArray:(NSMutableArray*)noticeUrlArray TimeInterval:(float)interval;
//定时器事件
-(void)timerFunc;
- (IBAction) btnTouched: (id) sender;
@end
