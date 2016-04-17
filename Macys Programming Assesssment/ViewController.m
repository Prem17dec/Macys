//
//  ViewController.m
//  Macys Programming Assesssment
//
//  Created by Prem Kumar on 4/17/16.
//  Copyright © 2016 Prem Kumar. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"



//Few constant strings to be used in the app
NSString *NACTEM_URL = @"http://www.nactem.ac.uk/software/acromine/dictionary.py";
NSString *SHORT_HAND = @"sf";
NSString *LONG_HANDS = @"lfs";
NSString *LONG_HAND = @"lf";
NSString *TEXT_FORMAT = @"text/plain";


@interface ViewController (){
    NSMutableArray *meaningsArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearText:(id)sender {
    
    //Clearing textfield value
    self.textEntry.text = @"";
    
    //Clearing TableView contents
    if([meaningsArray count] != 0){
        
        [meaningsArray removeAllObjects];
        [self.resultTable reloadData];
    }
}

- (IBAction)getResults:(id)sender {
    [self getResponseFromURL:self.textEntry.text];
}

#pragma mark Helper methods
-(void)getResponseFromURL:(NSString *)acronym
{
    //URl for the Acronym Data
    NSURL *URL = [NSURL URLWithString:NACTEM_URL];
    
    //Get sessionManager
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    //Set Acceptable content types
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [sessionManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:TEXT_FORMAT, nil]];
    
    //request parametrs
    NSDictionary *requestParameters = @{SHORT_HAND : acronym};
    
    //Show MBProgressHUD while download
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //Get data from URL
    [sessionManager GET:URL.absoluteString parameters:requestParameters progress:nil success:^(NSURLSessionTask *task, NSData *responseObject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *error;
            
            //convert responseObject to Array
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            
            meaningsArray=[self getParsedData:jsonArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //Hide MBProgressHUD after download
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                
                //Show Result label
                NSString *meaning = [meaningsArray componentsJoinedByString:@"\n"];
                if([meaning isEqual: @""])
                    self.resultLabel.hidden = NO;
                else
                    self.resultLabel.hidden = YES;
                
                //Reload TableView
                [self.resultTable reloadData];
            });
        });
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

//Parse responseData
-(NSMutableArray *)getParsedData:(NSArray *)responseData
{
    meaningsArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *responseDict in responseData)
    {
        NSArray *longFormsArray=[responseDict valueForKey:LONG_HANDS];
        for (NSDictionary *longFormObject in longFormsArray) {
            [meaningsArray addObject:[longFormObject valueForKey:LONG_HAND]];
        }
    }
    
    return meaningsArray;
}

#pragma TableView Delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Selection of cell
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [meaningsArray count];
}

// Update data in table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set data for the cell
    
    cell.textLabel.text = [meaningsArray objectAtIndex:indexPath.row];
    
    
    return cell;
}

@end
