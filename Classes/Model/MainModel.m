//
//  MainModel.m
//  FxUG
//
//	@author			Jens Krause [www.websector.de]
//	@date			02/01/09
//	@see			http://www.websector.de/blog/2009/01/27/free-iphone-app-for-flex-user-group-hamburg-incl-source-code/
//
//	FxUG is open source licensed under the Mozilla Public License 1.1.
//

#import "MainModel.h"


@implementation MainModel

@synthesize blogEntries;
@synthesize meeting;
@synthesize selectedBlogEntry;


-(id)init
{
	if (self = [super init]) 
	{	
		blogEntries = [[NSMutableArray alloc] init];
		meeting = [[Meeting alloc] init];
	}
	return self;
}

- (void)dealloc 
{
	[selectedBlogEntry release];
	[blogEntries release];
	[meeting release];
	
	[super dealloc];
}

@end
