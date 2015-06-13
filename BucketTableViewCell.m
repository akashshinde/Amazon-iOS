//
//  BucketTableViewCell.m
//  
//
//  Created by Akash on 11/06/15.
//
//

#import "BucketTableViewCell.h"

@implementation BucketTableViewCell

@synthesize title;
@synthesize subInfo;

- (void)awakeFromNib {
    // Initialization code

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
