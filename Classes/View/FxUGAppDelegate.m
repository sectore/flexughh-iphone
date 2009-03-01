//
//  FxUGAppDelegate.m
//  FxUG
//
//	@author			Jens Krause [www.websector.de]
//	@date			02/01/09
//	@see			http://www.websector.de/blog/2009/01/27/free-iphone-app-for-flex-user-group-hamburg-incl-source-code/
//
//	FxUG is open source licensed under the Mozilla Public License 1.1.
//

#import "FxUGAppDelegate.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"

#import "Constants.h"

@implementation FxUGAppDelegate

@synthesize window;
@synthesize navController;


- (void)applicationDidFinishLaunching:(UIApplication *)application 
{    
	//
	// add root view which is the root controller for NavigationController
	// Note: It is defined using Interface Builder
    [window addSubview: navController.view];
    [window makeKeyAndVisible];
		
	//
	// check internet status
	[Reachability sharedReachability].hostName = URL_CHECK_REACHABILITY;
	
	isOnline = ( [[Reachability sharedReachability] remoteHostStatus] != NotReachable );
	
	 if (!isOnline)
	 {
		 UIAlertView *alert = [[UIAlertView alloc] 
							   initWithTitle:@"Error" 
							   message:NSLocalizedString(@"ERROR_OFFLINE", @"ERROR_OFFLINE not found")  
							   delegate:nil 
							   cancelButtonTitle:NSLocalizedString(@"OK", @"OK not found")  
							   otherButtonTitles:nil];	 
		 
		 [alert setBackgroundColor: [UIColor blackColor]];
		 [alert show]; 
		 [alert release]; 
	 }
	
	

		
}


- (BOOL)isBlogAvailable
{
	BOOL isDataSourceAvailable = NO; 
	
	const char *host_name = "google.com";
	
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
	SCNetworkReachabilityFlags flags;
	Boolean success = SCNetworkReachabilityGetFlags(reachability, &flags);
	isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
	CFRelease(reachability);
    
    return isDataSourceAvailable;
}


- (void)dealloc 
{
	[navController release];
    [window release];
    [super dealloc];
}


@end
