//
//  UIHelper.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 5/5/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

struct UIHelper {
    static func createHistoryFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
//        let width = view.bounds.width
//        let padding: CGFloat = 20
//        let minimumItemSpacing: CGFloat = 15
//        let availableWidth = width - (padding * 2) - minimumItemSpacing
//        let itemWidth = availableWidth / 2
//
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: padding, bottom: padding, right: padding)
//        flowLayout.itemSize = CGSize(width: itemWidth, height: 105)
//        flowLayout.minimumLineSpacing = 15
//        return flowLayout
        
        let width = view.bounds.width
        let padding: CGFloat = 20
        let availableWidth = width - (padding * 2)
        let itemWidth = availableWidth
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 90)
        flowLayout.minimumLineSpacing = 15
        return flowLayout
    }
    
    static func createHabitsFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 15
        let minimumItemSpacing: CGFloat = 15
        let availableWidth = width - padding - minimumItemSpacing
        let itemWidth = availableWidth
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 90)
        flowLayout.minimumLineSpacing = 15
        return flowLayout
    }
}
