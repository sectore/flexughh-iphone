//
//  BlogEntriesController.m
//  FxUG
//
//	@author			Jens Krause [www.websector.de]
//	@date			02/01/09
//	@see			http://www.websector.de/blog/2009/01/27/free-iphone-app-for-flex-user-group-hamburg-incl-source-code/
//
//	FxUG is open source licensed under the Mozilla Public License 1.1.
//

#import "BlogEntriesController.h"
#import "BlogEntry.h"
#import "BlogEntryCell.h"
#import "FormatterUtil.h"
#import "BlogEntryController.h"

#import "Constants.h"


@implementation BlogEntriesController

@synthesize mainModel;



- (void)viewDidLoad 
 {
    [super viewDidLoad];

	 self.title =  NSLocalizedString(@"LABEL_BLOG_ENTRIES", @"LABEL_BLOG_ENTRIES STRING not found");

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return mainModel.blogEntries.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tw 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
	static NSString *BlogEntryCellIdentifier = @"BlogEntryCellIdentifier";
	BlogEntryCell *cellBlogEntry = (BlogEntryCell *)[tw dequeueReusableCellWithIdentifier:BlogEntryCellIdentifier];
	
	NSUInteger row = [indexPath row];
	
	if ( cellBlogEntry == nil ) 
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BlogEntryCell" 
													 owner:self 
												   options:nil];
		
		for (id object in nib)
		{
			if ( [object isKindOfClass:[ UITableViewCell class]])
			{
				cellBlogEntry = object;
				break;
			}
		}
		
	}
	
	
	BlogEntry *blogEntry = [ mainModel.blogEntries objectAtIndex:row ];
	// headline
	cellBlogEntry.headline.text = blogEntry.headline;

	cellBlogEntry.dateTxt.text = [ FormatterUtil formatFeedDateString:  blogEntry.dateString 
															newFormat: @"d'.' MMM yyyy"];
	
	
	return cellBlogEntry;
}


- (void)tableView:(UITableView *)tableView 
			didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	mainModel.selectedBlogEntry = [ mainModel.blogEntries objectAtIndex:[indexPath row] ];
	
	BlogEntryController *controller = [[BlogEntryController alloc] initWithNibName:@"WebViewController" bundle:nil];	
	controller.mainModel = mainModel;
	
	
	[[self navigationController] pushViewController:controller
										   animated:YES];
	
	[ controller release ];
}



- (void)viewWillAppear:(BOOL)animated 
{
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
	
	[super viewWillAppear:animated];
}


- (void)dealloc 
{
	[mainModel release];
	
	[tableView release];
	
    [super dealloc];
}


@end

