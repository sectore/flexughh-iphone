//
//  BlogEntryCell.h
//  FxUG
//
//	@author			Jens Krause [www.websector.de]
//	@date			02/01/09
//	@see			http://www.websector.de/blog/2009/01/27/free-iphone-app-for-flex-user-group-hamburg-incl-source-code/
//
//	FxUG is open source licensed under the Mozilla Public License 1.1.
//

#import <UIKit/UIKit.h>


@interface BlogEntryCell : UITableViewCell 
{
	IBOutlet UILabel	*headline;
	IBOutlet UILabel	*dateTxt;
}


@property (nonatomic, retain) UILabel *headline;
@property (nonatomic, retain) UILabel *dateTxt;

@end
