//
//  MyBillBoard.m
//  PageControl
//
//  Created by apple on 11-6-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MyBillBoard.h"
#import "CMVideoUtil.h"
#import "MBProgressHUD.h"
#import "UIButton+WebCache.h"


@implementation MyBillBoard

@synthesize _imageArray;
@synthesize _imageUrlArray;
@synthesize _contentNameArray;
@synthesize _contentUrlArray;
@synthesize delegate;
@synthesize pageCltWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        pageCltWidth = 180;//frame.size.width - 10;
        
        //创建循环滚动的UIScrollView
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.backgroundColor = [UIColor clearColor];
        //创建pagectrl的背景
        _pageCtlBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-PAGECONTROL_HEIGHT, frame.size.width, PAGECONTROL_HEIGHT)];
        UIImage *PageCtrlBack = [UIImage imageNamed:@"touming_back.png"];
        _pageCtlBack.backgroundColor = [UIColor blueColor];
        [_pageCtlBack setImage:PageCtrlBack];
        
        //创建pagectrl
        _pageControl = [[MyPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height-PAGECONTROL_HEIGHT, frame.size.width-5, PAGECONTROL_HEIGHT)];
        [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        _pageControl.backgroundColor = [UIColor clearColor];
       // [_pageControl setUserInteractionEnabled:NO];
        //add by jienliang
        lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 240, 0, 3)];
        [lineImg setImage:[UIImage imageNamed:@"line1.png"]];
        //add end

        [_pageCtlBack addSubview:_pageControl];
        [self addSubview:_scrollView];
        [self addSubview:_pageCtlBack];
        [self addSubview:_pageControl];
        [self addSubview:lineImg];
        [lineImg release];

        [_scrollView release];
        [_pageControl release];
        [_pageCtlBack release];
        
        _imageUrlArray = nil;
        _imageArray = nil;
        _contentUrlArray = nil;
        _contentNameArray = nil;
        _timer = nil;
        m_pImageNameList = nil;
        
        UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 240-30, 320, 30)];
        [v setImage:[UIImage imageNamed:@"touming_back.png"]];
        [self addSubview:v];
        [v release];
        _pageControl.hidden = YES;
        //创建nameLabel
        _labelContentName = [[UILabel alloc] initWithFrame:CGRectMake(10, 240-30, 300,30)];
        [_labelContentName setTextAlignment:NSTextAlignmentCenter];
        _labelContentName.backgroundColor = [UIColor clearColor];
        _labelContentName.text = @"";
        _labelContentName.numberOfLines = 0;
        _labelContentName.textColor = [UIColor whiteColor];
        _labelContentName.font = [UIFont boldSystemFontOfSize:13];
        [self addSubview:_labelContentName];
        [_labelContentName release];
    }
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(getNetImageFinished:) name:@"getNetImageFinished" object:nil];
    return self;
}

- (void)getNetImageFinished:(id)sender
{
    NSDictionary *dic = (NSDictionary *)[sender object];
    if (dic!=nil&&[dic count]>0) {
        [CMVideoUtil setImageToObject:dic];
//        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
//        [nc postNotificationName:@"RefrashTable" object:nil];
    }
}

- (void)dealloc
{
    [super dealloc];
}

-(void)setPageCtrlStyle:(PageCtrlStyle)style PageCount:(int)count
{
    switch (style) {
        case PAGECONTROL_BOTTOM_NOBACK:
            _pageCtlBack.hidden = YES;
            break;
        case PAGECONTROL_BOTTOM_BACK:
            _pageCtlBack.hidden = NO;
            break;
        case PAGECONTROL_BOTTOM_RIGHT_NOBACK:
            _pageCtlBack.hidden = YES;
            
            CGRect frame = CGRectMake(_pageControl.frame.size.width - 25*count, _pageControl.frame.origin.y, 25*(count+1), _pageControl.frame.size.height);
            _pageControl.frame = frame;
            break;
        case PAGECONTROL_BOTTOM_RIGHT_BACK:
            _pageCtlBack.hidden = NO;
            //间距为16
             CGRect frame1 = CGRectMake(pageCltWidth - 16*count, _pageControl.frame.origin.y, 16*(count+1), _pageControl.frame.size.height);
            _pageControl.frame = frame1;
            break;
            
        default:
            break;
    }
}

-(void)timerFunc
{
    if([_scrollView isDecelerating]||[_scrollView isDragging]||[_scrollView isTracking])
        return;
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    //CGPoint point = CGPointMake((page+1)*pageWidth, 0);
    CGPoint point = CGPointMake((page+1)*pageWidth, 0);
    [_scrollView setContentOffset:point animated:YES];
//    [self scrollViewDidScroll:_scrollView];
}


-(void)initBillBordWithImageUrl:(NSMutableArray *)imageUrlArray ContentNameArray:(NSMutableArray *)contentNameArray ContentUrlArray:(NSMutableArray *)contentUrlArray PageCtrlStyle:(PageCtrlStyle)style AutoScroll:(BOOL)flag TimeInterval:(float)interval;
{
    initType = TYPE_INITWITHURL;
    [self setPageCtrlStyle:style PageCount:[imageUrlArray count]];
    self._imageUrlArray = (NSMutableArray *)imageUrlArray;
    
    
    //处理图片数组扩展前后图片以实现首尾循环效果
    if (m_pImageNameList == nil) {
        m_pImageNameList = [[NSMutableArray alloc] initWithCapacity:25];
        [m_pImageNameList addObject:[_imageUrlArray objectAtIndex:([_imageUrlArray count]-1)]];
        for (int i=0; i<[_imageUrlArray count]; i++) {
             [m_pImageNameList addObject:[_imageUrlArray objectAtIndex:i]];
        }
        [m_pImageNameList addObject:[_imageUrlArray objectAtIndex:0]];
    }//add by tsh 2011-12-2
    else{
        [m_pImageNameList removeAllObjects];
        [m_pImageNameList addObject:[_imageUrlArray objectAtIndex:([_imageUrlArray count]-1)]];
        for (int i=0; i<[_imageUrlArray count]; i++) {
            [m_pImageNameList addObject:[_imageUrlArray objectAtIndex:i]];
        }
        [m_pImageNameList addObject:[_imageUrlArray objectAtIndex:0]];

    }
    //end
    
    //处理内容数组
    self._contentNameArray = (NSMutableArray *)contentNameArray;    
    //处理内容链接数组
    self._contentUrlArray = (NSMutableArray *)contentUrlArray;

    kNumberOfPages = [_imageUrlArray count]+2;
    
    if (YES==flag&&kNumberOfPages>1) {
        if (_timer == nil) {
            _timer =  [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerFunc) userInfo:nil repeats:YES];
        }
    }
    
    _imageViewArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages;i++) {
        [_imageViewArray addObject:[NSNull null]];
    }
    
    // a page is the width of the scroll view
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * kNumberOfPages, _scrollView.frame.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    
    _pageControl.numberOfPages = kNumberOfPages-2;
    //[_pageControl setImagePageStateNormal:[UIImage imageNamed:@"dot_active.png"]];
    //[_pageControl setImagePageStateHighlighted:[UIImage imageNamed:@"dot_active.png"]];
    
    //只有一个只不显示page页
    if ([imageUrlArray count]==1) {
        _pageControl.hidden = YES;
        _scrollView.scrollEnabled = NO;
    }
    else
    {
        _pageControl.hidden = YES;
//        _pageControl.hidden = NO;
        _scrollView.scrollEnabled = YES;
    }
    CGFloat pageWidth = _scrollView.frame.size.width;
    CGPoint p = CGPointMake(pageWidth, 0);
    [_scrollView setContentOffset:p animated:NO];
    _pageControl.currentPage = 0;
 //   _labelContentName.text = [contentNameArray objectAtIndex:_pageControl.currentPage];
    lineImg.frame = CGRectMake(0, lineImg.frame.origin.y, 320/[_contentUrlArray count]*(_pageControl.currentPage+1), 3);

    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}


-(void)initBillBordWithImage:(NSMutableArray*)imageArray PageCtrlStyle:(PageCtrlStyle)style AutoScroll:(BOOL)flag TimeInterval:(float)interval
{
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    initType = TYPE_INITWITHIMAGE;
    [self setPageCtrlStyle:style PageCount:[imageArray count]];
    
    if (YES==flag&&[imageArray count]>1) {
        _timer =  [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerFunc) userInfo:nil repeats:YES];
    }
    
    if (m_pImageNameList == nil) {
        m_pImageNameList = [[NSMutableArray alloc] init];
    }
    
     kNumberOfPages = [m_pImageNameList count];
    _imageViewArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages;i++) {
        [_imageViewArray addObject:[NSNull null]];
    }
    
    // a page is the width of the scroll view
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * kNumberOfPages, _scrollView.frame.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    
    _pageControl.numberOfPages = kNumberOfPages-2;
    CGFloat pageWidth = _scrollView.frame.size.width;
    CGPoint p = CGPointMake(pageWidth, 0);
    [_scrollView setContentOffset:p animated:NO];
    _pageControl.currentPage = 0;
    _labelContentName.text = [_contentNameArray objectAtIndex:_pageControl.currentPage];
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
    // replace the placeholder if necessary
    UIButton *imageView = (UIButton*)[_imageViewArray objectAtIndex:page];
//    if ((NSNull *)imageView == [NSNull null])
    {
        if (initType == TYPE_INITWITHIMAGE) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentOfFile:[m_pImageNameList objectAtIndex:page]]];
        }
        else if(initType == TYPE_INITWITHURL)
        {
            if (imageCache == nil)
            {
                imageCache = [[ImageCache alloc] init];
            }
            imageView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
            imageView.tag = page;
            
            [imageView addTarget:self action:@selector(imageViewTouched:) forControlEvents:UIControlEventTouchUpInside];
            
           [imageCache initwithStringAndObject:[m_pImageNameList objectAtIndex:page] imageObj:imageView delegate:self];
            NSString *cachePath = [CMVideoUtil getCachePath];
            cachePath = [NSString stringWithFormat:@"%@/cache/image",cachePath];
            NSString *fileName = [CMVideoUtil md5:[m_pImageNameList objectAtIndex:page]];
            NSString *imgPath = [NSString stringWithFormat:@"%@/%@",cachePath,fileName.lowercaseString];
            NSFileManager *fileManager = [NSFileManager defaultManager];
//            if (![fileManager fileExistsAtPath:imgPath])
//            {
//                UIActivityIndicatorView *activityIndicator1 = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//                [imageView addSubview:activityIndicator1];
//                [activityIndicator1 release];
//                activityIndicator1.center = imageView.center;
//                [activityIndicator1 startAnimating];
//            }
        }
        if ([_imageViewArray objectAtIndex:page] == [NSNull null])
        {
            CGRect frame = _scrollView.frame;
            frame.origin.x = frame.size.width * page;
            frame.origin.y = 0;
            imageView.frame = frame;
            [_scrollView addSubview:imageView];
            [imageView release];
        }else
            [_imageViewArray replaceObjectAtIndex:page withObject:imageView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    CGPoint point = CGPointMake(page*pageWidth, 0);
    [_scrollView setContentOffset:point animated:NO];
    lineImg.frame = CGRectMake(0, lineImg.frame.origin.y, 320/[_contentUrlArray count]*(_pageControl.currentPage+1), 3);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
//    [_pageControl setImagePageStateNormal:[UIImage imageNamed:@"dot_normal.png"]];
//    [_pageControl setImagePageStateHighlighted:[UIImage imageNamed:@"dot_normal_h.png"]];
    if (pageControlUsed) {
        return;
    }
    for(UIView *subview in [_scrollView subviews])
    {
        [subview removeFromSuperview];
    }

    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = (page-1)%(kNumberOfPages-2);
    _labelContentName.text = [_contentNameArray objectAtIndex:_pageControl.currentPage];

    if (_scrollView.contentOffset.x>pageWidth*(kNumberOfPages-1)) {
        CGPoint p = CGPointMake(pageWidth, 0);
        [_scrollView setContentOffset:p animated:NO];
    }
   
    if (_scrollView.contentOffset.x<pageWidth) {
        CGFloat x = (kNumberOfPages-1)*pageWidth;
        CGPoint p1 = CGPointMake(x, 0);
        [_scrollView setContentOffset:p1 animated:NO];
    }

    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
    lineImg.frame = CGRectMake(0, lineImg.frame.origin.y, 320/[_contentUrlArray count]*(_pageControl.currentPage+1), 3);
}

-(void)changePage:(int)page
{
    _labelContentName.text = [_contentNameArray objectAtIndex:_pageControl.currentPage];
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    _pageControl.currentPage = page;
    // update the scroll view to the appropriate page
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * (page+1);
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

- (IBAction)imageViewTouched:(id)sender
{
    [delegate OnPlayBoardTouched:[_contentUrlArray objectAtIndex:_pageControl.currentPage]];
}

#pragma mark Table view  delegate methods
- (void)getImageFinished:(NSDictionary *)img
{
    [CMVideoUtil setImageToObject:img];
}

@end
