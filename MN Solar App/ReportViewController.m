//
//  ReportViewController.m
//  MN Solar App
//
//  Created by Andy Walz on 11/2/14.
//  Copyright (c) 2014 MN Solar Suitability Team. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()

- (IBAction)backToMap:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *reportView;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.thePin =
    
    NSString * myurl = [NSString stringWithFormat:@"http://solar.maps.umn.edu/ios/index.html?lat=%f&long=%f",self.thePin.y,self.thePin.x];
    
    NSLog(@"%@",myurl);
    
    NSURL *appleURL; appleURL =[ NSURL URLWithString:myurl]; [_reportView loadRequest:[ NSURLRequest requestWithURL: appleURL]];
    
    self.reportView.hidden = NO;
    
    //AGSPoint *mypin = ((MapViewController *)self.presentingViewController).pin;
    
    NSLog(@"%f", self.thePin.x);
    
// NSString *html = [self.reportWeb stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    
//   NSLog(@"%@",html);
  
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

- (IBAction)backToMap:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
