//
//  VideoArtistViewController.h
//  Orin
//
//  Created by TianHang on 3/5/14.
//  Copyright (c) 2014 234 Digital Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoArtistView.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface VideoArtistViewController : UIViewController <EGORefreshTableDelegate,UIScrollViewDelegate> {
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
}

@property (weak, nonatomic) IBOutlet VideoArtistView *m_videoAritstView;

@end
