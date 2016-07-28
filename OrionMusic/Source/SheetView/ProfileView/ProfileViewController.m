//
//  ProfileViewController.m
//  OrionMusic
//
//  Created by TianHang on 10/11/13.
//
//

#import "ProfileViewController.h"
#import "EditProfileView.h"
#import "AppDelegate.h"
#import "GameUtility.h"
#import "SheetView.h"

@implementation ProfileView

@synthesize parentController;

- (void)onEditProfileView:(id)sender {
	AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	EditProfileView* controller = [[EditProfileView alloc] init];
	[appDelegate.navigationController pushViewController:controller animated:YES];
	controller.delegate = self;
}

- (void)editProfileDoneDelegate:(EditProfileView *)controller {
	[(ProfileViewController*)self.parentController refreshView];
}

@end

@interface ProfileViewController ()
- (IBAction)onBack:(id)sender;
@end

@implementation ProfileViewController

@synthesize parentController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"ProfileViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"profile view: %f, %f, %f, %f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [GameUtility setPhoneFrame:self.view withHeader:NO];
    
	[m_btnEditProfile addTarget:self.view action:@selector(onEditProfileView:) forControlEvents:UIControlEventTouchUpInside];
	((ProfileView*)self.view).parentController = self;
	
	CALayer* layer = m_imgPhoto.layer;
	[layer setMasksToBounds:YES];
	[layer setCornerRadius:35];
	
	[self refreshView];
	
	
	GameUtility* utils = [GameUtility sharedObject];
	NSArray* badgesearn = [utils getBadges:utils.userProfile];
    NSArray* badges = [utils getTotalBadges];
	
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
		
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
		label.center = CGPointMake(badgeView.center.x, badgeView.center.y + 52);
		label.textAlignment = NSTextAlignmentCenter;
		label.textColor = [UIColor blackColor];
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont systemFontOfSize:14];
		label.text = [strImage substringFromIndex:6];
		[m_scrollBadges addSubview:label];
		
		nIndex++;
	}
	
	m_labBadges.text = [NSString stringWithFormat:@"%d", nIndex];
	
	CGSize sz = [m_scrollBadges contentSize];

	if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        sz.height = nIndex / 9 * 125 + 45;
    }
    else {
        sz.height = nIndex / 3 * 125 + 25;
    }

	[m_scrollBadges setContentSize:sz];
}

- (void)refreshView {
	UserProfile* profile = [[GameUtility sharedObject] userProfile];
	m_labFullName.text = profile.fullName;
	m_labAboutme.text = profile.aboutme;
//	m_labWebsite.text = profile.website;
	
	m_labFollowers.text = [NSString stringWithFormat:@"%d", profile.followers];
	m_labFollowing.text = [NSString stringWithFormat:@"%d", profile.following];
    
    NSString* fileURLString = [NSString stringWithFormat:@"%@/userimage/%@.jpg", SERVER_PATH, profile.userName];
    [GameUtility setImageFromUrl:fileURLString target:m_imgPhoto defaultImg:@"Unknown_character.png"];
    
    fileURLString = [NSString stringWithFormat:@"%@/backimage/%@.jpg", SERVER_PATH, profile.userName];
    [GameUtility setImageFromUrl:fileURLString target:self.m_imgBack defaultImg:@"sheet_background.png"];
}

- (int)getTableOffset {
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        return 690;
    }
    else {
        return 60;
    }
}

- (CGSize)getScreenSize {
    CGRect rtBound = [[UIScreen mainScreen] bounds];
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
        rtBound = CGRectMake(0, 0, rtBound.size.width, rtBound.size.height);
    }
    else {
        rtBound = CGRectMake(0, 0, rtBound.size.height, rtBound.size.width);
    }
    
    return rtBound.size;
}

- (void)showTable:(BOOL)bShow Animation:(BOOL)bAnimation {
    
    CGSize szScreen = [self getScreenSize];
    
	CGFloat xPos = [self getTableOffset];
	CGRect rect = [self.view frame];
	if(bShow)
		rect.origin.x = szScreen.width - rect.size.width;
	else
		rect.origin.x = szScreen.width - xPos;
	
	if(bAnimation) {
		self.view.userInteractionEnabled = NO;
		[UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 self.view.frame = rect;
						 }
						 completion:^(BOOL finished){
							 self.view.userInteractionEnabled = YES;
						 }];
	}
	else {
		self.view.frame = rect;
	}
}


- (IBAction)onShowMenu:(id)sender {
//	CGSize szScreen = [self getScreenSize];
//	CGRect rect = self.view.frame;
//	CGFloat xPos = [self getTableOffset];
//	if(rect.origin.x == szScreen.width - xPos)
//		[self showTable:YES Animation:YES];
//	else
//		[self showTable:NO Animation:YES];
    
    
    SheetView *parentView = (SheetView *)self.parentController;
    [parentView onShowSheet:nil];

}

- (void)viewDidAppear:(BOOL)animated {
//	UIButton* btnProfile = [UIButton buttonWithType:UIButtonTypeCustom];
//	[btnProfile setTitle:@"Edit your Profile" forState:UIControlStateNormal];
//	btnProfile.frame = CGRectMake(0, 0, 200, 200);
//	[btnProfile addTarget:self action:@selector(onEditProfileView:) forControlEvents:UIControlEventTouchUpInside];
//	[self.view addSubview:btnProfile];
}

//- (void)awakeFromNib {
//	[super awakeFromNib];
//	[m_btnEditProfile addTarget:self action:@selector(onEditProfileView:) forControlEvents:UIControlEventTouchUpInside];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
	
}

@end
