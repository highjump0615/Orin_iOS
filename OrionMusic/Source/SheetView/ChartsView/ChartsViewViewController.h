//
//  ChartsViewViewController.h
//  OrionMusic
//
//  Created by TianHang on 10/18/13.
//
//

#import <UIKit/UIKit.h>
#import "ChartsView.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface ChartsViewViewController : UIViewController <EGORefreshTableDelegate,UIScrollViewDelegate> {
	//EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;

}

@property (strong, nonatomic) IBOutlet ChartsView *m_chartView;

@end
