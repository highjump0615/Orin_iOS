//
//  FindFriendsView.m
//  OrionMusic
//
//  Created by TianHang on 10/11/13.
//
//

#import "FindFriendsView.h"
#import "InviteFriendView.h"
#import "AppDelegate.h"
#import "SearchUserView.h"

@implementation FindFriends

- (void)awakeFromNib {
	CGRect rt = self.frame;
	rt.origin = CGPointZero;
	UITableView* tableView = [[UITableView alloc] initWithFrame:rt style:UITableViewStyleGrouped];
	tableView.delegate = self;
	tableView.dataSource = self;
	[self addSubview:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 1;
		case 1:
			return 2;
		case 2:
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
			case 0:
				cell.textLabel.text = @"Invite friends";
				break;
			case 1:
				if(indexPath.row == 0)
					cell.textLabel.text = @"Facebook friends";
				else if(indexPath.row == 1)
					cell.textLabel.text = @"Twitter friends";
				break;
			case 2:
				cell.textLabel.text = @"Search names & usernames";
				break;
			default:
				break;
		}
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	switch (indexPath.section) {
		case 0:
			[self inviteFirends];
			break;
		case 1:
            if(indexPath.row == 0)
                [self searchUsers:1];
            else if(indexPath.row == 1)
                [self searchUsers:2];
            break;

			break;
		case 2:
			[self searchUsers:0];
		default:
			break;
	}
}

- (void)inviteFirends {
	AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	InviteFriendView* controller = [[InviteFriendView alloc] init];
	[appDelegate.navigationController pushViewController:controller animated:YES];
}

- (void)searchUsers:(int)nType {
	AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	SearchUserView* controller = [[SearchUserView alloc] initWithType:nType];
	[appDelegate.navigationController pushViewController:controller animated:YES];
}

@end



@interface FindFriendsView ()

@end

@implementation FindFriendsView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"FindFriendsView" bundle:nibBundleOrNil];
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

@end
