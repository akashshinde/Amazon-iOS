//
//  AddBucketViewController.h
//  Amazon
//
//  Created by Akash on 12/06/15.
//  Copyright (c) 2015 Akash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSMessageView.h"

@interface AddBucketViewController : UIViewController <TSMessageViewProtocol>
@property (weak, nonatomic) IBOutlet UIButton *createBucket;
- (IBAction)createBucket:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameInput;

@property (weak,nonatomic) UIViewController *controller;

@end
