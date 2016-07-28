//
//  SignupView.h
//  Orin
//
//  Created by TianHang on 12/5/13.
//  Copyright (c) 2013 234 Digital Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginSignupView.h"

@interface SignupView : LoginSignupView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *m_txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *m_txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *m_txtPassword;

- (IBAction)onLogin:(id)sender;
- (IBAction)onSignup:(id)sender;
- (IBAction)onClose:(id)sender;

@end
