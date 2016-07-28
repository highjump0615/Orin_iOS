//
//  CommentView.h
//  OrionMusic
//
//  Created by TianHang on 10/10/13.
//
//

#import <UIKit/UIKit.h>
#import "GameUtility.h"
#import "PlaceholderTextView.h"

#import "ChartsView.h"
#import "VideoArtistView.h"

@interface CommentData : NSObject {
	NSString*	picture;
	NSString*	userName;
	NSString*	content;
	NSString*	time;
}

@property (nonatomic, retain) NSString* picture;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* content;
@property (nonatomic, retain) NSString* time;

@end


@interface CommentView : UIViewController <UITableViewDataSource, UITableViewDelegate, RunningServiceDelegate, UITextViewDelegate> {
	IBOutlet UITableView*	m_tableView;
	IBOutlet UIButton*		m_btnComment;
	IBOutlet UILabel*		m_labNoComment;
	IBOutlet PlaceholderTextView*	m_textComment;
	
	int			m_nMusicID;
    int			m_nVideoID;
	
	NSMutableArray*	m_aryComments;
	
	ChartsItemView* m_chartItem;
	VideoItemView* m_videoItem;
}

@property (nonatomic) int m_nMusicID;
@property (nonatomic) int m_nVideoID;
@property (nonatomic, retain) 	ChartsItemView* m_chartItem;
@property (nonatomic, retain) 	VideoItemView* m_videoItem;

@end
