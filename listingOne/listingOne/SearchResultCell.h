//
//  SearchResultCell.h
//  listingOne
//
//  Created by Alberto Morales on 11/22/13.
//  Copyright (c) 2013 lickmyscreenclean.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel * descriptionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *artworkImageView;

@end
