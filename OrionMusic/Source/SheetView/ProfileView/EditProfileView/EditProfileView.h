//
//  EditProfileView.h
//  OrionMusic
//
//  Created by TianHang on 10/19/13.
//
//

#import <UIKit/UIKit.h>
#import "GameUtility.h"

@protocol EditProfileDelegate;
@interface EditProfileView : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, RunningServiceDelegate> {
	id <EditProfileDelegate> delegate;
	IBOutlet UIButton*	m_btnUserPicture;
	IBOutlet UITextField*	m_textFullName;
	IBOutlet UITextField*	m_textUserName;
//	IBOutlet UITextField*	m_textWebsite;
	IBOutlet UITextField*	m_textAboutMe;
	IBOutlet UITextField*	m_textEmail;
	IBOutlet UITextField*	m_textPhone;
	IBOutlet UISegmentedControl*	m_segGender;
	IBOutlet UIView*		m_view;
	
    int m_nPhotoImage;  // 1: photo
                        // 2: background
    int m_bPhotoSelected;
    
    UIImage *m_imgBackground;
}

@property (strong) id <EditProfileDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;

@end

@protocol EditProfileDelegate <NSObject>

- (void)editProfileDoneDelegate:(EditProfileView*)controller;

@end