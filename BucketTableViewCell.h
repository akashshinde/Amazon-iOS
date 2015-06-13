//
//  BucketTableViewCell.h
//  
//
//  Created by Akash on 11/06/15.
//
//

#import <UIKit/UIKit.h>

@interface BucketTableViewCell : UITableViewCell

@property (strong , nonatomic,readwrite) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *subInfo;
@property (weak, nonatomic) IBOutlet UIButton *bucketInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *bucketRemoveButton;

@end
