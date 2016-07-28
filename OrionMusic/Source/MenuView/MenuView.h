//
//  MenuView.h
//  OrionMusic
//
//  Created by TianHang on 10/5/13.
//
//

#import <UIKit/UIKit.h>

#import "SheetView.h"


@interface MenuView : UIViewController {
	IBOutlet UIButton*	m_btnProfile;
	IBOutlet UILabel*	m_labName;
    
    UIViewController *mSheetView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;

+ (id)sharedObject;

- (IBAction)onMyProfile:(id)sender;
- (IBAction)onCharts:(id)sender;
- (IBAction)onMusicVideos:(id)sender;
- (IBAction)onBadges:(id)sender;
- (IBAction)onFindFriends:(id)sender;
- (IBAction)onSettings:(id)sender;

@end
