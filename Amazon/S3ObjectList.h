//
//  S3ObjectList.h
//  Amazon
//
//  Created by Akash on 08/06/15.
//  Copyright (c) 2015 Akash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface S3ObjectList : UITableViewController

@property (nonatomic,retain) NSArray *objectList;
@property (nonatomic,retain) NSString *bucketName;


@end
