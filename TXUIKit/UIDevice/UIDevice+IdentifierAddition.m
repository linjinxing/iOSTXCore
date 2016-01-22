//
//  UIDevice(Identifier).m
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//


#import "UIDevice+IdentifierAddition.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

static NSString *kSSToolkitTestsServiceName = @"LJX.com.DEVICEID";
static NSString *kSSToolkitTestsAccountName = @"LJXDeviceID";

@interface UIDevice(Private)

- (NSString *) macaddress;

@end

@implementation UIDevice (IdentifierAddition)

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
- (NSString *) macaddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    //NSLog(@"outstring:%@\n", outstring);
    return outstring;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public Methods

+ (NSString *) uniqueDeviceIdentifier{
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    //NSLog(@"bundleIdentifier:%@\n", bundleIdentifier);    
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,bundleIdentifier];
    NSString *uniqueIdentifier = stringToHash.md5Hash;
    
    return uniqueIdentifier;
}

- (NSString *) uniqueGlobalDeviceIdentifier{
	return nil;
//	
//        NSString *identifier = [SSKeychain passwordForService:kSSToolkitTestsServiceName account:kSSToolkitTestsAccountName];
//        
//        //1、尝试获取钥匙串中的值。钥匙串中的值可能是升级系统前获取到的mac地址，也可能是首次安装后自动生成的随机串
//        if (identifier != nil && [identifier length] > 0) {
//            return identifier;
//        }
//        
//        //2、尝试获取mac地址，若成功则返回mac地址
//        if ([LJXSystem OSVersion] < 7.0) {
//            NSString *macAddress = [self macaddress];
//            if (macAddress != nil && ![macAddress isEqualToString:@"020000000000"]) {
//                [SSKeychain setPassword:macAddress forService:kSSToolkitTestsServiceName account:kSSToolkitTestsAccountName];
//                return macAddress;
//            }
//        }
//    
//        //3、如果钥匙串中的地址也获取不到，就重新生成一个值（identifierForVendor）返回，并将该值记录到钥匙串中
//        identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//        identifier = [[identifier lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        [SSKeychain setPassword:identifier forService:kSSToolkitTestsServiceName account:kSSToolkitTestsAccountName];
//        return identifier;
}

@end
