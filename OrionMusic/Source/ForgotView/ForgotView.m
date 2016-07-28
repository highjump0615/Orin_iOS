//
//  ForgotView.m
//  OrionMusic
//
//  Created by Top1 on 10/7/13.
//
//

#import "ForgotView.h"
#import "LoginView.h"


@implementation ForgotView

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
    m_textMail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRequest:(id)sender {
    if(m_textMail.text.length == 0) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Input email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		return;
	}
    
    [self.view endEditing:YES];
    
    [self forgetRequest:m_textMail.text];
}

- (IBAction)onLogin:(id)sender {
    
//    NSArray * controllerArray = [self.navigationController viewControllers];
//    
//    for (UIViewController * controller in controllerArray)
//    {
//        if ([controller isKindOfClass:[LoginView class]])
//        {
//            [self.navigationController popToViewController:controller animated:YES];
//            break;
//        }
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClose:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == m_textMail) {
        [textField resignFirstResponder];
    }
    
	return YES;
}


@end
