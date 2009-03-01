//
//  MainModel.h
//  FxUG
//
//	@author			Jens Krause [www.websector.de]
//	@date			02/01/09
//	@see			http://www.websector.de/blog/2009/01/27/free-iphone-app-for-flex-user-group-hamburg-incl-source-code/
//
//	FxUG is open source licensed under the Mozilla Public License 1.1.
//

#import <Foundation/Foundation.h>
#import "Meeting.h"
#import "BlogEntry.h"

@interface MainModel : NSObject 
{
	NSMutableArray *blogEntries;
	Meeting *meeting;
	BlogEntry *selectedBlogEntry;
}

@property (nonatomic, retain) NSMutableArray *blogEntries;
@property (nonatomic, retain) Meeting *meeting;
@property (nonatomic, retain) BlogEntry *selectedBlogEntry;

@end
