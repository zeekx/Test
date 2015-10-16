//
//  ViewController.m
//  Timer
//
//  Created by yubinqiang on 15/10/8.
//  Copyright © 2015年 Zeek. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, weak  )  NSTimer *repeatingTimer;
@property (nonatomic, strong)  NSTimer *unregisteredTimer;

@property (nonatomic, assign)  NSUInteger timerCount;
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
#pragma mark - Timer
- (IBAction)startOneOffTimer:(UIButton *)sender {
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(targetMethod:)
                                   userInfo:self.userInfo
                                    repeats:NO];
}

- (IBAction)startRepeatingTimer:(UIButton *)sender{
    [self.repeatingTimer invalidate];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2
                                                      target:self
                                                    selector:@selector(targetMethod:)
                                                    userInfo:self.userInfo
                                                     repeats:YES];
    self.repeatingTimer = timer;
}
- (IBAction)stopRepeatingTimer:(UIButton *)sender{
    [self.repeatingTimer invalidate];
    self.repeatingTimer = nil;
}

- (IBAction)createUnregisteredTimer:(UIButton *)sender{
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:@selector(invocationMethod:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:self];
    [invocation setSelector:@selector(invocationMethod:)];
    NSDate *startDate = [NSDate date];
    [invocation setArgument:&startDate atIndex:2];
    self.unregisteredTimer = [NSTimer timerWithTimeInterval:1 invocation:invocation repeats:YES];
}

- (IBAction)startUnregisteredTimer:(UIButton *)sender{
    if (self.unregisteredTimer != nil) {
        [[NSRunLoop currentRunLoop] addTimer:self.unregisteredTimer
                                     forMode:NSDefaultRunLoopMode];
    }
}

- (IBAction)stopUnregisteredTimer:(UIButton *)sender{
    [self.unregisteredTimer invalidate];
    self.unregisteredTimer = nil;
}



#pragma mark -
- (NSDictionary *)userInfo {
    return @{@"StartDate":[NSDate date]};
}

- (IBAction)startFireDateTimer:(UIButton *)sender {
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:fireDate
                                              interval:0.5
                                                target:self
                                              selector:@selector(countedTimerFireMethod:)
                                              userInfo:self.userInfo
                                               repeats:YES];
    self.timerCount = 1;
    [[NSRunLoop currentRunLoop] addTimer:timer
                                 forMode:NSDefaultRunLoopMode];
}

- (void)targetMethod:(NSTimer*)theTimer {
    NSDictionary *userInfo = theTimer.userInfo;
    NSLog(@"%s Time stared on %@",__PRETTY_FUNCTION__,userInfo[@"StartDate"]);
}

- (void)invocationMethod:(NSDate *)date{
    NSLog(@"%s started on %@",__PRETTY_FUNCTION__,date);
}

- (void)countedTimerFireMethod:(NSTimer*)theTimer{
    NSLog(@"%s start at:%@ time count:%@",__PRETTY_FUNCTION__,theTimer.userInfo[@"StartDate"],@(self.timerCount++).stringValue);
    if (self.timerCount > 3) {
        [theTimer invalidate];
    }
}

#pragma mark - Stop
- (IBAction)stopTimer:(id)sender {
    [self stopRepeatingTimer:sender];
    [self stopUnregisteredTimer:sender];
}
@end
