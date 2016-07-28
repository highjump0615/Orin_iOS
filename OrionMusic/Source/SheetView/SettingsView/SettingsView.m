//
//  SettingsView.m
//  OrionMusic
//
//  Created by TianHang on 10/11/13.
//
//

#import "SettingsView.h"
#import "TourView.h"
#import "AppDelegate.h"
#import "Appirater.h"
#import "GameUtility.h"

#import "TermsOfServiceView.h"
#import "FAQView.h"
#import "PrivacyPolicyView.h"

#import <FacebookSDK/FacebookSDK.h>


@interface SettingsView ()

@end

@implementation SettingsView

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
    
    NSLog(@"setting view: %f, %f, %f, %f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [GameUtility setPhoneFrame:self.view withHeader:YES];
 
    [self.mTableView setDelegate:self];
    [self.mTableView setDataSource:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 1;
		case 1:
			return 1;
		case 2:
			return 2;
		case 3:
			return 3;
		case 4:
			return 1;
		default:
			break;
	}
	return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *kSourceCellID = @"FindFriends";
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kSourceCellID];
	if(cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSourceCellID];
		switch (indexPath.section) {
			case 0: {
				cell.textLabel.text = @"Share unlocks & levels";
                
				UISwitch* btnSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(255, 7, 80, 30)];
                [btnSwitch setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
				[btnSwitch addTarget:self action:@selector(onSwitchShareUnlock:) forControlEvents:UIControlEventValueChanged];
				[cell addSubview:btnSwitch];
				btnSwitch.on = YES;
				
                cell.accessoryType = UITableViewCellAccessoryNone;
				
                break;
			}
			case 1: {
				cell.textLabel.text = @"Push Notifications";
                
                UISwitch* btnSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(255, 7, 80, 30)];
                [btnSwitch setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
				[btnSwitch addTarget:self action:@selector(onSwitchPushNotification:) forControlEvents:UIControlEventValueChanged];
				[cell addSubview:btnSwitch];
				btnSwitch.on = YES;
                
				cell.accessoryType = UITableViewCellAccessoryNone;
				
				break;
            }
                
			case 2:
				if(indexPath.row == 0) {
                    //					cell.textLabel.text = @"Take a tour";
                    cell.textLabel.text = @"Send feedback";
                }
				else if(indexPath.row == 1) {
                    //					cell.textLabel.text = @"Send feedback";
                    cell.textLabel.text = @"Rate us on App Store";
                }
                //				else if(indexPath.row == 2) {
                //					cell.textLabel.text = @"Rate us on App Store";
                //                }
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				break;
                
			case 3:
				if(indexPath.row == 0)
					cell.textLabel.text = @"Privacy Policy";
				else if(indexPath.row == 1)
					cell.textLabel.text = @"Terms of Service";
				else if(indexPath.row == 2)
					cell.textLabel.text = @"FAQs";
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				break;
                
			case 4:
				cell.textLabel.text = @"Logout";
				cell.accessoryType = UITableViewCellAccessoryNone;
				break;
                
			default:
				break;
		}
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	switch (indexPath.section) {
		case 1:
			break;
		case 2: {
			if(indexPath.row == 0) {
                //				AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
                //				TourView* controller = [[TourView alloc] init];
                //				[appDelegate.navigationController pushViewController:controller animated:YES];
                [self sendFeedback];
			}
			else if(indexPath.row == 1) {
                //				[self sendFeedback];
                [self rateusOnAppstore];
			}
            //			else if(indexPath.row == 2) {
            //				[self rateusOnAppstore];
            //			}
		}
			break;
		case 3: {
			AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
			if(indexPath.row == 0) {
				PrivacyPolicyView* controller = [[PrivacyPolicyView alloc] init];
				[appDelegate.navigationController pushViewController:controller animated:YES];
			}
			else if(indexPath.row == 1) {
				TermsOfServiceView* controller = [[TermsOfServiceView alloc] init];
				[appDelegate.navigationController pushViewController:controller animated:YES];
			}
			else if(indexPath.row == 2) {
				FAQView* controller = [[FAQView alloc] init];
				[appDelegate.navigationController pushViewController:controller animated:YES];
			}
		}
			break;
			
		case 4:
			[self logOut];
		default:
			break;
	}
}

- (void)onSwitchShareUnlock:(id)sender {
	UISwitch* control = (UISwitch*)sender;
	GameUtility* utils = [GameUtility sharedObject];
	utils.bShareUnlock = control.on;
}

- (void)onSwitchPushNotification:(id)sender {
	UISwitch* control = (UISwitch*)sender;
	GameUtility* utils = [GameUtility sharedObject];
	utils.bPushNotification = control.on;
}


- (void)logOut {
	GameUtility* utils = [GameUtility sharedObject];
	utils.userProfile = nil;
    
    // log out facebook session
    [FBSession.activeSession closeAndClearTokenInformation];
    
    // clear NSUserDefaults
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    // clear twitter engine
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate._engine = nil;
    
	[appDelegate.navigationController popToRootViewControllerAnimated:YES];
}

- (void)sendFeedback {
	MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setSubject:@"Send Feedback"];
	
	NSArray *usersTo = [NSArray arrayWithObject:@"hello@orin.io"];
	[controller setToRecipients:usersTo];
    
    NSString* strMsg = [NSString stringWithFormat:@""];
	[controller setMessageBody:strMsg isHTML:NO];
    
	if (controller) {
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.navigationController presentViewController: controller animated: YES completion:^{
		}];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
	if (result == MFMailComposeResultSent) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Feedback has been sent successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		alert.tag = 1000;
	}
    
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)rateusOnAppstore {
	[Appirater showPrompt];
}



@end
