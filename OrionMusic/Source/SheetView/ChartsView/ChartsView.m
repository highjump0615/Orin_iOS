//
//  ChartsView.m
//  OrionMusic
//
//  Created by TianHang on 10/18/13.
//
//

#import "ChartsView.h"
#import "GameUtility.h"
#import "CommentView.h"
#import "SheetView.h"

@implementation SongData

@synthesize nIndex;
@synthesize title, pubDate, url, artist;
@synthesize likeCount, commentCount;
@synthesize strImage;
@synthesize strSong;

+ (id)songData {
	return [[SongData alloc] init];
}

@end


#pragma mark-ChartsItemView
@implementation ChartsItemView

@synthesize m_nComments;

+ (id)chartsItemView:(SongData*)data {
	ChartsItemView* itemView = [[ChartsItemView alloc] initWithSongData:data];
	return itemView;
}

- (void)setIsLiked:(BOOL)isLiked {
	m_bLiked = isLiked;
	
	if(isLiked) {
		[m_btnLike setImage:[UIImage imageNamed:@"chart_liked.png"] forState:UIControlStateNormal];
	}
	else {
		[m_btnLike setImage:[UIImage imageNamed:@"chart_like.png"] forState:UIControlStateNormal];
	}
}

- (void)setLikedUsers : (NSArray *)aryUser {
	for (int i = 0; i < aryUser.count; i++) {
		NSString *str = [NSString stringWithString:(NSString *)aryUser[i]];
		[m_likeUsers addObject:str];
	}
	
	[self showLikedUsers];
}

- (void)showLikedUsers {
	NSString *strShow = @"";
	int i;

	for (i = 0; i < m_likeUsers.count; i++) {
		if (i > 0) {
			strShow = [strShow stringByAppendingString:@", "];
		}
		
		GameUtility* utils = [GameUtility sharedObject];

		if ([(NSString *)m_likeUsers[i] isEqualToString:utils.userProfile.userName]) {
			strShow = [strShow stringByAppendingString:@"I"];
		}
		else {
			strShow = [strShow stringByAppendingString:m_likeUsers[i]];
		}
		
		if (i >= 4)
			break;
	}
	
	if (i > 0) {
        int nMore = m_likeUsers.count - i - 1;
		if (nMore > 0) {
			strShow = [strShow stringByAppendingString:[NSString stringWithFormat:@" and %d other", nMore]];
		}
		
		strShow = [strShow stringByAppendingString:@" liked it"];
	}
	
	[m_labLikeUser setText:strShow];
	[m_labLikeCount setText:[NSString stringWithFormat:@"%d", m_likeUsers.count]];
}

- (void)showCommentNum {
	[m_labCommentCount setText:[NSString stringWithFormat:@"%d", m_nComments]];
}

- (id)initWithSongData:(SongData*)data {
	self = [super initWithFrame:CGRectMake(0, 0, 320, 186)];
    
	if(self) {
		
		m_likeUsers = [[NSMutableArray alloc] init];
		m_bLiked = false;
        
        // song imge
        NSString* strUrl = [NSString stringWithFormat:@"%@/song/image/%@", SERVER_PATH, data.strImage];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.frame];
        [GameUtility setImageFromUrl:strUrl target:imageView defaultImg:@""];

//        UIImage* convertImage = [GameUtility imageWithImage:image scaledToWidth:self.frame.size.width height:self.frame.size.height];
//		UIImageView* imageView = [[UIImageView alloc] initWithImage:convertImage];
//        [imageView setFrame:self.frame];
		[self addSubview:imageView];
		
        // image overlay
		UIImageView* back = [[UIImageView alloc] initWithFrame:self.frame];
		[back setImage:[UIImage imageNamed:@"chart_image_overlay.png"]];
		[self addSubview:back];
        
        // play button
        m_btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
		m_btnPlay.frame = CGRectMake(10, 10, 29, 29);
		m_btnPlay.tag = data.nIndex;
        
        if ([s_playingFile isEqualToString:data.strSong]) {
            [m_btnPlay setImage:[UIImage imageNamed:@"chart_pause.png"] forState:UIControlStateNormal];
            m_audioStreamer = s_audioStreamer;
        }
        else {
            [m_btnPlay setImage:[UIImage imageNamed:@"chart_play.png"] forState:UIControlStateNormal];
        }
		[m_btnPlay addTarget:self action:@selector(onBtnPlay:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_btnPlay];
		[m_btnPlay setTitle:data.strSong forState:UIControlStateNormal];

        // artist label
        UILabel *labArtist = [[UILabel alloc] initWithFrame:CGRectMake(10, 82, 265, 23)];
        labArtist.textColor = [UIColor whiteColor];
		labArtist.backgroundColor = [UIColor clearColor];
		labArtist.font = [UIFont boldSystemFontOfSize:16];
		[self addSubview:labArtist];
		labArtist.text = data.artist;
        
        // title label
        m_labTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, 265, 23)];
        m_labTitle.textColor = [UIColor whiteColor];
		m_labTitle.backgroundColor = [UIColor clearColor];
		m_labTitle.font = [UIFont boldSystemFontOfSize:16];
		[self addSubview:m_labTitle];
		m_labTitle.text = data.title;

//        // title label
//        m_labTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 82, 187, 53)];
//        m_labTitle.textColor = [UIColor whiteColor];
//		m_labTitle.backgroundColor = [UIColor clearColor];
//		m_labTitle.font = [UIFont boldSystemFontOfSize:16];
//        m_labTitle.numberOfLines = 2;
//		[self addSubview:m_labTitle];
//		m_labTitle.text = data.title;
        
        // clock image
        UIImageView* imgclock = [[UIImageView alloc] initWithFrame:CGRectMake(10, 160, 12, 12)];
		[imgclock setImage:[UIImage imageNamed:@"chart_clock.png"]];
		[self addSubview:imgclock];

        // date label
		m_labDate = [[UILabel alloc] initWithFrame:CGRectMake(27, 159, 109, 15)];
		m_labDate.backgroundColor = [UIColor clearColor];
		m_labDate.font = [UIFont systemFontOfSize:12];
		m_labDate.textColor = [UIColor whiteColor];
		[self addSubview:m_labDate];
		
		NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"yyyy-MM-dd"];
		NSString* strDate = [data.pubDate substringToIndex:10];
		NSDate* date = [dateFormat dateFromString:strDate];
		NSLog(@"%@", [dateFormat stringFromDate:date]);
		NSTimeInterval time = [date timeIntervalSinceNow];
		m_labDate.text = [NSString stringWithFormat:@"%d Days ago", (int)time / -24 / 3600];

        // like button
		m_btnLike = [UIButton buttonWithType:UIButtonTypeCustom];
		m_btnLike.frame = CGRectMake(202, 161, 14, 12);
		[m_btnLike addTarget:[self superview] action:@selector(onBtnLike:) forControlEvents:UIControlEventTouchUpInside];
		[m_btnLike setTitle:[NSString stringWithFormat:@"%d", data.nIndex] forState:UIControlStateNormal];
		[self addSubview:m_btnLike];

		// like count label
		m_labLikeCount = [[UILabel alloc] initWithFrame:CGRectMake(221, 159, 23, 15)];
		m_labLikeCount.backgroundColor = [UIColor clearColor];
		m_labLikeCount.font = [UIFont systemFontOfSize:12];
        m_labLikeCount.textColor = [UIColor whiteColor];
		[self addSubview:m_labLikeCount];
		[m_labLikeCount setText:[NSString stringWithFormat:@"%d", data.likeCount]];
		
        // comment button
		m_btnComment = [UIButton buttonWithType:UIButtonTypeCustom];
		m_btnComment.frame = CGRectMake(245, 161, 13, 12);
		[m_btnComment setImage:[UIImage imageNamed:@"chart_comment.png"] forState:UIControlStateNormal];
		[m_btnComment addTarget:[self superview] action:@selector(onBtnComment:) forControlEvents:UIControlEventTouchUpInside];
		[m_btnComment setTitle:[NSString stringWithFormat:@"%d", data.nIndex] forState:UIControlStateNormal];
		[self addSubview:m_btnComment];
		
        // comment label
		m_labCommentCount = [[UILabel alloc] initWithFrame:CGRectMake(263, 159, 29, 15)];
		m_labCommentCount.backgroundColor = [UIColor clearColor];
        m_labCommentCount.textColor = [UIColor whiteColor];
		m_labCommentCount.font = [UIFont systemFontOfSize:12];
		[self addSubview:m_labCommentCount];
		[m_labCommentCount setText:[NSString stringWithFormat:@"%d", data.commentCount]];
		
		m_nComments = data.commentCount;
        
        // share button
		UIButton* shareBut = [UIButton buttonWithType:UIButtonTypeCustom];
		shareBut.frame = CGRectMake(289, 159, 14, 14);
        [shareBut setImage:[UIImage imageNamed:@"chart_share.png"] forState:UIControlStateNormal];
		[shareBut addTarget:[self superview] action:@selector(onBtnShare:) forControlEvents:UIControlEventTouchUpInside];
		[shareBut setTitle:[NSString stringWithFormat:@"%@$$$%@$$$%@", data.strImage, data.title, data.artist] forState:UIControlStateNormal];
		[self addSubview:shareBut];
	}
	return self;
}

- (void)onBtnItunes:(id)sender {
	NSString* strURL = [(UIButton*)sender titleLabel].text;
	NSURL* url = [NSURL URLWithString:strURL];
	[[UIApplication sharedApplication] openURL:url];
}

- (void)onBtnLike:(id)sender {
	NSString* songID = ((UIButton*)sender).titleLabel.text;
	GameUtility* utils = [GameUtility sharedObject];
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 utils.userProfile.userName, @"username",
						 songID, @"musicid",
						 nil];
	if (m_bLiked) {
		[utils runWebService:@"unlike_music" Param:dic Delegate:self View:nil];
		for (int i = 0; i < m_likeUsers.count; i++) {
			if ([(NSString *)m_likeUsers[i] isEqualToString:utils.userProfile.userName]) {
				[m_likeUsers removeObjectAtIndex:i];
				break;
			}
		}
	}
	else {
		[utils runWebService:@"like_music" Param:dic Delegate:self View:nil];
		[m_likeUsers addObject:utils.userProfile.userName];
	}
	
	m_bLiked = !m_bLiked;
	[self setIsLiked:m_bLiked];
	[self showLikedUsers];
}

- (void)onBtnComment:(id)sender {
	NSString* songID = ((UIButton*)sender).titleLabel.text;
	CommentView* controller = [[CommentView alloc] init];
	controller.m_nMusicID = [songID integerValue];
	controller.m_chartItem = self;
	
	[[SheetView sharedObject] presentModalViewController:controller animated:YES];
}

- (void)onBtnShare:(id)sender {
    NSString *strData = ((UIButton*)sender).titleLabel.text;
    
    NSArray* arrayStr = [strData componentsSeparatedByString: @"$$$"];
    NSString* strImage = [arrayStr objectAtIndex: 0];
    NSString* strTitle = [arrayStr objectAtIndex: 1];
    NSString* strArtist = [arrayStr objectAtIndex: 2];
    
    NSString *msgText = [NSString stringWithFormat:@"I just discovered %@ by %@ with Orin\r\n%@", strTitle, strArtist, @"http://bit.ly/1dgDA5g"];
    
    //Create an activity view controller with the activity provider item. UIActivityItemProvider (AsyncImageActivityItemProvider's superclass) conforms to the UIActivityItemSource protocol
    NSString* strUrl = [NSString stringWithFormat:@"%@/song/image/%@", SERVER_PATH, strImage];
    UIImage *imageToShare = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]]];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[msgText, imageToShare] applicationActivities:nil];
	activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList,
													 UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypeMail];
	activityViewController.completionHandler = ^(NSString *activityType, BOOL completed){
	};
    
    [[SheetView sharedObject] presentViewController:activityViewController animated:YES completion:nil];

}

- (void)finishedRunningServiceDelegate:(NSDictionary *)outData {
//	static NSInteger nItemCount = 0;
//	GameUtility* utils = [GameUtility sharedObject];
//	NSLog(@"receivedJson: %@", outData);
//	NSString* serviceName = outData[@"serviceName"];
	
	NSString* serviceName = outData[@"serviceName"];
	if([serviceName isEqualToString:@"like_music"]) {
		NSString* result = outData[@"status"];
		if([result isEqualToString:@"OK"]) {
			
			UserProfile* profile = [[GameUtility sharedObject] userProfile];
			int nValue = [outData[@"info"] integerValue];
			if(nValue == 0)
				profile.otherLikeCount++;
			else if(nValue == 1)
				profile.hiphopCount++;
			else if(nValue == 2)
				profile.rnbCount++;
			else if(nValue == 3)
				profile.afrobeatCount++;
		}
	}
	else if([serviceName isEqualToString:@"unlike_music"]) {
		NSString* result = outData[@"status"];
		if([result isEqualToString:@"OK"]) {
			UserProfile* profile = [[GameUtility sharedObject] userProfile];
			int nValue = [outData[@"info"] integerValue];
			if(nValue == 0)
				profile.otherLikeCount--;
			else if(nValue == 1)
				profile.hiphopCount--;
			else if(nValue == 2)
				profile.rnbCount--;
			else if(nValue == 3)
				profile.afrobeatCount--;
		}
	}
	
}



static BOOL s_bPlaying = false;
static AVPlayer* s_audioStreamer = nil;
static NSString *s_playingFile = @"";
static UIButton* s_button = nil;

+ (void)pauseMusic {
    if (s_bPlaying) {
        [s_audioStreamer pause];
        [s_button setImage:[UIImage imageNamed:@"chart_play.png"] forState:UIControlStateNormal];
        
        s_bPlaying = false;
        s_audioStreamer = nil;
        s_button = nil;
        s_playingFile = @"";
    }
}

- (void)onBtnPlay:(id)sender {
    
    NSString* fileName = ((UIButton*)sender).titleLabel.text;
	
	if (s_bPlaying == false) {
        
		if (m_audioStreamer == nil) {
			NSString* strUrl = [NSString stringWithFormat:@"%@/song/%@", SERVER_PATH, [GameUtility urlencode:fileName]];
			NSURL* url = [NSURL URLWithString:strUrl];
			
			AVPlayerItem* aPlayerItem = [[AVPlayerItem alloc] initWithURL:url];
			// Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:aPlayerItem];
			
			m_audioStreamer = [AVPlayer playerWithPlayerItem:aPlayerItem];
		}

		[m_audioStreamer play];
		[m_btnPlay setImage:[UIImage imageNamed:@"chart_pause.png"] forState:UIControlStateNormal];
        
		s_bPlaying = true;
		s_audioStreamer = m_audioStreamer;
        s_button = m_btnPlay;
        s_playingFile = fileName;
	}
	else {
		if ([s_playingFile isEqualToString:fileName]) {
			[m_audioStreamer pause];
			[m_btnPlay setImage:[UIImage imageNamed:@"chart_play.png"] forState:UIControlStateNormal];
				
			s_bPlaying = false;
            s_audioStreamer = nil;
            s_button = nil;
            s_playingFile = @"";
		}
	}
}

- (void)itemDidFinishPlaying {
	[m_btnPlay setImage:[UIImage imageNamed:@"chart_play.png"] forState:UIControlStateNormal];
	s_bPlaying = false;
}

@end

@implementation ChartsView

@synthesize m_scrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)loadMusic: (BOOL)bShowWaiting {
	GameUtility* utils = [GameUtility sharedObject];
    
    int nGetNum = GETMUSICNUM;
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait) {
        nGetNum *= 4;
    }
    
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 utils.userProfile.userName, @"username",
                         [NSString stringWithFormat:@"%d", m_nCurCount], @"currentnum",
                         [NSString stringWithFormat:@"%d", nGetNum], @"getcount",
						 nil];
	
	if (bShowWaiting)
		[utils runWebService:@"getmusic" Param:dic Delegate:self View:[self superview]];
	else
		[utils runWebService:@"getmusic" Param:dic Delegate:self View:nil];
}

- (void)createItemView:(UIViewController*)parent {
	m_parent = parent;
	CGRect rt = self.frame;
	rt.origin = CGPointZero;
	m_scrollView = [[UIScrollView alloc] initWithFrame:rt];
	[self addSubview:m_scrollView];
	
	m_nCurCount = 0;
	
	[self loadMusic:YES];
}

- (void)finishedRunningServiceDelegate:(NSDictionary *)outData {

//	GameUtility* utils = [GameUtility sharedObject];
	NSLog(@"receivedJson: %@", outData);
	NSString* serviceName = outData[@"serviceName"];
	
	if(serviceName == nil) {
		return;
	}
	
	if ([serviceName isEqualToString:@"getmusic"]) {
		NSArray* items = outData[@"info"];

//        NSInteger nCount = -1;
//        
//        m_nCurCount += (nCount + 1);
		
		for(id item in items) {
			
			SongData* data = [SongData songData];
			data.url = item[@"itunelink"];
			data.title = item[@"name"];
            data.artist = item[@"artist"];
			data.pubDate = item[@"time"];
			data.likeCount = [item[@"likes"] integerValue];
			data.commentCount = [item[@"comments"] integerValue];
			data.strImage = item[@"imagefile"];
			data.nIndex = [item[@"id"] integerValue];
			data.strSong = item[@"songfile"];

			ChartsItemView* itemView = [ChartsItemView chartsItemView:data];
			[itemView setIsLiked:[item[@"liked"] boolValue]];
			itemView.tag = 1000 + m_nCurCount;
            
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
                itemView.frame = CGRectMake(0, 186 * (m_nCurCount), 320, 186);
            }
            else {
                itemView.frame = CGRectMake(25 + 330 * (m_nCurCount % 3), 25 + 196 * (m_nCurCount / 3), 330, 186);
            }
            
			[m_scrollView addSubview:itemView];
			
			[itemView setLikedUsers : (NSArray *)item[@"likedusers"]];
            
            m_nCurCount++;
		}
        
//        m_nCurCount += (nCount + 1);
		
		CGSize sz = m_scrollView.frame.size;
        
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
            sz.height = 186 * m_nCurCount;
        }
        else {
//            if (m_nCurCount == GETMUSICNUM)
//                m_nCurCount += GETMUSICNUM;
            sz.height = 25 + 196 * m_nCurCount / 3;
        }
		
		[m_scrollView setContentSize:sz];

		
		[m_parent performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
	}
}



@end
