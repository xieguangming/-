//
//  ViewController.m
//  折线图绘制
//
//  Created by AS150701001 on 16/6/27.
//  Copyright © 2016年 lele. All rights reserved.
//

#import "ViewController.h"
#import "YLIneView.h"
@interface ViewController ()
@property(nonatomic,weak)YLIneView* LineView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YLIneView* LineView=[[YLIneView alloc] initWithFrame:CGRectMake(0, 100,[UIScreen mainScreen].bounds.size.width, 300)];
   
    LineView.xValues=@[@20,@50,@80,];
    LineView.yValues=@[@10,@26,@35];
    LineView.xKeDuValus=@[@0,@2,@4,@6,@8,@10,@12,@14,@16];
    LineView.yKeDuValus=@[@10,@20,@35,@40,@50,@60,@70,@80,@90,@100];
    LineView.yValueColor=[UIColor redColor];
    LineView.xValueColor=[UIColor lightGrayColor];

    [self.view addSubview:LineView];
    self.LineView=LineView;
    
    [self performSelector:@selector(changeValue) withObject:nil afterDelay:3.0];  //3s后变换
}

-(void)changeValue
{
    self.LineView.xValues=@[@20,@50,@80,@110,@210,@250,@270,@300];
    self.LineView.yValues=@[@10,@26,@35,@50,@90,@30,@70,@90];
}

@end
