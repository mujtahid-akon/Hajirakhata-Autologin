//
//  UserInfo.h
//  ArchivingTest
//
//  Created by Mujtahid Akon on 5/12/17.
//  Copyright © 2017 Mujtahid Akon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject<NSCoding>
//@property (nonatomic) BOOL isStored;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSDate * lastLoginDate;

- (void)printData;
+ (void) writeData;
+ (void) writeUsername:(NSString*) username password: (NSString*) password andLastLoginDate: (NSDate *) lastLoginDate ;
+ (UserInfo*) readData;

@end
