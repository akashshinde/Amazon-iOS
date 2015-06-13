    //
//  S3ObjectList.m
//  Amazon
//
//  Created by Akash on 08/06/15.
//  Copyright (c) 2015 Akash. All rights reserved.
//

#import "S3ObjectList.h"
#import "AWSS3Service.h"
#import "MBProgressHUD.h"

@implementation S3ObjectList

-(void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"bucket name is %@",self.bucketName);
    self.navigationItem.title = self.bucketName;
    
 //   self.navigationItem.leftItemsSupplementBackButton = YES;

    
    [self listS3Objects];
}


-(BFTask *)listS3Objects{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AWSS3 *s3Instance = [AWSS3 defaultS3];
    AWSS3ListObjectsRequest *objectsRequest = [[AWSS3ListObjectsRequest alloc] init];
    objectsRequest.bucket = self.bucketName;
    [[s3Instance listObjects: objectsRequest] continueWithBlock:^id(BFTask *task) {
        if (task.result) {
            NSLog(@"Objects received %@",task.result);
            AWSS3ListObjectsOutput *output = task.result;
            self.objectList = output.contents;
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.tableView reloadData];
            });

        }else{
            NSLog(@"Error while fetching data from amazon server %@",task.error);
        }
        return task;
    }
    ];
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.objectList count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIImage *image = [self getS3ObjectFromName:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    [tableView cellForRowAtIndexPath:indexPath].imageView.image = image;
}

-(UIImage *)getS3ObjectFromName:(NSString *)objectName{
    AWSS3 *awsS3 = [AWSS3 defaultS3];
    AWSS3GetObjectRequest *getObjectRequest = [[AWSS3GetObjectRequest alloc] init];
    getObjectRequest.bucket = self.bucketName;
    getObjectRequest.key = objectName;
    
    [[awsS3 getObject:getObjectRequest] continueWithBlock:^id(BFTask *task) {
        UIImage *image = nil;
        if (task.result) {
            NSLog(@"File downloaded succesfully");
            AWSS3GetObjectOutput *output = task.result;
            image = [UIImage imageWithData:output.body];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 282)];
                imageView.contentMode=UIViewContentModeCenter;
                [imageView setImage:image];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Image"
                                                                    message:@"see image ?"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                //check if os version is 7 or above
                if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
                    [alertView setValue:imageView forKey:@"accessoryView"];
                }else{
                    [alertView addSubview:imageView];
                }
                [alertView show];
            });

            NSLog(@"output of get is %@",output);
        } else if (task.error){
            NSLog(@"Error is %@" ,task.error);
        }
        return image;
    }];
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"objectList"];
    }
    AWSS3Object *singleObject = [self.objectList objectAtIndex:indexPath.row];
    cell.textLabel.text = singleObject.key;
    return cell;
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


@end
