//
//  BaseView.h
//  OrionMusic
//
//  Created by TianHang on 10/11/13.
//
//

#import <UIKit/UIKit.h>

@interface BaseView : UIViewController {
	UIViewController*	m_parent;
}

@property (nonatomic, retain) UIViewController* parent;

@end
