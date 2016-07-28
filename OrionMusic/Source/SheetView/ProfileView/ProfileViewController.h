//
//  ProfileViewController.h
//  OrionMusic
//
//  Created by TianHang on 10/11/13.
//
//

#import <UIKit/UIKit.h>
#import "EditProfileView.h"

@interface ProfileView : UIView <EditProfileDelegate> {
}

@property (strong) id parentController;

@end


@interface ProfileViewController : UIViewController {
	IBOutlet UIImageView*	m_imgPhoto;
	
	IBOutlet UIButton*	m_btnEditProfile;
	
	IBOutlet UILabel*	m_labFullName;
	IBOutlet UILabel*	m_labAboutme;
	IBOutlet UILabel*	m_labWebsite;
	
	IBOutlet UILabel*	m_labBadges;
	IBOutlet UILabel*	m_labFollowers;
	IBOutlet UILabel*	m_labFollowing;
	
	IBOutlet UIScrollView*	m_scrollBadges;
    
}

- (void)refreshView;
- (IBAction)onShowMenu:(id)sender;

@property (strong) id parentController;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgBack;

@end
