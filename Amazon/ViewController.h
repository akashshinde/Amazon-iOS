//
//  ViewController.h
//  Amazon
//
//  Created by Akash on 07/06/15.
//  Copyright (c) 2015 Akash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BucketListTableViewCell.h"

@class CBStoreHouseRefreshControl;

@interface ViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate>

@property (nonatomic,readwrite) NSArray *bucketList;
@property (nonatomic,retain) NSString *selectedBucketName;
@property (nonatomic,retain) UIImage *selectedImage;
@property (assign,readwrite) BucketListTableViewCell *cell;
@property (strong,readwrite) NSDateFormatter *formatter;
@property (strong,readwrite) CBStoreHouseRefreshControl *storeHouseRefreshControl;

@end

