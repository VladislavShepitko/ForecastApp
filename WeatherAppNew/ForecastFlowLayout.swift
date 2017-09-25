//
//  ForecastFlowLayout.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/9/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class ForecastFlowLayout: UICollectionViewFlowLayout {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.sectionHeadersPinToVisibleBounds = true
    }
    
    /*
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
    }*/
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
        
        attributes?.alpha = 0
        
        return attributes
    }
}
/*
// These layout attributes are applied to a cell that is "appearing" and will be eased into the nominal layout attributes for that cell
// Cells "appear" in several cases:
//  - Inserted explicitly or via a section insert
//  - Moved as a result of an insert at a lower index path
//  - Result of an animated bounds change repositioning cells
- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];

if (!self.isBoring)
{
if ([self.insertedIndexPaths containsObject:itemIndexPath])
{
// If this is a newly inserted item, make it grow into place from its nominal index path
attributes = [[self.currentCellAttributes objectForKey:itemIndexPath] copy];
attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
}
else if ([self.insertedSectionIndices containsObject:@(itemIndexPath.section)])
{
// if it's part of a new section, fly it in from the left
attributes = [[self.currentCellAttributes objectForKey:itemIndexPath] copy];
attributes.transform3D = CATransform3DMakeTranslation(-self.collectionView.bounds.size.width, 0, 0);
}

}
return attributes;
}

// These layout attributes are applied to a cell that is "disappearing" and will be eased to from the nominal layout attribues prior to disappearing
// Cells "disappear" in several cases:
//  - Removed explicitly or via a section removal
//  - Moved as a result of a removal at a lower index path
//  - Result of an animated bounds change repositioning cells
- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];

if (!self.isBoring)
{

if ([self.removedIndexPaths containsObject:itemIndexPath] || [self.removedSectionIndices containsObject:@(itemIndexPath.section)])
{
// Make it fall off the screen with a slight rotation
attributes = [[self.cachedCellAttributes objectForKey:itemIndexPath] copy];
CATransform3D transform = CATransform3DMakeTranslation(0, self.collectionView.bounds.size.height, 0);
transform = CATransform3DRotate(transform, M_PI*0.2, 0, 0, 1);
attributes.transform3D = transform;
attributes.alpha = 0.0f;
}
}
return attributes;
}


*/