#import "NXWWifiInfo.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation NXWWifiInfo

- (id)fetchSSIDInfo {
    // see http://stackoverflow.com/a/5198968/907720
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    NSDictionary *info;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return info;
}

- (void)getWifiInfo:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *pluginResult = nil;
        NSDictionary *r = [self fetchSSIDInfo];
        NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
        NSString *ssid = [r objectForKey:(id)kCNNetworkInfoKeySSID];
        NSString *bssid = [r objectForKey:(id)kCNNetworkInfoKeyBSSID];
        [result setValue:ssid forKey:@"ssid"];
        [result setValue:bssid forKey:@"bssid"];
        NSError *err;
        NSData *jsonResult = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:&err];
        NSString* resultAsString = [[NSString alloc] initWithData:jsonResult encoding:NSUTF8StringEncoding];
        if (ssid && [ssid length]) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:resultAsString];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"not_available"];
        }

        [self.commandDelegate sendPluginResult:pluginResult
                                    callbackId:command.callbackId];
    }];
}

@end
