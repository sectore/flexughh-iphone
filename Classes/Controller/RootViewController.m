//
//  RootViewController.m
//  FxUG
//
// @author Jens Krause [www.websector.de]
// @date 02/01/09
// @see http://www.websector.de/blog/2009/01/27/free-iphone-app-for-flex-user-group-hamburg-incl-source-code/
//
//

#import "RootViewController.h"
#import "AboutViewController.h"
#import "WebViewController.h"
#import "BlogEntriesController.h"
#import "BlogEntryController.h"

#import "BlogEntry.h"
#import "Meeting.h"
#import	"BlogEntryCell.h"

#import "FormatterUtil.h"

#import "Constants.h"


@implementation RootViewController


#define MAX_TABLE_ROWS 5


- (void)loadView
{
	[super loadView];
	
	mainModel = [[MainModel alloc] init];
	
	
	service = [[ XMLService alloc ] init ];
	
	//
	// navigation bar + its components
	
	[self setTitle: NSLocalizedString(@"LABEL_HOME", @"LABEL_HOME STRING not found")];
	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	
	UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 20) ];
	[logo setImage:[UIImage imageNamed: @"flexughh_logo.png"]];
	
	self.navigationItem.titleView = logo;
	
	[ logo release];
	
	UIBarButtonItem *aboutButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_info.png"]
																	style:UIBarButtonItemStyleBordered 
																   target:self 
																   action:@selector(showAboutView)];
	
	
	self.navigationItem.rightBarButtonItem = aboutButton;
	
	

	
	//
	// home view	
	homeView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] ];
	
	self.view = homeView; 
    [homeView release];
	
	//
	// bg		
	UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 425) ];
	[bg setImage:[UIImage imageNamed: @"bg.png"]];
	
	[ homeView addSubview: bg ];
	
	[ bg release];
	
	// 
	// meeting view
	meetingView = [self createMeetingView];
	[homeView addSubview:meetingView];
	meetingView.hidden = YES;

	meetingLoader = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(160, 16, 20, 20)];
	[meetingLoader startAnimating];	
	[meetingLoader setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray];
	[homeView addSubview:meetingLoader];


	blogListLoader = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(140, 175, 20, 20)];
	[blogListLoader startAnimating];	
	[blogListLoader setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray];
	[homeView addSubview:blogListLoader];
	
}



#pragma mark RootViewController Methods
- (void)viewDidLoad
{
	
	[super viewDidLoad];
	
	// 
	// Spawn threads to fetch all needed data without freezing the UI while loading and parsing XML data
	[NSThread detachNewThreadSelector:@selector( getBlogData ) 
							 toTarget:self 
						   withObject:nil];
	
	
	[NSThread detachNewThreadSelector:@selector( getMeetingData ) 
							 toTarget:self 
						   withObject:nil];
	 
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark -
#pragma mark tableView

-(void) createTableView
{
	tableView = [[UITableView alloc]	initWithFrame:CGRectMake(0, 200, 320, 220) 
											 style:UITableViewStylePlain];
	
    tableView.delegate = self;	
    tableView.dataSource = self;
	
	[ homeView addSubview: tableView ];

}

#pragma mark -
#pragma mark Table Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return MAX_TABLE_ROWS;
}

- (UITableViewCell *)tableView:(UITableView *)tw
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//
	// define a default cell, even we don't fill it with data at initialize
	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";	
	UITableViewCell *cellMore = [tw dequeueReusableCellWithIdentifier:@"SimpleTableIdentifier"];

	static NSString *BlogEntryCellIdentifier = @"BlogEntryCellIdentifier";
	BlogEntryCell *cellBlogEntry = (BlogEntryCell *)[tw dequeueReusableCellWithIdentifier:BlogEntryCellIdentifier];

	
	if (cellMore == nil) 
	{
		cellMore = [[[UITableViewCell alloc] initWithFrame:CGRectZero
										   reuseIdentifier:SimpleTableIdentifier] autorelease];
		cellMore.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cellMore.selectionStyle = BG_TABLE_CELL_SELECTION;
		cellMore.font = [UIFont boldSystemFontOfSize:15];		
	}
	
	
	
	//
	// set text only if we have already loaded all data
	if ( [mainModel.blogEntries count] > 0)
	{
		NSUInteger row = [indexPath row];
		//
		// blog entry cells
		if ( row < MAX_TABLE_ROWS - 1 )
		{
	
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
						cellBlogEntry.selectionStyle = BG_TABLE_CELL_SELECTION;
						break;
					}
				}
				
			}
			
		
			BlogEntry *blogEntry = [ mainModel.blogEntries objectAtIndex:row ];
			// headline
			cellBlogEntry.headline.text = blogEntry.headline;
			// date
			cellBlogEntry.dateTxt.text = [ FormatterUtil formatFeedDateString:  blogEntry.dateString 
																	newFormat: @"d'.' MMM yyyy"];
			

			return cellBlogEntry;
			 
		}
		else
		{
			//
			// more cell

			
			
			cellMore.text = [NSString stringWithFormat: NSLocalizedString(@"LABEL_LAST_ENTRIES", @"LABEL_INFO STRING not found"), 
						 [ mainModel.blogEntries count] ];
			
			return cellMore;
		
		}	
		
	}
	
	return cellMore;
}


- (NSIndexPath *)tableView:(UITableView *)tableView
			willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	return indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView 
		heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (void)tableView:(UITableView *)tableView 
		didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{

	NSUInteger row = [indexPath row];
	
	if ( row < MAX_TABLE_ROWS - 1)
	{
		[ self showBlogEntry: row];
	}
	else
	{
		[self showBlogEntries];
	}
	
}

- (void)viewWillAppear:(BOOL)animated 
{
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
	
	[super viewWillAppear:animated];
}



- (void) showBlogEntry:(int)row
{

	mainModel.selectedBlogEntry = [ mainModel.blogEntries objectAtIndex:row ];
	
	BlogEntryController *controller = [[BlogEntryController alloc] initWithNibName:@"WebViewController" bundle:nil];	
	controller.mainModel = mainModel;
	
	
	[[self navigationController] pushViewController:controller
										   animated:YES];
	
	[ controller release ];
}

- (void) showBlogEntries
{
	BlogEntriesController *controller = [[BlogEntriesController alloc] initWithNibName:@"BlogEntriesController" bundle:nil];
	controller.mainModel = mainModel;
	
	[[self navigationController] pushViewController:controller
										   animated:YES];
	
	[ controller release ];

}




#pragma mark -
#pragma mark AboutView Methods

- (void) showAboutView
{
	[[self navigationController] pushViewController:[[[AboutViewController alloc] initWithNibName:@"WebViewController" bundle:nil] autorelease ]
													animated:YES];
	
}





#pragma mark-
#pragma mark meetingView methods
 
- (UIView *)createMeetingView
{
	UIView *view = [[[UIView alloc] initWithFrame: CGRectMake(10.0f, 40.0f,300.0f, 125.0f) ] autorelease];
	
	//
	// meeting text
	meetingTxt = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 10.0f, 275.0f, 60.0f)];	
	meetingTxt.numberOfLines = 3;	
	meetingTxt.font = [UIFont boldSystemFontOfSize:15.0f];
	
	meetingTxt.textColor = [UIColor whiteColor];
	meetingTxt.backgroundColor = [UIColor clearColor];
	
	[view addSubview:meetingTxt];
	
	
	//
	// meetingInfoButton
	meetingInfoButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	[meetingInfoButton	addTarget:self 
						action:@selector(openMeetingInfoURL) 
						forControlEvents:UIControlEventTouchUpInside];
	
	meetingInfoButton.frame = CGRectMake(10.0f, 80.0f, 130.0f, 30.0f);
	
	[meetingInfoButton setBackgroundImage:IMG_BUTTON_NORMAL
									 forState:UIControlStateNormal];
	[meetingInfoButton setBackgroundImage:IMG_BUTTON_OVER
								 forState:UIControlStateHighlighted];
	
	[meetingInfoButton setFont: FONT_BUTTON];
	[meetingInfoButton setTitle: NSLocalizedString(@"LABEL_INFO", @"LABEL_INFO STRING not found")
					   forState:UIControlStateNormal];
	
	[view addSubview:meetingInfoButton];
	
	[meetingInfoButton release];
	
	//
	// register button
	
	meetingRegisterButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	[meetingRegisterButton	addTarget:self 
							  action:@selector(openRegisterURL) 
					forControlEvents:UIControlEventTouchUpInside];
	
	meetingRegisterButton.frame = CGRectMake(160.0f, 80.0f, 130.0f, 30.0f);
	[meetingRegisterButton setBackgroundImage:IMG_BUTTON_NORMAL
					forState:UIControlStateNormal];
	[meetingRegisterButton setBackgroundImage:IMG_BUTTON_OVER
								 forState:UIControlStateHighlighted];	
	[meetingRegisterButton setFont: FONT_BUTTON];
	[meetingRegisterButton setTitle: NSLocalizedString(@"LABEL_REGISTER", @"LABEL_REGISTER STRING not found")
						   forState:UIControlStateNormal];
	
	[view addSubview:meetingRegisterButton];
	
	[meetingRegisterButton release];
	

	return view;
}


-(void) openMeetingInfoURL
{
	[	[UIApplication sharedApplication] openURL:[ NSURL URLWithString: mainModel.meeting.urlInformation ] ];
}

-(void) openRegisterURL
{
	[	[UIApplication sharedApplication] openURL:[ NSURL URLWithString: mainModel.meeting.urlRegistration ] ];
}




#pragma mark -
#pragma mark call services methods

-(void) getBlogData 
{

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	mainModel.blogEntries = [ service getBlogData ];
	
	[ pool release ];

	[blogListLoader stopAnimating];
	[ blogListLoader removeFromSuperview ];
	
	[ self createTableView ];

	
}

-(void)getMeetingData
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	Meeting *meeting = [ service getMeetingData ];
	
	[ meetingLoader stopAnimating ];
	[ meetingLoader removeFromSuperview ];
	
	meetingTxt.text = meeting.headline;
	
	//
	// hide buttons if we have'nt got any urls
	if ( !meeting.urlInformation || meeting.urlInformation == @"")
	{
		meetingInfoButton.hidden = YES;
	}

	if ( !meeting.urlRegistration || meeting.urlRegistration == @"")
	{
		meetingRegisterButton.hidden = YES;
	}
	
	meetingView.hidden = NO;

	mainModel.meeting = meeting;

	[ pool release ];
	
}



- (void)dealloc 
{
	[mainModel release];
	
	[ service release ];
	 
	[ homeView release ];
	
	[ meetingView release ];	
	[ meetingTxt release ];
	[ meetingRegisterButton release ];
	[ meetingInfoButton release ];
	[ meetingLoader release ];
	
	[ blogListLoader release ];
	[ tableView release ];
	
	
	[super dealloc];
}



@end
