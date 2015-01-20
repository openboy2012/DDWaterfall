//
//  ViewController.m
//  DDWaterfall
//
//  Created by Diaoshu on 15-1-18.
//  Copyright (c) 2015年 MBaoBao Inc. All rights reserved.
//

#import "ViewController.h"
#import "DDWaterfallView.h"

@interface ViewController ()<DDWaterfallViewDataSource,DDWaterfallViewDelegate>{
    NSMutableArray *dataList;
}

@property (nonatomic, strong) DDWaterfallView *waterfallView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if(!dataList){
        dataList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    self.waterfallView = [[DDWaterfallView alloc] initWithFrame:self.view.bounds];
    self.waterfallView.waterfallDelegate = self;
    self.waterfallView.waterfallDataSource = self;
    self.waterfallView.contentInset = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0f);
    
    [self.view addSubview:self.waterfallView];
    
//    for (int i = 0; i < 20; ++i) {
//        [dataList addObject:@(i)];
//    }
//    [self.waterfallView reloadData];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DDWaterfallDataSource Methods

- (NSInteger)numberOfColumnsInWaterfallView:(DDWaterfallView *)waterfallView{
    return 2;
}

- (NSInteger)waterfallView:(DDWaterfallView *)waterfallView numberOfRowsInColumn:(NSInteger)column{
    if(column == 0){
        return ceilf(dataList.count/[waterfallView numberOfColumns]);
    }else
        return floorf(dataList.count/[waterfallView numberOfColumns]);
}

- (DDWaterfallCell *)waterfallView:(DDWaterfallView *)waterfallView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDWaterfallCell *cell = [waterfallView dequeueReusableCellWithIdentifier:@"DemoCell"];
    if(!cell){
        cell = [[DDWaterfallCell alloc] initWithIdentifier:@"DemoCell"];
    }
//    cell.contentView.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0f green:arc4random()%255/255.0f blue:arc4random()%255/255.0f alpha:1.0f];
    cell.textLabel.text = [NSString stringWithFormat:@"#%@",dataList[indexPath.row * [waterfallView numberOfColumns] + indexPath.section]];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
    return cell;
}

#pragma mark - DDWaterfallDelegate Methods

- (void)waterfallView:(DDWaterfallView *)waterfallView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath = %@",indexPath);
}

- (CGFloat)waterfallView:(DDWaterfallView *)waterfallView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f + [dataList[indexPath.row * [waterfallView numberOfColumns] + indexPath.section] floatValue];
}

- (void)loadingMoreInWaterfallView:(DDWaterfallView *)waterfallView{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  NSEC_PER_SEC * 1.0f), dispatch_get_main_queue(), ^{
        [self loadData];
    });
}

- (void)loadData{
    int countIndex = (int)dataList.count;
    for (int i = countIndex; i < countIndex + 20; ++i) {
        [dataList addObject:@(i)];
    }
    self.waterfallView.haveMore = YES;
    [self.waterfallView reloadData];
}

@end
