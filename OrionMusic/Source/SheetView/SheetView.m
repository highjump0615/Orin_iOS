//
//  SheetView.m
//  OrionMusic
//
//  Created by TianHang on 10/5/13.
//
//

#import "SheetView.h"
#import "VideoViewController.h"
#import "BaseView.h"

#import "ProfileViewController.h"
#import "VideoViewController.h"
#import "VideoSearchViewController.h"
#import "PlayListViewController.h"


@interface SheetView ()
- (IBAction)onShowSheet:(id)sender;
@end

@implementation SheetView

@synthesize type = m_nType;
@synthesize m_subViewControllers;

+ (id)sharedObject {
	static SheetView* obj = nil;
	if(obj == nil ) {
		obj = [[SheetView alloc] initWithNibName:@"SheetView" bundle:nil];
        obj.m_subViewControllers = [[NSMutableArray alloc] init];
	}
	return obj;
}

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
	//	[m_viewVideo createItemView:self];
	m_nType = kSheetViewTypeNone;
	self.type = kSheetViewTypeCharts;
    //	[self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setType:(NSInteger)type {
	if(m_nType == type)
		return;
	m_nType = type;
	NSString* strClass;
	switch (type) {
		case kSheetViewTypeProfile:
			m_title.text = @"My Profile";
			strClass = @"ProfileViewController";
			break;
		case kSheetViewTypeCharts:
			m_title.text = @"Top Charts";
			strClass = @"ChartsViewViewController";
			break;
		case kSheetViewTypeVideo:
			m_title.text = @"Music Videos";
			strClass = @"VideoViewController";
			break;
        case kSheetViewTypeVideoArtist:
			m_title.text = @"Hot Artists";
			strClass = @"VideoArtistViewController";
			break;
        case kSheetViewTypeVideoSearch:
			m_title.text = @"Search";
			strClass = @"VideoSearchViewController";
			break;
        case kSheetViewTypePlaylist:
            m_title.text = @"Playlist";
			strClass = @"PlayListViewController";
            break;
		case kSheetViewTypeBadges:
			m_title.text = @"Badges";
			strClass = @"BadgesView";
			break;
		case kSheetViewTypeFindFriends:
			m_title.text = @"Find Friends";
			strClass = @"FindFriendsView";
			break;
		case kSheetViewTypeSettings:
			m_title.text = @"Settings";
			strClass = @"SettingsView";
			break;
		default:
			break;
	}
	UIView* child = [m_view viewWithTag:10000];
	if(child) {
		[child removeFromSuperview];
	}
	Class controller = NSClassFromString(strClass);
	UIViewController* viewController = [[controller alloc] init];
    if (type == kSheetViewTypeProfile) {
        [self.m_headerView setHidden:YES];
        [m_view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        ProfileViewController *profileController = (ProfileViewController *)viewController;
        profileController.parentController = self;
    }
    else {
        [self.m_headerView setHidden:NO];
        [m_view setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
        
        switch (type) {
            case kSheetViewTypeVideo: {
                VideoViewController *videoController = (VideoViewController *)viewController;
                videoController.parentController = self;
                
                break;
            }
            case kSheetViewTypeVideoSearch: {
                VideoSearchViewController *searchController = (VideoSearchViewController *)viewController;
                searchController.parentController = self;
                
                break;
            }
            case kSheetViewTypePlaylist: {
                PlayListViewController *playlistController = (PlayListViewController *)viewController;
                playlistController.parentController = self;
                
                break;
            }
        }
    }
    
//	[self.navigationController pushViewController:viewController animated:NO];
    [m_subViewControllers addObject:viewController];
    
    NSLog(@"sheet view: %f, %f, %f, %f", m_view.frame.origin.x, m_view.frame.origin.y, m_view.frame.size.width, m_view.frame.size.height);

	viewController.view.tag = 10000;
//	[viewController.view removeFromSuperview];
	[m_view addSubview:viewController.view];
}

- (IBAction)onShowSheet:(id)sender {
    [m_view endEditing:YES];
	[self showSheetView:self.type];
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

- (void)showSheetView:(NSInteger)type {
	self.type = type;
	CGSize szScreen = [self getScreenSize];
	CGRect rect = self.view.frame;
	CGFloat xPos = [self getTableOffset];
	if(rect.origin.x == szScreen.width - xPos)
		[self showTable:YES Animation:YES];
	else
		[self showTable:NO Animation:YES];
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

#pragma mark LBYouTubePlayerViewControllerDelegate

-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL {
    NSLog(@"Did extract video source:%@", videoURL);
}

-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller failedExtractingYouTubeURLWithError:(NSError *)error {
    NSLog(@"Failed loading video due to error:%@", error);
}

-(void)youTubeExtractor:(LBYouTubeExtractor *)extractor didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL{
    NSLog(@"Did extract video source:%@", videoURL);
}
-(void)youTubeExtractor:(LBYouTubeExtractor *)extractor failedExtractingYouTubeURLWithError:(NSError *)error{
    NSLog(@"Failed loading video due to error:%@", error);
}


@end
