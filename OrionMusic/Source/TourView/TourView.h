//
//  TourView.h
//  OrionMusic
//
//  Created by TianHang on 10/5/13.
//
//

#import <UIKit/UIKit.h>

@interface TourView : UIViewController <UIScrollViewDelegate> {
	IBOutlet UIButton*	m_btnBack;
	NSTimer*	m_timer;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

- (IBAction)onClose:(id)sender;

@end
