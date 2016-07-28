//
//  SearchUserView.m
//  OrionMusic
//
//  Created by TianHang on 10/21/13.
//
//

#import "SearchUserView.h"
#import "GameUtility.h"
#import "OtherProfileView.h"

@interface SearchUserView ()

@end

@implementation SearchUserView

- (id)initWithType:(int) nType {
    self = [super init];
    if (self) {
        m_nType = nType;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"SearchUserView" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[m_textKeyword becomeFirstResponder];
	m_tableView.hidden = YES;
    
    if (m_nType == 0)
        m_textKeyword.placeholder = @"Search for a user";
    else if (m_nType == 1)
        m_textKeyword.placeholder = @"Search for a facebook user";
    else if (m_nType == 2)
        m_textKeyword.placeholder = @"Search for a twitter user";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSearch:(id)sender {
	[self searchUser:m_textKeyword.text];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView.tag == 1000) {
//		[self.navigationController popViewControllerAnimated:YES];
	}
}

-(void)searchUser:(NSString*)keyword {
	if(keyword.length == 0) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Input keyword to search." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		return;
	}
	GameUtility* utils = [GameUtility sharedObject];
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 m_textKeyword.text, @"name",
                         [NSString stringWithFormat:@"%d", m_nType], @"usertype",
						 nil];
	[utils runWebService:@"searchuser" Param:dic Delegate:self View:self.view];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self searchUser:textField.text];
	[textField resignFirstResponder];
	return NO;
}

UserProfile* g_pProfile;

- (void)finishedRunningServiceDelegate:(NSDictionary *)outData {
	NSString* serviceName = outData[@"serviceName"];
	if([serviceName isEqualToString:@"searchuser"]) {
		NSString* result = outData[@"status"];
		if([result isEqualToString:@"OK"]) {
			m_arySearchData = [NSMutableArray arrayWithArray:outData[@"info"]];
			
			UserProfile* profile = [[GameUtility sharedObject] userProfile];
			
			int i = 0;
			for (NSString *strName in m_arySearchData) {
				if ([strName isEqualToString:[profile userName]]) {
					[m_arySearchData removeObjectAtIndex:i];
					break;
				}
				i++;
			}
			
			if(m_arySearchData.count == 0)
				m_tableView.hidden = YES;
			else
				m_tableView.hidden = NO;
			[m_tableView reloadData];
		}
	}
	else if([serviceName isEqualToString:@"getuserprofile"]) {
		NSString* result = outData[@"status"];
		if([result isEqualToString:@"OK"]) {
			NSDictionary* result = outData[@"info"];
			NSString* strName = m_arySearchData[nCurrentRow];
			
			GameUtility* utils = [GameUtility sharedObject];
			
			UserProfile* profile = [[UserProfile alloc] init];
			profile.userName = strName;
			profile.email = result[@"email"];
			profile.fullName = result[@"fullname"];
			profile.website = result[@"website"];
			profile.aboutme = result[@"aboutme"];
			profile.phone = result[@"phone"];
			profile.gender = [result[@"gender"] integerValue];
			
			profile.followers = [result[@"follower"] integerValue];
			profile.following = [result[@"following"] integerValue];
			
			profile.inviteCount = [result[@"invitecount"] integerValue];
			profile.downloadCount = [result[@"itunecount"] integerValue];
			profile.shareCount = [result[@"sharecount"] integerValue];
			
			NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
								 profile.userName, @"name",
								 nil];
			[utils runWebService:@"getmusiclikecount" Param:dic Delegate:self View:self.view];

			g_pProfile = profile;
		}
		else {
		}
	}
	else if ([serviceName isEqualToString:@"getmusiclikecount"]) {
		NSString* result = outData[@"status"];
		if([result isEqualToString:@"OK"]) {
			NSDictionary* resDic = outData[@"info"];
			
			UserProfile* profile = g_pProfile;
			
			profile.hiphopCount = [resDic[@"hiphop"] integerValue];
			profile.rnbCount = [resDic[@"rnb"] integerValue];
			profile.afrobeatCount = [resDic[@"afrobeat"] integerValue];
			profile.otherLikeCount = [outData[@"count"] integerValue] - profile.hiphopCount - profile.rnbCount - profile.afrobeatCount;
			
			OtherProfileView* controller = [[OtherProfileView alloc] initWithNibName:@"OtherProfileView" bundle:nil];
			controller.otherProfile = profile;
			[self.navigationController pushViewController:controller animated:YES];
		}

	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return m_arySearchData.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *kSourceCellID = @"FindFriends";
	UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSourceCellID];
	cell.textLabel.text = m_arySearchData[indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	nCurrentRow = indexPath.row;
	NSString* strName = m_arySearchData[indexPath.row];
	GameUtility* utils = [GameUtility sharedObject];
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 strName, @"name",
						 nil];
	[utils runWebService:@"getuserprofile" Param:dic Delegate:self View:self.view];
}

@end
