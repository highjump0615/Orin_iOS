//
//  VideoArtistView.h
//  Orin
//
//  Created by TianHang on 3/5/14.
//  Copyright (c) 2014 234 Digital Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GETVIDEONUM 3

@interface VideoData : NSObject {
	NSInteger	nIndex;
	NSString*	title;
    NSString*	artist;
	NSString*	pubDate;
	NSString*	url;
	NSInteger	likeCount;
	NSInteger	commentCount;
	NSString*	strImage;
    NSInteger   category;
}

@property (nonatomic) NSInteger nIndex;
@property (strong) NSString* title;
@property (strong) NSString* artist;
@property (strong) NSString* pubDate;
@property (strong) NSString* url;
@property (nonatomic) NSInteger likeCount;
@property (nonatomic) NSInteger commentCount;
@property (strong) NSString* strImage;
@property (nonatomic) NSInteger category;

@end

@interface VideoItemView : UIView {

	UIButton*	m_btnPlay;
	UILabel*	m_labTitle;
	UILabel*	m_labDate;
	
	UIButton*	m_btnLike;
	UILabel*	m_labLikeCount;
	UIButton*	m_btnComment;
	UILabel*	m_labCommentCount;
	UIButton*	m_btnItune;
	
	BOOL m_bLiked;
	
	NSMutableArray *m_likeUsers;
	UILabel* m_labLikeUser;
	
	int m_nComments;
}

//@property (nonatomic) NSInteger itemIndex;
//@property (nonatomic) NSInteger likeCount;
//@property (nonatomic) NSInteger commentCount;
@property (nonatomic) int m_nComments;

+ (id)videoItemView:(VideoData*)data;

- (void)showCommentNum;

@end


@interface VideoArtistView : UIView {
    UIScrollView*		m_scrollView;
    UIViewController*	m_parent;

    int m_nCurCount;
}

@property (strong, nonatomic)  UIScrollView*		m_scrollView;

- (void)loadVideo:(BOOL)bShowWaiting;
- (void)createItemView:(UIViewController*)parent;

@end
