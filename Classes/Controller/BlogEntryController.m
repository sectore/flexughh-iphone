//
//  BlogEntryController.m
//  FxUG
//
//	@author			Jens Krause [www.websector.de]
//	@date			02/01/09
//	@see			http://www.websector.de/blog/2009/01/27/free-iphone-app-for-flex-user-group-hamburg-incl-source-code/
//
//	FxUG is open source licensed under the Mozilla Public License 1.1.
//

#import "BlogEntryController.h"
#import "BlogEntry.h"
#import "FormatterUtil.h"

#import "Constants.h"

#import "RegexKitLite.h"
#import "RKLMatchEnumerator.h"

@implementation BlogEntryController


@synthesize mainModel;


- (void)viewDidLoad
{
	BlogEntry *blogEntry = mainModel.selectedBlogEntry;
	
    [super viewDidLoad];

	[self setTitle: NSLocalizedString(@"LABEL_BLOG_ENTRY", @"LABEL_BLOG_ENTRY STRING not found")];
	
	[[self view] setBackgroundColor:[UIColor whiteColor]];
	[webView setBackgroundColor:[UIColor whiteColor]];
	

	
	//
	// remove all <img> tags to load a blog entry qick as possible
	NSString *regexString = @"<img[^>]+>";		
	NSEnumerator *matchEnumerator = [blogEntry.text matchEnumeratorWithRegex:regexString]; 
	NSString *matchedString = NULL; 
	
	NSMutableString *trimmedEntryTxt = [[NSMutableString alloc] initWithString:blogEntry.text ];
	
	while((matchedString = [matchEnumerator nextObject]) != NULL) 
	{ 
		[trimmedEntryTxt replaceOccurrencesOfString: matchedString 
										withString:@"" 
										options:0 
										range:NSMakeRange(0, [trimmedEntryTxt length])];
	} 
	
	// NSLog(@"trimmedEntryTxt : '%@'", trimmedEntryTxt);
	
	 
	[webView loadHTMLString: [NSString stringWithFormat: @"%@<h1 id='headline'>%@</h1><p id='date'>%@ %@ %@</p><p>%@</p>", 
							  STYLE_TXT_BLOG_ENTRY, 
							  blogEntry.headline,
							  [ FormatterUtil formatFeedDateString:  blogEntry.dateString 
																	newFormat: @"d'.' MMMM yyyy"],
							  NSLocalizedString(@"BY", @"BY STRING not found"),
							   blogEntry.author,
							  trimmedEntryTxt]
							baseURL:nil];
	
	[trimmedEntryTxt release];

}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		[[UIApplication sharedApplication] openURL:[request URL]];
		return NO;
	}
	return YES;
}

#pragma mark -
#pragma mark Memory methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc 
{
	[mainModel release ];
    [super dealloc];
}


@end
