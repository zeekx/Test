//
//  DataViewController.m
//  ADShow
//
//  Created by yubinqiang on 16/3/15.
//  Copyright © 2016年 Zeek. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addKVO];
}

- (void)addKVO {
    [self addObserver:self forKeyPath:@"view.bounds" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"view.frame" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"view.bounds"]) {
        id value = change[NSKeyValueChangeNewKey];
        NSLog(@"%s bounds:%@",__PRETTY_FUNCTION__, value);
    } else if ([keyPath isEqualToString:@"view.frame"]) {
        id value = change[NSKeyValueChangeNewKey];
        NSLog(@"\n%s frame:%@",__PRETTY_FUNCTION__, value);
    }
}

- (void)removeKVO {
    [self removeObserver:self forKeyPath:@"view.bounds"];
    [self removeObserver:self forKeyPath:@"view.frame"];
}

- (void)dealloc {
    [self removeKVO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}

@end
