//
//  AppStoreExAppDelegate.m
//  PamilChat
//
//  Created by Pamin IOS Team on 2013/12/15.
//  Copyright (c) 2013年 Pamil. All rights reserved.
//

#import "AppStoreExAppDelegate.h"

@implementation AppStoreExAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions");
    // Override point for customization after application launch.
    
    // 알림
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeSound];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"applicationWillResignActive");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"applicationWillTerminate");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"LOGIN_ID"];

}

// 알림 키
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // UUID와 Token은 사용자의 동의를 얻은 후 외부로 보내져야만 하며 이를 어길시 리젝사유가 될 수 있음
    NSLog(@"Device Token:%@", deviceToken);
    
    // 다른 뷰에 전달하기 위한 사전 작업
    NSString *tokenString = [deviceToken description];
    tokenString = [tokenString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    tokenString = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:@"DEVICE_TOKEN"];
    
    // 각종 정보 수집
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    
    NSString *pushBadge = @"disabled";
    NSString *pushAlert = @"disabled";
    NSString *pushSound = @"disabled";
    
    if (rntypes == UIRemoteNotificationTypeBadge) {
        pushBadge = @"enabled";
    }
    
    else if (rntypes == UIRemoteNotificationTypeAlert) {
        pushAlert = @"enabled";
    }

    else if (rntypes == UIRemoteNotificationTypeSound) {
        pushSound = @"enabled";
    }
    
    else if (rntypes == (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)) {
        pushAlert = @"enabled";
        pushBadge = @"enabled";
    }
    
    else if (rntypes == (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)) {
        pushBadge = @"enabled";
        pushSound = @"enabled";
    }
    
    else if (rntypes == (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)) {
        pushAlert = @"enabled";
        pushSound = @"enabled";
    }
    
    else if (rntypes == (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)) {
        pushBadge = @"enabled";
        pushAlert = @"enabled";
        pushSound = @"enabled";
    }
    
    UIDevice *dev = [UIDevice currentDevice];
    NSUUID *vendorUUID = [UIDevice currentDevice].identifierForVendor;
    NSString *deviceUuid = vendorUUID.UUIDString;
    //NSString *deviceUuid = [self uniqueDeviceIdentifier];
    NSString *deviceName = dev.name;
    NSString *deviceModel = dev.model;
    NSString *deviceSystemVersion = dev.systemVersion;
    
    NSString *devToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Build URL String for Registration
    NSString *host = @"qnibus1.godo.co.kr";
    NSString *urlString = [@"/apns/apns.php?" stringByAppendingString:@"task=register"];
    urlString = [urlString stringByAppendingFormat:@"&appname=%@", appName];
    urlString = [urlString stringByAppendingFormat:@"&appversion=%@", appVersion];
    urlString = [urlString stringByAppendingFormat:@"&deviceuid=%@", deviceUuid];
    urlString = [urlString stringByAppendingFormat:@"&devicetoken=%@", devToken];
    urlString = [urlString stringByAppendingFormat:@"&devicename=%@", deviceName];
    urlString = [urlString stringByAppendingFormat:@"&devicemodel=%@", deviceModel];
    urlString = [urlString stringByAppendingFormat:@"&deviceversion=%@", deviceSystemVersion];
    urlString = [urlString stringByAppendingFormat:@"&pushbadge=%@", pushBadge];
    urlString = [urlString stringByAppendingFormat:@"&pushalert=%@", pushAlert];
    urlString = [urlString stringByAppendingFormat:@"&pushsound=%@", pushSound];
    
    // Register the Device Data
    
    NSURL *url = [[NSURL alloc] initWithScheme:@"http" host:host path:urlString];
    /*
     // TODO 安: 서버전송 수정할 것
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
     */
    NSLog(@"Register URL: %@", url);
    //NSLog(@"Return Data: %@", returnData);

}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)err{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError. (%@)", err);
}

// 알림 표시
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification");
    
    int newCount = [userInfo[@"aps"][@"badge"] intValue];
    
    // 히스토리 버튼의 뱃지 카운트를 증가시켜준다.
    /*
    NSDictionary *infoToObject = [NSDictionary dictionaryWithObjectsAndKeys:[@(newCount) stringValue], @"newCount", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_HISTORY_STATUS" object:nil userInfo:infoToObject];
    */
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_BADGE" object:nil userInfo:nil];
    
    // 어플 아이콘의 뱃지 카운트를 갱신
    [UIApplication sharedApplication].applicationIconBadgeNumber = newCount;
    
    // 알림 팝업창을 표시한다.
    NSString *from = userInfo[@"from"];
    //NSString *string = [NSString stringWithFormat:@"%@からメッセージが届きました", from];
    NSString *string = @"新しいメッセージが届きました";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:string delegate:nil
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
