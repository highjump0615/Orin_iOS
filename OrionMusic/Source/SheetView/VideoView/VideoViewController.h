//
//  VideoViewController.h
//  OrionMusic
//
//  Created by TianHang on 10/11/13.
//
//

#import <UIKit/UIKit.h>
#import "MyBillBoard.h"
#import "GADBannerView.h"
#import "MKStoreManager.h"


@interface VideoViewController : UIViewController<PlayBoardDelegate,UIScrollViewDelegate,MKStoreKitDelegate> {
    
    NSMutableArray* popVideosItems;
    NSString* popVideosID;
    NSMutableArray* listVideosItems;
    NSMutableArray* tableVideosArray;
    NSMutableArray* playListArray;
    
    MyBillBoard *myPlayBoard;
    GADBannerView *bannerView_;
    
}


@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property(nonatomic, retain)   NSMutableArray* popVideosItems;
@property(nonatomic, retain)   NSMutableArray* listVideosItems;
@property(nonatomic, retain)   NSMutableArray* tableVideosArray;
@property(nonatomic, retain)   NSMutableArray* playListArray;
@property(nonatomic, retain)   NSString* popVideosID;

@property (nonatomic,retain) MyBillBoard *myPlayBoard;
@property (nonatomic,retain) ImageCache *imageCache;

@property (strong) id parentController;

@end
