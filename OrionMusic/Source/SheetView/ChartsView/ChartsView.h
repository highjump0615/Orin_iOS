//
//  ChartsView.h
//  OrionMusic
//
//  Created by TianHang on 10/18/13.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AudioToolbox/AudioServices.h>
#import <MediaPlayer/MediaPlayer.h>

#define GETMUSICNUM 3


@interface SongData : NSObject {
	NSInteger	nIndex;
	NSString*	title;
    NSString*	artist;
	NSString*	pubDate;
	NSString*	url;
	NSInteger	likeCount;
	NSInteger	commentCount;
	NSString*	strImage;
	NSString*	strSong;
}

@property (nonatomic) NSInteger nIndex;
@property (strong) NSString* title;
@property (strong) NSString* artist;
@property (strong) NSString* pubDate;
@property (strong) NSString* url;
@property (nonatomic) NSInteger likeCount;
@property (nonatomic) NSInteger commentCount;
@property (strong) NSString* strImage;
@property (strong) NSString* strSong;

@end


@interface ChartsItemView : UIView <AVAudioPlayerDelegate/*, UIActionSheetDelegate*/> {

	UIButton*	m_btnPlay;
	UILabel*	m_labTitle;
	UILabel*	m_labDate;
	
	UIButton*	m_btnLike;
	UILabel*	m_labLikeCount;
	UIButton*	m_btnComment;
	UILabel*	m_labCommentCount;
	UIButton*	m_btnItune;
	
	AVPlayer* m_audioStreamer;
	
	BOOL m_bLiked;
	
	NSMutableArray *m_likeUsers;
	UILabel* m_labLikeUser;
	
	int m_nComments;
}

//@property (nonatomic) NSInteger itemIndex;
//@property (nonatomic) NSInteger likeCount;
//@property (nonatomic) NSInteger commentCount;
@property (nonatomic) int m_nComments;

+ (id)chartsItemView:(SongData*)data;
+ (void)pauseMusic;

- (void)showCommentNum;

@end



@interface ChartsView : UIView {

	UIScrollView*		m_scrollView;
	UIViewController*	m_parent;
	
	int m_nCurCount;
}

@property (strong, nonatomic)  UIScrollView*		m_scrollView;

- (void)loadMusic:(BOOL)bShowWaiting;
- (void)createItemView:(UIViewController*)parent;

@end
