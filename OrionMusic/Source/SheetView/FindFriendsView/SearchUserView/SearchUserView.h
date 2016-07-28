//
//  SearchUserView.h
//  OrionMusic
//
//  Created by TianHang on 10/21/13.
//
//

#import <UIKit/UIKit.h>
#import "GameUtility.h"

@interface SearchUserView : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, RunningServiceDelegate> {
	IBOutlet UITextField*	m_textKeyword;
	IBOutlet UITableView*	m_tableView;
	
	NSMutableArray*	m_arySearchData;
    
    int nCurrentRow;
    
    int m_nType; // 0: Normal, 1: Facebook, 2: Twitter
}

- (id)initWithType:(int) nType;

@end
