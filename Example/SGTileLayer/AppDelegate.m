//
//  com.southgis.SGTileLayerAppDelegate.m
//  SGTileLayer
//
//  Created by 吴小星 on 08/23/2016.
//  Copyright (c) 2016 吴小星. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[MainViewController alloc]init]];
    [self.window makeKeyAndVisible];
    NSLog(NSHomeDirectory());
//    NSMutableURLRequest *urlR = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://t0.tianditu.com/vec_c/wmts?service=wmts&request=gettile&version=1.0.0&layer=vec&format=tiles&tilematrixset=c&tilecol=106&tilerow=21&tilematrix=7"]];
//    [urlR setValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
//    
//    [[[NSURLSession sharedSession] dataTaskWithRequest:urlR completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"%@", response);
//    }] resume];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
