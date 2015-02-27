//
//  SSCoreTableViewCell.m
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 2/23/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import "SSCoreTableViewCell.h"

@implementation SSCoreTableViewCell

@synthesize core;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
