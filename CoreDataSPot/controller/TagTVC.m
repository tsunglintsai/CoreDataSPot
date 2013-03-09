//
//  TagTVC.m
//  SPoT
//
//  Created by Henry on 2/24/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import "TagTVC.h"
#import "Tag.h"

@interface TagTVC ()
@end

@implementation TagTVC

- (void) awakeFromNib{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tagList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"TagCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[self titleForRow:indexPath.row]capitalizedString];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    return cell;
}

- (NSString*) titleForRow:(NSUInteger)row{
    return [[self.tagList objectAtIndex:row]tagName];
}

- (NSString *) subtitleForRow:(NSUInteger)row{
    Tag *tag = [self.tagList objectAtIndex:row];
    return [@[ @([tag.photos count]) , [tag.photos count] > 1 ? @"photos":@"photo"] componentsJoinedByString:@" "];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Push To Photo List"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setPhotos:)]) {
                    NSArray *photos = [[[self.tagList objectAtIndex:indexPath.row]photos]allObjects];
                    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)];
                    photos = [photos sortedArrayUsingDescriptors:@[descriptor]];
                    [segue.destinationViewController performSelector:@selector(setPhotos:) withObject:photos];
                    [segue.destinationViewController setTitle:[[self titleForRow:indexPath.row]capitalizedString]];
                }
            }
        }
    }
}
@end
