//
//  ChangePwdView.h
//  OrionMusic
//
//  Created by TianHang on 10/19/13.
//
//

#import <UIKit/UIKit.h>
#import "GameUtility.h"

@interface ChangePwdView : UIViewController <RunningServiceDelegate, UIAlertViewDelegate> {
	IBOutlet UITextField*	m_textOldPwd;
	IBOutlet UITextField*	m_textNewPwd;
	IBOutlet UITextField*	m_textRetypePwd;
}

@end
