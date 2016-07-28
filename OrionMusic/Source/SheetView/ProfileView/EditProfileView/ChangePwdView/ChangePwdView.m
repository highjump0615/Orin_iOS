//
//  ChangePwdView.m
//  OrionMusic
//
//  Created by TianHang on 10/19/13.
//
//

#import "ChangePwdView.h"

@interface ChangePwdView ()

@end

@implementation ChangePwdView

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDone:(id)sender {
	NSString* strOldPass = m_textOldPwd.text;
	NSString* strNewPass = m_textNewPwd.text;
	NSString* strRetypePass = m_textRetypePwd.text;
	if(strOldPass.length == 0 || strNewPass.length == 0 || strRetypePass.length == 0) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Type new password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		return;
	}
	if([strNewPass isEqualToString:strRetypePass] == NO) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Retype password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		return;
	}
	
	GameUtility* utils = [GameUtility sharedObject];
	UserProfile* profile = utils.userProfile;

	if([profile.password isEqualToString:strOldPass] == NO) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Old Password  is not correct" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		return;
	}
	
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 profile.userName, @"name",
						 strNewPass, @"password",
						 nil];
	[utils runWebService:@"changepassword" Param:dic Delegate:self View:self.view];
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark WebService
- (void)finishedRunningServiceDelegate:(NSDictionary *)outData {
	NSString* serviceName = outData[@"serviceName"];
	if([serviceName isEqualToString:@"changepassword"]) {
		NSString* result = outData[@"status"];
		if([result isEqualToString:@"OK"]) {
			UserProfile* profile = [[GameUtility sharedObject] userProfile];
			profile.password = m_textNewPwd.text;
			
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Password has been changed successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			alert.tag = 1000;
		}
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView.tag == 1000) {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

@end
