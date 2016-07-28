//
//  InviteFriendView.h
//  OrionMusic
//
//  Created by TianHang on 10/21/13.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface InviteFriendView : UIViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate> {
	IBOutlet UITextField*	m_textMail;
}

@end
