//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKPageScoreDataSource.h"
#import "VMKSystemView.h"
#import "VMKCursorView.h"

using namespace mxml;

NSString* const VMKSystemReuseIdentifier = @"System";
NSString* const VMKSystemCursorReuseIdentifier = @"Cursor";
NSString* const VMKPageHeaderReuseIdentifier = @"Header";


@implementation VMKPageScoreDataSource

- (instancetype)init {
    self = [super init];
    self.foregroundColor = [UIColor blackColor];
    self.scale = 1;
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    if (!self.scoreGeometry)
        return 0;

    switch (self.cursorStyle) {
        case VMKCursorStyleNone:
            return 1;

        case VMKCursorStyleNote:
        case VMKCursorStyleMeasure:
            return 2;
    }
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == VMKPageScoreSectionSystem)
        return _scoreGeometry->systemGeometries().size();
    else if (section == VMKPageScoreSectionCursor && self.cursorStyle == VMKCursorStyleNote)
        return 1;
    else
        return static_cast<NSInteger>(self.scoreGeometry->scoreProperties().staves());
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section == VMKPageScoreSectionSystem)
        return [self collectionView:collectionView cellForSystemAtIndexPath:indexPath];
    else if (indexPath.section == VMKPageScoreSectionCursor)
        return [self collectionView:collectionView cellForCursorAtIndexPath:indexPath];
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForSystemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:VMKSystemReuseIdentifier forIndexPath:indexPath];
    
    VMKSystemView* systemView;
    if (cell.contentView.subviews.count > 0) {
        systemView = (VMKSystemView*)cell.contentView.subviews[0];
    } else {
        systemView = [[VMKSystemView alloc] init];
        [cell.contentView addSubview:systemView];
    }

    const SystemGeometry* systemGeometry = _scoreGeometry->systemGeometries()[indexPath.item];
    systemView.foregroundColor = self.foregroundColor;
    systemView.systemGeometry = systemGeometry;

    CGRect frame = systemView.frame;
    frame.origin = CGPointZero;
    systemView.frame = frame;
    systemView.transform = CGAffineTransformMakeScale(self.scale, self.scale);
    
    return cell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForCursorAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:VMKSystemCursorReuseIdentifier forIndexPath:indexPath];
    
    VMKCursorView* view;
    if (cell.contentView.subviews.count == 0) {
        view = [[VMKCursorView alloc] initWithFrame:cell.contentView.bounds];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:view];
    } else {
        view = (VMKCursorView*)[cell.contentView.subviews firstObject];
    }
    view.cursorStyle = self.cursorStyle;
    view.color = self.cursorColor;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:VMKPageHeaderReuseIdentifier forIndexPath:indexPath];
    return view;
}

@end
