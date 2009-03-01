//
//  BlogEntry.h
//  FxUG
//
//	@author			Jens Krause [www.websector.de]
//	@date			02/01/09
//	@see			http://www.websector.de/blog/2009/01/27/free-iphone-app-for-flex-user-group-hamburg-incl-source-code/
//
//	FxUG is open source licensed under the Mozilla Public License 1.1.
//

#import <Foundation/Foundation.h>


@interface BlogEntry : NSObject 
{
	NSString *author;
	NSString *headline; 
	NSString *dateString;
	NSString *text;	
	NSString *link;	
}

@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *headline;
@property (nonatomic, retain) NSString *dateString;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *link;

@end
