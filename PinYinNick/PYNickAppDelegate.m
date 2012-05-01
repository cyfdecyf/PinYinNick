//
//  PYNickAppDelegate.m
//  PinYinNick
//
//  Created by 陈宇飞 on 12-4-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PYNickAppDelegate.h"

@implementation PYNickAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void)awakeFromNib {
    // numberOfRowsInTableView will be called before applicationDidFinishLaunching.
    // So initialization should be done here.
    _ab = [ABAddressBook sharedAddressBook];
    _people = [_ab people];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv {
    NSInteger count = [_people count];
//    NSLog(@"number of rows: %ld", count);
    return count;
}

- (NSString *)formatFullName:(NSInteger)row {
    ABPerson *person = [_people objectAtIndex:row];
    NSString *firstName = [person valueForProperty:kABFirstNameProperty];
    NSString *lastName = [person valueForProperty:kABLastNameProperty];
    NSMutableString *fullName = [[NSMutableString alloc] initWithCapacity:4];
    if (lastName != nil) {
        [fullName appendString:lastName];
    }
    if (firstName != nil) {
        if (lastName == nil)
            [fullName appendString:firstName];
        else
            [fullName appendFormat:@" %@", firstName];
    }
    return fullName;
}

- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row {
//    NSLog(@"%@ %ld", tableColumn, row);
    if ([[tableColumn identifier] isEqualToString:@"fullName"]) {
        return [self formatFullName:row];
    } else {
        return @"";
    }
}

@end
