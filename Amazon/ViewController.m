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
#import "UIViewController+MMDrawerController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    self.navigationItem.title = @"Amazon S3";
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexString:@"#37515Fr"];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor indianRedColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor indianRedColor] forKey:NSForegroundColorAttributeName];
    [self setupLeftMenuButton];
    
    NSLog(@"Added files ");
   
    //AWSRequest *request = [[AWSRequest alloc] init];
    
    //[self takeImage];
    
    
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




-(void)takeImage{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else{
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    imagePicker.delegate = self;
    
    [self.navigationController presentViewController:imagePicker animated:YES completion:^{
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.bucketList count];
}

- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    AWSS3Bucket *bucket = [self.bucketList objectAtIndex:indexPath.row];
    cell.textLabel.text = bucket.name;
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
