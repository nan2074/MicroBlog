//
//  SNStatusCell.h
//  webd
//
//  Created by 普伴 on 15/8/25.
//  Copyright (c) 2015年 Puban. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SNStatusFrame;

@interface SNStatusCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong, nonatomic) SNStatusFrame *statusFrame;

@end
