//
//  Copyright (c) Dr. Michael Lauer Information Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreBluetooth/CoreBluetooth.h>

#import <LTSupportAutomotive/LTTransporter.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString* const LTBTLESerialTransporterDidUpdateSignalStrength;



@interface LTBTLESerialTransporter : NSObject <LTTransporter, CBCentralManagerDelegate, CBPeripheralDelegate>

@property(strong,nonatomic,readonly) NSNumber* signalStrength;
+(instancetype)transporterWithIdentifier:(nullable NSUUID*)identifier serviceUUIDs:(NSArray<CBUUID*>*)serviceUUIDs;
-(void)startUpdatingSignalStrengthWithInterval:(NSTimeInterval)interval;
-(void)stopUpdatingSignalStrength;

@end

NS_ASSUME_NONNULL_END

