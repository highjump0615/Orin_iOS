//
//  VideoSearchViewController.h
//  Orin
//
//  Created by TianHang on 3/2/14.
//  Copyright (c) 2014 234 Digital Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTLYouTube.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@interface VideoSearchViewController : UIViewController <UITextFieldDelegate,EGORefreshTableDelegate> {
    GTLServiceYouTube *service;

    NSMutableArray* searchResultArray;
    NSMutableArray* searchVideosIDArray;
    NSString* nexPageTokenString;
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;    //主要是记录是否在刷新中
    NSMutableArray* playListArray;
}

@property (strong) id parentController;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property(nonatomic, retain)   GTLServiceYouTube *service;
@property(nonatomic, retain)   NSMutableArray* searchResultArray;
@property(nonatomic, retain)   NSMutableArray* searchVideosIDArray;
@property(nonatomic, retain)   NSString* nexPageTokenString;
@property(nonatomic, retain)   NSMutableArray* playListArray;




@end
