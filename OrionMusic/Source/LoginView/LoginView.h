//
//  LoginView.h
//  OrionMusic
//
//  Created by Top1 on 10/7/13.
//
//

#import <UIKit/UIKit.h>
#import "LoginSignupView.h"

@interface LoginView : LoginSignupView <UITextFieldDelegate> {
	IBOutlet UITextField*	m_textUserName;
	IBOutlet UITextField*	m_textPassword;
}

- (IBAction)onLogin:(id)sender;
- (IBAction)onForget:(id)sender;
- (IBAction)onClose:(id)sender;

@end
