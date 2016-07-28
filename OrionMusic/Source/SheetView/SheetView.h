//
//  SheetView.h
//  OrionMusic
//
//  Created by TianHang on 10/5/13.
//
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"

#import "LBYouTube.h"

enum {
	kSheetViewTypeNone,
	kSheetViewTypeProfile,
	kSheetViewTypeCharts,
	kSheetViewTypeVideo,
    kSheetViewTypeVideoArtist,
    kSheetViewTypeVideoSearch,
    kSheetViewTypePlaylist,
	kSheetViewTypeBadges,
	kSheetViewTypeFindFriends,
	kSheetViewTypeSettings,
};

@interface SheetView : UIViewController <LBYouTubePlayerControllerDelegate> {
	NSInteger		m_nType;
	IBOutlet UILabel*	m_title;
	IBOutlet UIView*	m_view;
    NSMutableArray *m_subViewControllers;
}

@property (weak, nonatomic) IBOutlet HeaderView *m_headerView;
@property (strong, nonatomic) NSMutableArray *m_subViewControllers;
@property (nonatomic) NSInteger type;

+ (id)sharedObject;
- (void)showSheetView:(NSInteger)type;
- (void)showTable:(BOOL)bShow Animation:(BOOL)bAnimation;
- (IBAction)onShowSheet:(id)sender;

@end
