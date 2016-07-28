//
//  ForgotView.h
//  OrionMusic
//
//  Created by Top1 on 10/7/13.
//
//

#import <UIKit/UIKit.h>
#import "LoginSignupView.h"

@interface ForgotView : LoginSignupView <UITextFieldDelegate> {
	IBOutlet UITextField*	m_textMail;
}

- (IBAction)onRequest:(id)sender;
- (IBAction)onLogin:(id)sender;
- (IBAction)onClose:(id)sender;

@end
