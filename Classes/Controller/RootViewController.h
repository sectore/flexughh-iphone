//
//  RootViewController.h
//  FxUG
//
//  Created by Jens Krause on 14.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModel.h"
#import "XMLService.h"


@interface RootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	UIView *homeView;
	
	UIView *meetingView;
	UILabel *meetingTxt;
	UIButton *meetingInfoButton;
	UIButton *meetingRegisterButton;
	UIActivityIndicatorView *meetingLoader;
	
	UITableView *tableView;	
	UIActivityIndicatorView *blogListLoader;
	
	MainModel *mainModel;
	
	XMLService *service;
}

- (void) getBlogData;
- (void) getMeetingData;
- (UIView *) createMeetingView;
- (void) createTableView;
- (void) showBlogEntries;
- (void) showBlogEntry:(int)row;
- (void)openMeetingInfoURL;
- (void) openRegisterURL;

@end
