//
//  CollectionViewControllerExt.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 4/28/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

extension UICollectionViewController {
    func showEmptyStateView(withText text: String? = nil) {
        DispatchQueue.main.async {
            let emptyStateView = EmptyStateView(message: text, frame: CGRect(x: 0, y: 0, width: self.collectionView.bounds.size.width, height: self.collectionView.bounds.size.height))
            self.collectionView.backgroundView = emptyStateView
            self.navigationItem.searchController?.searchBar.isHidden = true
            self.collectionView.alwaysBounceVertical = false
        }
    }

    func removeEmptyStateView() {
        DispatchQueue.main.async {
            self.collectionView.backgroundView = nil
            self.navigationItem.searchController?.searchBar.isHidden = false
            self.collectionView.alwaysBounceVertical = true
        }
    }
}
