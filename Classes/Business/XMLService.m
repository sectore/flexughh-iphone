//
//  XMLService.m
//  FxUG
//
//	@author			Jens Krause [www.websector.de]
//	@date			02/01/09
//	@see			http://www.websector.de/blog/2009/01/27/free-iphone-app-for-flex-user-group-hamburg-incl-source-code/
//
//	FxUG is open source licensed under the Mozilla Public License 1.1.
//

#import "XMLService.h"
#import "Constants.h"
#import "CXMLDocument.h"
#import "BlogEntry.h"


@implementation XMLService

-(NSMutableArray *) getBlogData
{	
	
    NSMutableArray *blogEntries = [[[NSMutableArray alloc] init] autorelease ];	
	
	NSURL *url = [NSURL URLWithString: URL_BLOG_FEED];
	//
	// Note: It seems, that NSURL is retained by CXMLDocument several times
//	NSLog( @"1. retainCount: %i",[url retainCount] );
	
    CXMLDocument *rssParser = [[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil];

//	NSLog( @"2. retainCount: %i",[url retainCount] );

	
    NSArray *resultNodes = NULL;
	
    resultNodes = [rssParser nodesForXPath:@"//item" error:nil];
	
    for (CXMLElement *resultElement in resultNodes) 
	{
		
		BlogEntry *blogEntry = [ [BlogEntry alloc] init ];	
		
		
        int i;
        for(i = 0; i < [resultElement childCount]; i++) 
		{
			
			
			NSString *childName = [[resultElement childAtIndex:i] name];
			NSString *childStringValue = [[resultElement childAtIndex:i] stringValue];
			
			if ( [childName isEqualToString:@"creator"] )
			{
				blogEntry.author = childStringValue;
				//NSLog (@"author %@",  blogEntry.author);
			}
			if ( [childName isEqualToString:@"pubDate"] )
			{
				blogEntry.dateString = childStringValue;
				//NSLog (@"pubDate %@",  blogEntry.dateString);
			}
			else if ( [childName isEqualToString:@"link"] )
			{
				blogEntry.link = childStringValue;
				//NSLog (@"text %@",  blogEntry.link);
			}
			else if ( [childName isEqualToString:@"title"] )
			{
				blogEntry.headline = childStringValue;
				//NSLog (@"title %@",  blogEntry.headline);
			}
			else if ( [childName isEqualToString:@"encoded"] )
			{
				blogEntry.text = childStringValue;
				//	NSLog (@"text %@",  blogEntry.text);
				//	NSLog (@"*******************");
			}
			
			
        }

		
		[ blogEntries addObject: blogEntry ];
		[ blogEntry release ];	
	}

	[ rssParser release ];

	return blogEntries;
}


-(Meeting *)getMeetingData
{
	
	NSURL *url = [NSURL URLWithString: URL_MEETING_XML];
	
    CXMLDocument *xmlParser = [[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil];
    NSArray *nodes = [xmlParser nodesForXPath:@"//meeting" error:nil];	
	
	CXMLElement *meetingNode = [nodes objectAtIndex:0];
	
	Meeting *meeting = [[[Meeting alloc] init] autorelease ];
	
	int i;
	for(i = 0; i < [meetingNode childCount]; i++) 
	{
		NSString *childName = [[meetingNode childAtIndex:i] name];
		NSString *childStringValue = [[meetingNode childAtIndex:i] stringValue];
		
		if ( [childName isEqualToString:@"urlInfo"] )
		{
			meeting.urlInformation = childStringValue;
			//NSLog (@"urlInfo %@",  meeting.urlInformation);
		}	
		else if ( [childName isEqualToString:@"urlRegister"] )
		{
			meeting.urlRegistration = childStringValue;
			//NSLog (@"urlRegister %@",  meeting.urlRegistration);
		}
		else if ( [childName isEqualToString:@"headline"] )
		{
			meeting.headline = childStringValue;
			//NSLog (@"headline %@",  meeting.headline);
		}			
	}
	
	[xmlParser release];

	return meeting;

		
}


@end
