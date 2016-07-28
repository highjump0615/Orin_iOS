//
//  InviteFriendView.m
//  OrionMusic
//
//  Created by TianHang on 10/21/13.
//
//

#import "InviteFriendView.h"
#import "GameUtility.h"

@interface InviteFriendView ()

@end

@implementation InviteFriendView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"InviteFriendView" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[m_textMail becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSend:(id)sender {
	MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setSubject:@"Invitation"];
	
	NSArray *usersTo = [NSArray arrayWithObject:m_textMail.text];
	[controller setToRecipients:usersTo];
	
	NSString* strMsg = [NSString stringWithFormat:@"You friend %@ has invited you to try out Orin https://itunes.apple.com/us/app/orin-music/id729548913?ls=1&mt=8 %@", [[GameUtility sharedObject] userProfile].userName, @""];
	[controller setMessageBody:strMsg isHTML:NO];
	if (controller) {
        [self presentViewController: controller animated: YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
	if (result == MFMailComposeResultSent) {
		GameUtility *utils = [GameUtility sharedObject];
		UserProfile* profile = [[GameUtility sharedObject] userProfile];
		profile.inviteCount++;
		[utils updateCountValue];
		
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Invitation has been sent successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		alert.tag = 1000;
	}
	else {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Invitation failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView.tag == 1000) {
//		[self.navigationController popViewControllerAnimated:YES];
	}
}

@end
