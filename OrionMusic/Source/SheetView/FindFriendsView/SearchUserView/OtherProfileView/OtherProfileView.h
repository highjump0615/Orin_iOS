//
//  OtherProfileView.h
//  OrionMusic
//
//  Created by TianHang on 10/11/13.
//
//

#import <UIKit/UIKit.h>
#import "GameUtility.h"

@interface OtherProfileView : UIViewController <RunningServiceDelegate> {
	IBOutlet UIButton*	m_btnEditProfile;
	
	IBOutlet UILabel*	m_labFullName;
	IBOutlet UILabel*	m_labAboutme;
	IBOutlet UILabel*	m_labWebsite;
	
	IBOutlet UILabel*	m_labBadges;
	IBOutlet UILabel*	m_labFollowers;
	IBOutlet UILabel*	m_labFollowing;
	
	UserProfile*		otherProfile;
	
	IBOutlet UIImageView*	m_imgPhoto;
	
	IBOutlet UIScrollView*	m_scrollBadges;
}

@property (strong, nonatomic) UserProfile* otherProfile;

- (void)refreshView;

@end
