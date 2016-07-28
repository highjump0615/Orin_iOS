//
//  OtherProfileView.m
//  OrionMusic
//
//  Created by TianHang on 10/11/13.
//
//

#import "OtherProfileView.h"

@interface OtherProfileView ()
- (IBAction)onBack:(id)sender;
@end

@implementation OtherProfileView

@synthesize otherProfile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"OtherProfileView" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	GameUtility* utils = [GameUtility sharedObject];
	
	CALayer* layer = m_imgPhoto.layer;
	[layer setMasksToBounds:YES];
	[layer setCornerRadius:40.0];
	
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 utils.userProfile.userName, @"name",
						 self.otherProfile.userName, @"following",
						 nil];
	[utils runWebService:@"isfollowing" Param:dic Delegate:self View:self.view];
	
	
	NSArray* badgesearn = [utils getBadges:self.otherProfile];
    NSArray* badges = [utils getTotalBadges];
    
	m_labBadges.text = [NSString stringWithFormat:@"%d", badges.count];
	
	int nIndex = 0;
	for(NSString* strImage in badges) {
		UIImage* image = [UIImage imageNamed:strImage];
		UIView *badgeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:badgeView.frame];
        
        imageView.image = image;
        [badgeView addSubview:imageView];
        
        if ([badgesearn containsObject:strImage]) {
            UIImageView* imgearnView = [[UIImageView alloc] initWithFrame:badgeView.frame];
            UIImage* imageearn = [UIImage imageNamed:@"Badge_earned"];
            imgearnView.image = imageearn;
            [badgeView addSubview:imgearnView];
        }
        
        int nRow = nIndex / 3;
        int nCol = nIndex % 3;
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            nRow = nIndex / 9;
            nCol = nIndex % 9;
            badgeView.center = CGPointMake(110 + nCol * 100, 75 + nRow * 125);
        }
        else {
            badgeView.center = CGPointMake(60 + nCol * 100, 55 + nRow * 125);
        }

		[m_scrollBadges addSubview:badgeView];
		
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
		label.center = CGPointMake(badgeView.center.x, badgeView.center.y + 52);
		label.textAlignment = NSTextAlignmentCenter;
		label.textColor = [UIColor blackColor];
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont systemFontOfSize:14];
		label.text = [strImage substringFromIndex:6];
		[m_scrollBadges addSubview:label];
		
		nIndex++;
	}
}

- (void)refreshView {
	UserProfile* profile = self.otherProfile;
	m_labFullName.text = profile.fullName;
	m_labAboutme.text = profile.aboutme;
	m_labWebsite.text = profile.website;
    
    NSString* fileURLString = [NSString stringWithFormat:@"%@/userimage/%@.jpg", SERVER_PATH, profile.userName];
    [GameUtility setImageFromUrl:fileURLString target:m_imgPhoto defaultImg:@"Unknown_character.png"];
	
	m_labFollowers.text = [NSString stringWithFormat:@"%d", profile.followers];
	m_labFollowing.text = [NSString stringWithFormat:@"%d", profile.following];
	
	if(profile.isFollowed) {
		[m_btnEditProfile setTitle:@"UnFollow" forState:UIControlStateNormal];
		[m_btnEditProfile setTitle:@"UnFollow" forState:UIControlStateHighlighted];
	}
	else {
		[m_btnEditProfile setTitle:@"Follow" forState:UIControlStateNormal];
		[m_btnEditProfile setTitle:@"Follow" forState:UIControlStateHighlighted];
	}
}

- (void)viewDidAppear:(BOOL)animated {
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onFollow:(id)sender {
	GameUtility* utils = [GameUtility sharedObject];
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 utils.userProfile.userName, @"name",
						 self.otherProfile.userName, @"following",
						 nil];
	if(self.otherProfile.isFollowed) {
		[utils runWebService:@"unfollow" Param:dic Delegate:self View:self.view];
	}
	else {
		[utils runWebService:@"follow" Param:dic Delegate:self View:self.view];
	}
}

- (void)finishedRunningServiceDelegate:(NSDictionary *)outData {
	NSString* serviceName = outData[@"serviceName"];
	if([serviceName isEqualToString:@"isfollowing"]) {
		NSString* result = outData[@"status"];
		if([result isEqualToString:@"OK"]) {
			NSInteger followValue = [outData[@"info"] integerValue];
			self.otherProfile.isFollowed = followValue;
			[self refreshView];
		}
	}
	else if([serviceName isEqualToString:@"unfollow"]) {
		NSString* result = outData[@"status"];
		if([result isEqualToString:@"OK"]) {
			self.otherProfile.followers--;
			self.otherProfile.isFollowed = NO;
			[self refreshView];
		}
	}
	else if([serviceName isEqualToString:@"follow"]) {
		NSString* result = outData[@"status"];
		if([result isEqualToString:@"OK"]) {
			self.otherProfile.followers++;
			self.otherProfile.isFollowed = YES;
			[self refreshView];
		}
	}
}

@end
