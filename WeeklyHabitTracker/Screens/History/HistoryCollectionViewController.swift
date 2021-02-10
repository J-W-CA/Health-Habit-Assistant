//
//  HistoryCollectionViewController.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 4/14/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

private let reuseIdentifier = "History Title Cell"
private let sectionReuseIdentifier = "History Section Header"

class HistoryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private var archives: [Archive] = []
    private var activeArchives: [Archive] = []
    private var finishedArchives: [Archive] = []
    private var activeArchivesCount: Int = 0
    private var finishedArchivesCount: Int = 0
    private let persistenceManager: PersistenceService
    private let defaults: UserDefaults
    private let notificationCenter: NotificationCenter
    private let userNotificationCenter: UNUserNotificationCenter
    private var dataSource: UICollectionViewDiffableDataSource<HistorySection, Archive>?
    
    private var isActiveCollapsed: Bool = false
    private var isFinishedCollapsed: Bool = false
    private let activeCollapsedKey = "isActiveCollapsed"
    private let finishedCollapsedKey = "isFinishedCallapsed"
    
    private let searchController = UISearchController()
    private var filteredArchives: [Archive] = []
    private var firstSearchCancelled = false
    private var secondSearchCancelled = false
    
    // MARK: - Initializers
    init(collectionViewLayout layout: UICollectionViewLayout, persistenceManager: PersistenceService, defaults: UserDefaults, notifCenter: NotificationCenter, userNotifCenter: UNUserNotificationCenter) {
        self.persistenceManager = persistenceManager
        self.defaults = defaults
        self.notificationCenter = notifCenter
        self.userNotificationCenter = userNotifCenter

        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("history deinit")
    }
    
    // MARK: - CollectionView Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.collectionViewLayout = UIHelper.createHistoryFlowLayout(in: collectionView)

        self.collectionView.register(HistoryTitleCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(HistorySectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionReuseIdentifier)
        
        configureSearchController()
        configureDataSource()
        
        if let activeCollapsed = self.defaults.object(forKey: self.activeCollapsedKey) as? Bool { self.isActiveCollapsed = activeCollapsed }
        if let finishedCollapsed = self.defaults.object(forKey: self.finishedCollapsedKey) as? Bool { self.isFinishedCollapsed = finishedCollapsed }
        
        fetchArchives()
        
        // Notification oberservers
        self.notificationCenter.addObserver(self, selector: #selector(reloadArchives), name: NSNotification.Name(NotificationName.newDay.rawValue), object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(reloadArchives), name: NSNotification.Name(NotificationName.history.rawValue), object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 30)
    }
    
    // MARK: - Configuration Functions
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search archives"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    func configureDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<HistorySection, Archive>(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, archive) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? HistoryTitleCell
            cell?.set(title: archive.title)
            cell?.set(color: FormingColors.getColor(fromValue: archive.color))
            
            let goal = archive.goal
            let goalRate: CGFloat? = goal == -1 ? nil : CGFloat(archive.completedTotal) / CGFloat(goal)
            let goalText: String? = goalRate == nil ? nil : (goalRate == 1.0 ? String(format: "%.0f%%", goalRate! * 100) : String(format: "%.1f%%", goalRate! * 100))
            cell?.set(completionRate: archive.successRate,
                      compRateText: archive.successRate == 1.0 ? String(format: "%.0f%%", archive.successRate * 100) : String(format: "%.1f%%", archive.successRate * 100),
                      goalRate: goalRate,
                      goalRateText: goalText)
            
            return cell
        })
        
        self.dataSource?.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionReuseIdentifier, for: indexPath) as? HistorySectionHeader
            switch indexPath.section {
            case 0:
                switch self.activeArchivesCount {
                case 1: header?.set(title: "Active Habit", andCount: 1)
                default: header?.set(title: "Active Habits", andCount: self.activeArchivesCount)
                }
                header?.set(section: .activeHabits)
                header?.set(buttonState: self.isActiveCollapsed)
            case 1:
                switch self.finishedArchivesCount {
                case 1: header?.set(title: "Finished Habit", andCount: 1)
                default: header?.set(title: "Finished Habits", andCount: self.finishedArchivesCount)
                }
                header?.set(section: .finishedHabits)
                header?.set(buttonState: self.isFinishedCollapsed)
            default: header?.set(title: "Error", andCount: -1)
            }
            header?.set(delegate: self)
            header?.set(notificationCenter: self.notificationCenter)
            return header
        }
    }

    // MARK: CollectionView Functions
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let archive = self.dataSource?.itemIdentifier(for: indexPath) else { print("selection error"); return }
        let archiveDetailVC = ArchiveDetailCollectionViewController(persistenceManager: self.persistenceManager, defaults: self.defaults, notifCenter: self.notificationCenter, archive: archive, delegate: self)
        navigationController?.pushViewController(archiveDetailVC, animated: true)
    }
    
    // MARK: - Functions
    func fetchArchives() {
        self.archives = persistenceManager.fetch(Archive.self)
        updateDataSource(on: self.archives, isActiveCollapsed: self.isActiveCollapsed, isFinishedCollapsed: self.isFinishedCollapsed)
    }
    
    func updateDataSource(on archives: [Archive], isActiveCollapsed: Bool, isFinishedCollapsed: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<HistorySection, Archive>()
        if !self.archives.isEmpty {
            if isActiveCollapsed {
                self.activeArchivesCount = archives.filter( { $0.active == true } ).count
                self.activeArchives.removeAll()
            } else {
                self.activeArchives = archives.filter( { $0.active == true } )
//                self.activeArchives.sort { (archive1, archive2) -> Bool in archive1.title < archive2.title}
                if let sorting = self.defaults.object(forKey: "homeSort") {
                    if let homeSort = HomeSort(rawValue: sorting as! String) {
                        sort(by: homeSort, on: &self.activeArchives)
                    } else {
                        sort(by: .alphabetical, on: &self.activeArchives)
                    }
                } else {
                    sort(by: .alphabetical, on: &self.activeArchives)
                }
                self.activeArchivesCount = self.activeArchives.count
            }
            if isFinishedCollapsed {
                self.finishedArchivesCount = archives.filter( { $0.active == false } ).count
                self.finishedArchives.removeAll()
            } else {
                self.finishedArchives = archives.filter( { $0.active == false } )
                self.finishedArchives.sort { (archive1, archive2) -> Bool in archive1.title < archive2.title}
                self.finishedArchivesCount = self.finishedArchives.count
            }
            
            snapshot.appendSections([.activeHabits, .finishedHabits])
            snapshot.appendItems(self.activeArchives, toSection: .activeHabits)
            snapshot.appendItems(self.finishedArchives, toSection: .finishedHabits)
            DispatchQueue.main.async {
                self.dataSource?.apply(snapshot, animatingDifferences: true)
                self.removeEmptyStateView()
            }
        } else {
            snapshot.deleteSections([.activeHabits, .finishedHabits])
            DispatchQueue.main.async {
                self.dataSource?.apply(snapshot, animatingDifferences: false)
                self.showEmptyStateView(withText: "To start recording habit history, create a new habit.")
            }
        }
    }
    
    func sort(by sort: HomeSort, on array: inout [Archive]) {
        switch sort {
        case .alphabetical: array.sort { (archive1, archive2) -> Bool in archive1.title < archive2.title }
        case .color: array.sort { (archive1, archive2) -> Bool in archive1.color < archive2.color }
        case .dateCreated: array.sort { (archive1, archive2) -> Bool in archive1.habit.dateCreated.compare(archive2.habit.dateCreated) == .orderedAscending }
        case .dueToday: array.sort { (archive1, archive2) -> Bool in archive1.habit.statuses[CalUtility.getCurrentDay()] < archive2.habit.statuses[CalUtility.getCurrentDay()] }
        case .flag: array.sort { (archive1, archive2) -> Bool in archive1.flag && !archive2.flag }
        case .priority: array.sort { (archive1, archive2) -> Bool in archive1.priority > archive2.priority }
        case .reminderTime: array.sort { (archive1, archive2) -> Bool in
            let reminder1 = archive1.reminder ?? CalUtility.getFutureDate()
            let reminder2 = archive2.reminder ?? CalUtility.getFutureDate()
            return reminder1.compare(reminder2) == .orderedAscending
            }
        }
    }
    
    // MARK: - Selectors
    @objc func reloadArchives() {
//        fetchArchives()
//        DispatchQueue.main.async { self.collectionView.reloadData() }
        DispatchQueue.main.async {
            self.configureDataSource()
            self.fetchArchives()
        }
    }
}

// MARK: - Delegates
extension HistoryCollectionViewController: ArchiveDetailDelegate {
    func delete(archive: Archive) {
        self.userNotificationCenter.deleteNotificationRequests(forDays: archive.habit.days, andUniqueID: archive.habit.uniqueID)
        self.persistenceManager.delete(archive)
        if let index = self.archives.firstIndex(of: archive) {
            self.archives.remove(at: index)
            self.notificationCenter.reload(habits: true, history: true)
        }
    }

    func reset(archive: Archive) {
        archive.reset()
        self.persistenceManager.save()
        self.notificationCenter.reload(habits: true, history: true, archiveDetail: true)
    }

    func restore(archive: Archive) {
        archive.restore()
        self.persistenceManager.save()
        self.userNotificationCenter.createNotificationRequest(forHabit: archive.habit)
        self.notificationCenter.reload(habits: true, history: true)
    }
}

extension HistoryCollectionViewController: CollapsibleHeaderDelegate {
    func collapseOrExpand(action collapse: Bool, atSection section: HistorySection) {
        if collapse {
            switch section {
            case .activeHabits:
                self.isActiveCollapsed = true
                self.defaults.set(self.isActiveCollapsed, forKey: self.activeCollapsedKey)
                updateDataSource(on: self.archives, isActiveCollapsed: self.isActiveCollapsed, isFinishedCollapsed: self.isFinishedCollapsed)
            case .finishedHabits:
                self.isFinishedCollapsed = true
                self.defaults.set(self.isFinishedCollapsed, forKey: self.finishedCollapsedKey)
                updateDataSource(on: self.archives, isActiveCollapsed: self.isActiveCollapsed, isFinishedCollapsed: self.isFinishedCollapsed)
            }
        } else {
            switch section {
            case .activeHabits:
                self.isActiveCollapsed = false
                self.defaults.set(self.isActiveCollapsed, forKey: self.activeCollapsedKey)
            case .finishedHabits:
                self.isFinishedCollapsed = false
                self.defaults.set(self.isFinishedCollapsed, forKey: self.finishedCollapsedKey)
            }
            updateDataSource(on: self.archives, isActiveCollapsed: self.isActiveCollapsed, isFinishedCollapsed: self.isFinishedCollapsed)
        }
    }
}

extension HistoryCollectionViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard !self.secondSearchCancelled else {
            self.firstSearchCancelled = false; self.secondSearchCancelled = false
            self.notificationCenter.post(name: NSNotification.Name(NotificationName.historyStoppedSearching.rawValue), object: nil)
            return
        }
        
        guard let filter = searchController.searchBar.text else { return }
        self.notificationCenter.post(name: NSNotification.Name(NotificationName.historyStartedSearching.rawValue), object: nil)
        if filter.isEmpty {
            if self.firstSearchCancelled {
                updateDataSource(on: self.archives, isActiveCollapsed: self.isActiveCollapsed, isFinishedCollapsed: self.isFinishedCollapsed)
                self.secondSearchCancelled = true
            } else {
                updateDataSource(on: self.archives, isActiveCollapsed: false, isFinishedCollapsed: false)
            }
            return
        }
        
        self.filteredArchives = self.archives.filter { ($0.title.lowercased().contains(filter.lowercased())) }
        updateDataSource(on: self.filteredArchives, isActiveCollapsed: false, isFinishedCollapsed: false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.firstSearchCancelled = true
        updateDataSource(on: self.archives, isActiveCollapsed: self.isActiveCollapsed, isFinishedCollapsed: self.isFinishedCollapsed)
    }
}
