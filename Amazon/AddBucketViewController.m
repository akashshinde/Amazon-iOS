//
//  AddBucketViewController.m
//  Amazon
//
//  Created by Akash on 12/06/15.
//  Copyright (c) 2015 Akash. All rights reserved.
//

#import "AddBucketViewController.h"
#import "AWSS3Service.h"
#import "Colours.h"
#import "UIViewController+MMDrawerController.h"
#import "PGSideDrawerController.h"
#import "MBProgressHUD.h"
#import "TSMessage.h"
#import "TSMessageView.h"


@interface AddBucketViewController ()

@end

@implementation AddBucketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Create Bucket";
    self.navigationController.navigationBar.topItem.title = @"";
    self.view.backgroundColor = [UIColor colorFromHexString:@"#F7F9F9"];
    [TSMessage setDefaultViewController:self];
    [TSMessage setDelegate:self];
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{

    //self.mm_drawerController.leftDrawerViewController = _controller;
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"left view controller is %@",self.mm_drawerController.leftDrawerViewController);
}

-(AWSS3CreateBucketRequest *)createBucketWithName:(NSString *)bucketName withLocation:(NSInteger )location andPermission:(NSInteger )acl {
    AWSS3CreateBucketRequest *request = nil;
    request = [[AWSS3CreateBucketRequest alloc] init];
    request.bucket = bucketName;
    request.ACL = (acl);
    AWSS3CreateBucketConfiguration *config = [[AWSS3CreateBucketConfiguration alloc]init];
    [config setLocationConstraint: (location)];
    request.createBucketConfiguration = config;
    return request;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)showAlertWithMessage:(NSString *)message andWithResult:(NSString *) result andType:(TSMessageNotificationType) type {
    
   /* UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:result message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    */
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
     //   [alertView show];
        [TSMessage showNotificationWithTitle:result
                                    subtitle:message
                                        type:type];

    });
    

}

- (IBAction)createBucket:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[[AWSS3 defaultS3] createBucket:[self createBucketWithName:self.nameInput.text withLocation:AWSS3BucketLocationConstraintSAEast1 andPermission:AWSS3BucketCannedACLPublicRead]]
     continueWithBlock:^id(BFTask *task) {
         NSLog(@"result is %@",task.result);
         if (task.error) {
             [self showAlertWithMessage:@"Can not create bucket with this name" andWithResult:@"Error" andType:TSMessageNotificationTypeError];
         }else if(task.result) {
                   [self showAlertWithMessage:@"Created bucket with name" andWithResult:@"Success" andType:TSMessageNotificationTypeSuccess];
         }
         return nil;
     }];
}
@end
