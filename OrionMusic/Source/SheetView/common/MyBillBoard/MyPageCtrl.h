//
//  MyPageCtrl.h
//  IPhoneCMVideoCS
//
//  Created by apple on 11-6-15.
//  Copyright 2011年 上海网达软件有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyPageControl : UIPageControl
{
    UIImage *imagePageStateNormal;
    UIImage *imagePageStateHighlighted;
}
- (id)initWithFrame:(CGRect)frame;
@property (nonatomic, retain) UIImage *imagePageStateNormal;
@property (nonatomic, retain) UIImage *imagePageStateHighlighted;
@end
