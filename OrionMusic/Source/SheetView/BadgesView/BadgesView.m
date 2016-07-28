//
//  BadgesView.m
//  OrionMusic
//
//  Created by TianHang on 10/11/13.
//
//

#import "BadgesView.h"
#import "GameUtility.h"

@interface BadgesView ()

@end

@implementation BadgesView

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
    
    NSLog(@"badges view: %f, %f, %f, %f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [GameUtility setPhoneFrame:self.view withHeader:YES];
    
	GameUtility* utils = [GameUtility sharedObject];
	NSArray* badgesearn = [utils getBadges:utils.userProfile];
    NSArray* badges = [utils getTotalBadges];
	
	if (utils.bShareUnlock) {
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
			label.textColor = [UIColor whiteColor];
			label.backgroundColor = [UIColor clearColor];
			label.font = [UIFont systemFontOfSize:13];
			label.text = [strImage substringFromIndex:6];
			[m_scrollBadges addSubview:label];
			
			nIndex++;
		}
        
        CGSize sz = [m_scrollBadges contentSize];
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            sz.height = nIndex / 9 * 125 + 45;
        }
        else {
            sz.height = nIndex / 3 * 125 + 25;
        }
		
		[m_scrollBadges setContentSize:sz];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
