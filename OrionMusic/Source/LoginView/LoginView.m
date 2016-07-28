//
//  LoginView.m
//  OrionMusic
//
//  Created by Top1 on 10/7/13.
//
//

#import "LoginView.h"
#import "ForgotView.h"

#import "MenuView.h"
#import "SignupView.h"

@interface LoginView ()

@end

@implementation LoginView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIColor *color = [UIColor whiteColor];
    m_textUserName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
    m_textPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
    if(m_textUserName.text.length == 0 || m_textPassword.text.length == 0) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Fill user name and password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		return;
	}
    
    [self.view endEditing:YES];
    
    [self doLogin:m_textUserName.text password:m_textPassword.text];
}

- (IBAction)onForget:(id)sender {
    ForgotView* controller = [[ForgotView alloc] initWithNibName:@"ForgotView" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onClose:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma -mark
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == m_textUserName) {
		[m_textPassword becomeFirstResponder];
	}
	else if (textField == m_textPassword) {
        [textField resignFirstResponder];
    }
    
	return YES;
}

@end
