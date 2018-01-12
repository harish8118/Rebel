//
//  ViewController.m
//  example
//
//  Created by macmini on 2/11/17.
//  Copyright © 2017 OUorg. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"
#import "AFNetworking.h"


@interface ViewController (){
    NSURLSession*url;
    NSURLSessionDataTask*datatask;
    NSURLSessionConfiguration*urlconfig;
    NSMutableURLRequest*urlreq;
    NSMutableString*dict;
    NSMutableArray*arr;
}


@end

@implementation ViewController

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 14;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    [cell setFrame:CGRectMake(6, 0, self.clctVw.frame.size.width, 90)];
    
    return cell;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    dict=[NSMutableString new];
    
    _seg.layer.borderColor=[UIColor clearColor].CGColor;
    _seg.layer.borderWidth=2;
    
    [self.menu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    //self.menu.action=@selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    // Do any additional setup after loading the view, typically from a nib.
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments]];
    
    [manager GET:[NSString stringWithFormat:@"http://103.231.100.207/EmpAdminAPI/api/admin/GetTaskDetails"] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSError*err;
        NSData* data1 = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        arr=(NSMutableArray*)[NSJSONSerialization JSONObjectWithData:data1
                                                          options:NSJSONReadingMutableContainers
                                                            error:&err];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)proceed:(id)sender {
    
    NSString* Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    NSLog(@"output is : %@", Identifier);
    
    urlreq = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://103.231.100.207/DemoAPI/api/Leaves/GetLoginDetails"]];
    
    urlconfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    url = [NSURLSession sessionWithConfiguration:urlconfig];
    
    [urlreq setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [urlreq setHTTPMethod:@"GET"];
    
    NSString *post = [[NSString alloc] initWithFormat:@"emailid=%@&mobilenumber=%@&photodata=%@&deviceinfo=%@",self.frstTF.text,self.scndTF.text,nil,Identifier];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    [urlreq setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [urlreq setHTTPBody:postData];
    
    
    datatask=[url dataTaskWithRequest:urlreq completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"data recieved");
        
        dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"output is to be %@",dict);
//        otpVC*otp=[self.storyboard instantiateViewControllerWithIdentifier:@"otpVC"];
//        [self presentViewController:otp animated:YES completion:nil];
        
    }];
    
    [datatask resume];
}
@end
