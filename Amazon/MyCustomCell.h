//
//  MyCustomCell.h
//  CustomCellTutorial
//
//  Created by Musawir Shah on 10/17/13.
//  Copyright (c) 2013 Musawir Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCustomCell : UITableViewCell

@property (weak, readwrite) IBOutlet UILabel *title;

@property (weak, readwrite) IBOutlet UILabel *subInfo;

@property (weak, nonatomic) IBOutlet UIButton *bucketInfo;

@property (weak, nonatomic) IBOutlet UIButton *bucketRemoveButton;

@end
