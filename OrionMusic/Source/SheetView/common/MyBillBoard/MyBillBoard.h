//
//  MyBillBoard.h
//  PageControl
//
//  Created by rxue on 11-6-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCache.h"
#import "MyPageCtrl.h"

#define PAGECONTROL_HEIGHT 26
#define TYPE_INITWITHIMAGE  0
#define TYPE_INITWITHURL    1

@protocol PlayBoardDelegate <NSObject>
@optional
- (void)OnPlayBoardTouched:(NSString *)sUrl;
- (void)OnPlayBoardPageChange:(int)index;
@end

// 下载状态
typedef enum 
{
    PAGECONTROL_BOTTOM_NOBACK,              //pageCtl位于正下方，无背景图片
    PAGECONTROL_BOTTOM_BACK,                //pageCtl位于正下方，有背景图片
    PAGECONTROL_BOTTOM_RIGHT_BACK,          //pageCtl位于右下方，有背景图片
    PAGECONTROL_BOTTOM_RIGHT_NOBACK         //pageCtl位于右下方，无背景图片
    
}PageCtrlStyle;

@interface MyBillBoard : UIView<UIScrollViewDelegate> {
    UIScrollView    * _scrollView;          //UIScrollView
    MyPageControl   * _pageControl;         //UIPageControl lvjl
    UILabel         * _labelContentName;    //海报名称   
    NSMutableArray  * _imageViewArray;      //UIScrollView里要添加的UIImageView数组
    NSMutableArray  * m_pImageNameList;     //经过处理的图片名称数组，可能是图片名称，或url
    NSMutableArray  * _imageArray;          //图片名称数组
    NSMutableArray  * _imageUrlArray;       //图片url数组
    NSMutableArray  * _contentUrlArray;     //内容url数组
    NSMutableArray  * _contentNameArray;    //名称数组
    int kNumberOfPages;                     //页面总数（实际数+2）
    BOOL pageControlUsed;
    
    //pagecontrol是否被使用
    int initType;                           //初始化类型  用图片名称数组初始化还是url初始化 
    NSTimer *_timer;                        //自动滚动定时器
    PageCtrlStyle _style;                   //pagecontrl的布局类型 见 PageCtrlStyle
    UIImageView *_pageCtlBack;              //pagecontrl的背景图片
    ImageCache *imageCache;                 //图片缓存类
    id <PlayBoardDelegate> delegate;      //委托
    
    int pageCltWidth;                    //pagecontrl 宽度
    //BOOL bDay; //白天模式
    BOOL isLoaded;
    UIImageView *lineImg;
    UILabel *xiaBackImg;
}
//图片名称数组
@property (nonatomic,retain) NSMutableArray *_imageArray;
//图片Url数组
@property (nonatomic,retain) NSMutableArray *_imageUrlArray;
//内容名称数组
@property (nonatomic,retain) NSMutableArray  *_contentNameArray;  
//内容链接数组
@property (nonatomic,retain) NSMutableArray  *_contentUrlArray;
@property int pageCltWidth;
//委托
@property (nonatomic, retain) id <PlayBoardDelegate> delegate;

//@property (nonatomic) BOOL bDay;;

//点击海报
- (IBAction)imageViewTouched:(id)sender;
//用image名称数组初始化
-(void)initBillBordWithImage:(NSMutableArray*)imageArray PageCtrlStyle:(PageCtrlStyle)style AutoScroll:(BOOL)flag TimeInterval:(float)interval;
//用imageurl数组初始化
-(void)initBillBordWithImageUrl:(NSMutableArray *)imageUrlArray ContentNameArray:(NSMutableArray *)contentNameArray ContentUrlArray:(NSMutableArray *)contentUrlArray PageCtrlStyle:(PageCtrlStyle)style AutoScroll:(BOOL)flag TimeInterval:(float)interval;
//加载制定页面的UIImageView
-(void)loadScrollViewWithPage:(int)page;
//pagectrol的相应事件
-(void)changePage:(int)page;
//定时器事件
-(void)timerFunc;
//设置PageCtrl样式
-(void)setPageCtrlStyle:(PageCtrlStyle)style PageCount:(int)count;

-(void)UpdateTheme;

@end
