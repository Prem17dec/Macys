//
//  ViewController.h
//  Macys Programming Assesssment
//
//  Created by Prem Kumar on 4/17/16.
//  Copyright © 2016 Prem Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *textEntry;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;


- (IBAction)clearText:(id)sender;
- (IBAction)getResults:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *resultTable;


@end

