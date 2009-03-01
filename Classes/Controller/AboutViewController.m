//
//  AboutViewController.m
//  FxUG
//
//	@author			Jens Krause [www.websector.de]
//	@date			02/01/09
//	@see			http://www.websector.de/blog/2009/01/27/free-iphone-app-for-flex-user-group-hamburg-incl-source-code/
//
//	FxUG is open source licensed under the Mozilla Public License 1.1.
//

#import "AboutViewController.h"

#import "Constants.h"

@implementation AboutViewController




// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{

}
*/

#pragma mark -
#pragma mark WebView methods

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{


	[self setTitle: NSLocalizedString(@"LABEL_ABOUT", @"LABEL_ABOUT STRING not found")];
	
	[[self view] setBackgroundColor:[UIColor blackColor]];
	[webView setBackgroundColor:[UIColor blackColor]];
	
	[webView loadHTMLString: [NSString stringWithFormat: @"%@%@", 
							  STYLE_TXT_ABOUT, 
							  NSLocalizedString(@"TXT_ABOUT", @"TXT_ABOUT STRING not found") ]
							baseURL:nil];
    [super viewDidLoad];	
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		[[UIApplication sharedApplication] openURL:[request URL]];
		return NO;
	}
	return YES;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc 
{
    [super dealloc];
}


@end
