//
//  WebViewController.m
//  FxUG
//
//	@author			Jens Krause [www.websector.de]
//	@date			02/01/09
//	@see			http://www.websector.de/blog/2009/01/27/free-iphone-app-for-flex-user-group-hamburg-incl-source-code/
//
//	FxUG is open source licensed under the Mozilla Public License 1.1.
//

#import "WebViewController.h"

#import "Constants.h"

@implementation WebViewController

- (void)dealloc 
{
	
	[webView release];	
    [super dealloc];
}


@end
