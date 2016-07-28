//
//  MenuView.m
//  OrionMusic
//
//  Created by TianHang on 10/5/13.
//
//

#import "MenuView.h"
#import "SheetView.h"
#import "GameUtility.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"

@interface MenuView ()

@end

@implementation MenuView

+ (id)sharedObject {
	static MenuView* obj = nil;
	if(obj == nil) {
		obj = [[MenuView alloc] initWithNibName:@"MenuView" bundle:nil];
		[SheetView sharedObject];
	}
	return obj;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	CALayer* layer = m_btnProfile.layer;
	[layer setMasksToBounds:YES];
	[layer setCornerRadius:m_btnProfile.frame.size.width / 2];
	m_btnProfile.clipsToBounds = YES;
    
    mSheetView = nil;
    if (self.m_scrollView) {
        [self.m_scrollView setContentSize:CGSizeMake(self.m_scrollView.frame.size.width, 548)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (!mSheetView) {
        SheetView* sheetView = [SheetView sharedObject];
        [self.view addSubview:sheetView.view];
        [sheetView showTable:YES Animation:NO];
    }

    GameUtility* utils = [GameUtility sharedObject];
    
//    if (utils.bUpdatedPhoto) {
    NSString* fileURLString = [NSString stringWithFormat:@"%@/userimage/%@.jpg", SERVER_PATH, utils.userProfile.userName];
    [GameUtility setImageFromUrl:fileURLString target:m_btnProfile defaultImg:@"Unknown_character.png"];
//        utils.bUpdatedPhoto = NO;
//    }
	m_labName.text = utils.userProfile.userName;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onMyProfile:(id)sender {
	[self showSheetView:kSheetViewTypeProfile];
//    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
//	ProfileViewController* controller = [[ProfileViewController alloc] init];
//	[appDelegate.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onCharts:(id)sender {
	[self showSheetView:kSheetViewTypeCharts];
}

- (IBAction)onMusicVideos:(id)sender {
	[self showSheetView:kSheetViewTypeVideo];
}

- (IBAction)onVideoArtist:(id)sender {
	[self showSheetView:kSheetViewTypeVideoArtist];
}

- (IBAction)onVideoSearch:(id)sender {
	[self showSheetView:kSheetViewTypeVideoSearch];
}

- (IBAction)onPlaylist:(id)sender {
	[self showSheetView:kSheetViewTypePlaylist];
}


- (IBAction)onBadges:(id)sender {
	[self showSheetView:kSheetViewTypeBadges];
}

- (IBAction)onFindFriends:(id)sender {
	[self showSheetView:kSheetViewTypeFindFriends];
}

- (IBAction)onSettings:(id)sender {
	[self showSheetView:kSheetViewTypeSettings];
}

- (void)showSheetView:(NSInteger)type {
	SheetView* sheetView = [SheetView sharedObject];
	[sheetView showSheetView:type];
}

@end
