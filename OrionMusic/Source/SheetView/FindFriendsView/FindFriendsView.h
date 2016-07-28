//
//  FindFriendsView.h
//  OrionMusic
//
//  Created by TianHang on 10/11/13.
//
//

#import <UIKit/UIKit.h>

@interface FindFriends : UIView <UITableViewDataSource, UITableViewDelegate>

@end

@interface FindFriendsView : UIViewController {
	IBOutlet UITableView* m_tableView;
}

@end
