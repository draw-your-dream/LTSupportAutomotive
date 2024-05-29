//
//  Transporter.h
//  LTSupportAutomotive
//
//  Created by 江志敏 on 2024/5/28.
//  Copyright © 2024 Dr. Lauer Information Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TransporterConnectionBlock)(NSInputStream* _Nullable inputStream, NSOutputStream* _Nullable outputStream);

@protocol LTTransporter <NSObject>

-(void)connectWithBlock:(TransporterConnectionBlock)block;
-(void)disconnect;

@end

NS_ASSUME_NONNULL_END
