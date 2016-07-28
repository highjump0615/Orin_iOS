//
//  SignupView.m
//  Orin
//
//  Created by TianHang on 12/5/13.
//  Copyright (c) 2013 234 Digital Limited. All rights reserved.
//

#import "SignupView.h"
#import "LoginView.h"

@interface SignupView ()

@end

@implementation SignupView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIColor *color = [UIColor whiteColor];
    _m_txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    _m_txtUsername.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
    _m_txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
    LoginView* controller = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onSignup:(id)sender {
    if(_m_txtEmail.text.length == 0 || _m_txtUsername.text.length == 0 || _m_txtPassword.text.length == 0) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Fill user name, password and mail address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		return;
	}
    
    [self.view endEditing:YES];
    
    [self doSignup:_m_txtUsername.text password:_m_txtPassword.text email:_m_txtEmail.text];
}

- (IBAction)onClose:(id)sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
	if (textField == _m_txtEmail) {
		[_m_txtUsername becomeFirstResponder];
	}
	else if (textField == _m_txtUsername) {
		[_m_txtPassword becomeFirstResponder];
	}
    else if (textField == _m_txtPassword) {
        [textField resignFirstResponder];
    }
    
	return YES;
}


@end
