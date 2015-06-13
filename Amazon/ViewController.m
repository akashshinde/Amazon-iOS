//
//  ViewController.m
//  Amazon
//
//  Created by Akash on 07/06/15.
//  Copyright (c) 2015 Akash. All rights reserved.
//

#import "ViewController.h"

#import "AWSEC2Service.h"
#import "AWSS3Service.h"
#import "S3ObjectList.h"
#import "Colours.h"
#import "DisplayImage.h"
#import "MMDrawerBarButtonItem.h"
#import "MMDrawerController.h"
#import "PGFirstViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "CustomCellTableViewCell.h"
#import "AddBucketViewController.h"

@interface ViewController ()

@end

@implementation ViewController


-(void)viewWillAppear:(BOOL)animated{
        self.navigationItem.title = @"Amazon S3";
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationItem.title = @"";
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"Amazon S3";
    
    
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];

    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexString:@"#3D5467"];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorFromHexString:@"#A3C4BC"];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor colorFromHexString:@"#ADC6C4"] forKey:NSForegroundColorAttributeName];
    [self setupLeftMenuButton];
    NSLog(@"Added files ");
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    //AWSRequest *request = [[AWSRequest alloc] init];
    //[self takeImage];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    AWSS3 *s3 = [AWSS3 defaultS3];
    [[s3 listBuckets:[[AWSRequest alloc] init]] continueWithBlock:^id(BFTask *task) {
        NSLog(@"Got response %@",task.result);
        AWSS3ListBucketsOutput *output = task.result;
        NSLog(@"Buckets are %@",output.buckets);
        self.bucketList = output.buckets;
        dispatch_sync(dispatch_get_main_queue(), ^{
         [self.tableView reloadData];     
      });
        return nil;
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(void)takeImage {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else{
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
   // imagePicker.delegate = self;
    
    [self.navigationController presentViewController:imagePicker animated:YES completion:^{
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.bucketList count];
}

- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    UIButton *add = [UIButton buttonWithType:UIButtonTypeContactAdd];
    UIBarButtonItem *addBucketItem = [[UIBarButtonItem alloc] initWithCustomView:add];
    self.navigationItem.rightBarButtonItem = addBucketItem;
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
    [add addTarget:self action:@selector(addBucket) forControlEvents:UIControlEventTouchUpInside];
}

-(void)addBucket{
//    AddBucketViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"addBucket"];
    [self performSegueWithIdentifier:@"addBucket" sender:self];
  //  [self.navigationController presentViewController:controller animated:YES completion:^{
   //     NSLog(@"add controller presented");
   // }];
    /*
    [[[AWSS3 defaultS3] createBucket:[self createBucketWithName:@"macmachine4" withLocation:AWSS3BucketLocationConstraintSAEast1 andPermission:AWSS3BucketCannedACLPublicRead]]
     continueWithBlock:^id(BFTask *task) {
         NSLog(@"result is %@",task.result);
         return nil;
    }]; */
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CustomCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
    AWSS3Bucket *bucket = [self.bucketList objectAtIndex:indexPath.row];
    cell.title.textColor = [UIColor colorFromHexString:@"#4281A4"];
    [cell.title setText:bucket.name];
    cell.subtitle.font = [UIFont italicSystemFontOfSize:12.0f];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:bucket.creationDate
                                                          dateStyle:NSDateFormatterMediumStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    NSString *date = [NSString stringWithFormat:@"created on %@", dateString];
    [cell.subtitle setTextColor:[UIColor colorFromHexString:@"#ADC6C4"]];
    [cell.subtitle setText:date];
    return cell;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"Dictionary is %@",info);
    [self.navigationController dismissViewControllerAnimated:NO completion:^{
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    DisplayImage *displayImage = [[DisplayImage alloc] init];
    displayImage.imageView.image = image;
    [self.navigationController presentViewController:displayImage animated:YES completion:^{
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedBucketName = cell.textLabel.text;
    S3ObjectList *objectListController = [[S3ObjectList alloc]init];
    objectListController.bucketName = self.selectedBucketName;
    [self.navigationController pushViewController:objectListController animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   if ([segue.identifier isEqualToString:@"getObjects"]) {
       NSLog(@"segue activated");
   }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
