//
//  SSGroupTableViewCell.m
//  SmartSwitchiOS
//
//  Created by Jacob Simon on 3/23/15.
//  Copyright (c) 2015 Guo. All rights reserved.
//

#import "SSGroupTableViewCell.h"

@implementation SSGroupTableViewCell

@synthesize onView;
@synthesize nameLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIColor *backgroundColor = onView.backgroundColor;
    [super setSelected:selected animated:animated];
    onView.backgroundColor = backgroundColor;

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted {
    UIColor *backgroundColor = onView.backgroundColor;
    [super setHighlighted:highlighted];
    onView.backgroundColor = backgroundColor;
}
@end
