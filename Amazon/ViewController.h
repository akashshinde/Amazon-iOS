//
//  ViewController.h
//  Amazon
//
//  Created by Akash on 07/06/15.
//  Copyright (c) 2015 Akash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,readwrite) NSArray *bucketList;
@property (nonatomic,retain) NSString *selectedBucketName;
@property (nonatomic,retain) UIImage *selectedImage;


@end

