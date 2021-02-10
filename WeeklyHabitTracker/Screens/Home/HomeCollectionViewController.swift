//
//  HomeCollectionViewController.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 4/14/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

private let reuseIdentifier = "Habit Cell"
private let headerReuseIdentifier = "Header Cell"

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private var habits = [Habit]()
    private let persistenceManager: PersistenceService
    private let defaults: UserDefaults
    private let notificationCenter: NotificationCenter
    private let userNotificationCenter: UNUserNotificationCenter
    private var dataSource: UICollectionViewDiffableDataSource<CVSection, Habit>!
    private var diagnosticsString = String()
    
    private let sortAC = UIAlertController(title: "Sort By:", message: nil, preferredStyle: .actionSheet)
    private let sortKey = "homeSort"
    private var defaultSort: HomeSort = .dateCreated
    
    private let searchController = UISearchController()
    private var filteredHabits = [Habit]()
        
    // MARK: - Initializers
    init(collectionViewLayout layout: UICollectionViewLayout, persistenceManager: PersistenceService, defaults: UserDefaults, userNotifCenter: UNUserNotificationCenter, notifCenter: NotificationCenter) {
        self.persistenceManager = persistenceManager
        self.defaults = defaults
        self.notificationCenter = notifCenter
        self.userNotificationCenter = userNotifCenter
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CollectionView Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        navigationController?.navigationBar.prefersLargeTitles = true
        let newButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newTapped))
        let sortButton = UIBarButtonItem(image: UIImage(named: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(sortButtonTapped))
        navigationItem.rightBarButtonItems = [newButton, sortButton]
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Diagnostics", style: .plain, target: self, action: #selector(diagnostics))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Notifications", style: .plain, target: self, action: #selector(printNofifications))

        if let sort = self.defaults.object(forKey: self.sortKey) { self.defaultSort = HomeSort(rawValue: sort as! String)! }
        collectionView.collectionViewLayout = UIHelper.createHabitsFlowLayout(in: collectionView)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout { layout.sectionHeadersPinToVisibleBounds = true }
        
        self.collectionView.register(HomeHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        self.collectionView.register(HabitCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        configureSearchController()
        configureSortAlertController()
        configureDataSource()
        
        fetchHabits()
                
        // Notifications observers
        self.notificationCenter.addObserver(self, selector: #selector(reloadHabits), name: NSNotification.Name(NotificationName.newDay.rawValue), object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(reloadHabits), name: NSNotification.Name(NotificationName.habits.rawValue), object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(finishFromNotes), name: NSNotification.Name(rawValue: NotificationName.finishHabitFromNotes.rawValue), object: nil)
    }
    
    @objc func printNofifications() {
        self.userNotificationCenter.getPendingNotificationRequests { (requests) in
            requests.forEach { (request) in
                print(request)
            }
        }
    }
    
    @objc func diagnostics() {
        for habit in self.persistenceManager.fetch(Archive.self) {
            self.diagnosticsString.append(habit.stringRepresentation())
        }
        print(self.diagnosticsString)
//        self.userNotificationCenter.getPendingNotificationRequests { [weak self] (requests) in
//            guard let self = self else { return }
//            requests.forEach { (request) in
//                self.diagnosticsString.append(request.description)
//            }
//            DispatchQueue.main.async {
//                let diagnosticsFile = self.getDocumentsDirectory().appendingPathComponent("diagnostics.txt")
//                do {
//                    try self.diagnosticsString.write(to: diagnosticsFile, atomically: true, encoding: String.Encoding.utf8)
//                } catch {
//                    return
//                }
//                let activityController = UIActivityViewController(activityItems: [diagnosticsFile], applicationActivities: nil)
//                self.present(activityController, animated: true)
//                self.diagnosticsString = String()
//            }
//        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    // MARK: - Configuration Functions
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search habits"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    func configureSortAlertController() {
        sortAC.message = "Current sort: \(self.defaultSort.rawValue)"
        sortAC.view.tintColor = .systemGreen
        HomeSort.allCases.forEach { (sort) in
            sortAC.addAction(UIAlertAction(title: sort.rawValue, style: .default, handler: { [weak self] (alert: UIAlertAction) in
                guard let self = self else { return }
                if let sortTitle = alert.title {
                    self.defaultSort = HomeSort(rawValue: sortTitle)!
                    self.defaults.set(self.defaultSort.rawValue, forKey: self.sortKey)
                    self.sortAC.message = "Current sort: \(self.defaultSort.rawValue)"
                    guard !self.habits.isEmpty else { return }
                    self.sortHabits()
                }
            }))
        }
        sortAC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
    
    func configureDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<CVSection, Habit>(collectionView: self.collectionView, cellProvider: { [weak self] (collectionView, indexPath, habit) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HabitCell
            cell.set(delegate: self)
            cell.set(habit: habit)
            return cell
        })
                
        self.dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! HomeHeaderCell
            return header
        }
    }
    
    // MARK: - Functions
    func updateDataSource(on habits: [Habit]) {
        var snapshot = NSDiffableDataSourceSnapshot<CVSection, Habit>()
        if !self.habits.isEmpty {
            snapshot.appendSections([.main])
            snapshot.appendItems(habits)
            DispatchQueue.main.async {
                self.dataSource.apply(snapshot, animatingDifferences: true)
                self.removeEmptyStateView()
            }
        } else {
            snapshot.deleteSections([.main])
            DispatchQueue.main.async {
                self.dataSource.apply(snapshot, animatingDifferences: false)
                self.showEmptyStateView()
            }
        }
    }
    
    func fetchHabits() {
        self.habits = persistenceManager.fetch(Habit.self)
        if !self.habits.isEmpty {
            sortHabits()
        } else {
            updateDataSource(on: self.habits)
        }
    }
    
    func sortHabits() {
        switch self.defaultSort {
        case .alphabetical: self.habits.sort { (hab1, hab2) -> Bool in hab1.title! < hab2.title! }
        case .color: self.habits.sort { (hab1, hab2) -> Bool in hab1.color < hab2.color }
        case .dateCreated: self.habits.sort { (hab1, hab2) -> Bool in print("date created"); return hab1.dateCreated.compare(hab2.dateCreated) == .orderedAscending }
        case .dueToday: self.habits.sort { (hab1, hab2) -> Bool in hab1.statuses[CalUtility.getCurrentDay()] < hab2.statuses[CalUtility.getCurrentDay()] }
        case .flag: self.habits.sort { (hab1, hab2) -> Bool in hab1.flag && !hab2.flag }
        case .priority: self.habits.sort { (hab1, hab2) -> Bool in hab1.priority > hab2.priority }
        case .reminderTime: self.habits.sort { (hab1, hab2) -> Bool in
            let reminder1 = hab1.reminder ?? CalUtility.getFutureDate()
            let reminder2 = hab2.reminder ?? CalUtility.getFutureDate()
            return reminder1.compare(reminder2) == .orderedAscending
            }
        }
        updateDataSource(on: self.habits)
        
        self.notificationCenter.reload(history: true)
    }
    
    // MARK: - Selectors
    @objc func newTapped() {
        let newHabitVC = HabitDetailTableViewController(persistenceManager: self.persistenceManager, delegate: self)
        let navController = UINavigationController(rootViewController: newHabitVC)
        navController.navigationBar.tintColor = .systemGreen
        DispatchQueue.main.async {
            self.present(navController, animated: true)
        }
    }
    
    @objc func sortButtonTapped() {
        present(sortAC, animated: true)
    }
    
    @objc func reloadHabits() {
        fetchHabits()
        DispatchQueue.main.async { self.collectionView.reloadData() }
    }
    
    @objc func finishFromNotes(_ notification: NSNotification) {
        if let habit = notification.userInfo?["habit"] as? Habit {
            finish(habit: habit, confetti: false)
        }
    }
    
}

// MARK: - Delegates
extension HomeCollectionViewController: HabitDetailDelegate {
    func add(habit: Habit) {
        self.userNotificationCenter.createNotificationRequest(forHabit: habit)
        self.persistenceManager.save()
        self.notificationCenter.reload(history: true)
        self.habits.append(habit)
        sortHabits()
    }
    
    func update(habit: Habit, deleteNotifications: (Bool, [Bool]), updateNotifications: Bool) {
        if deleteNotifications.0 { self.userNotificationCenter.deleteNotificationRequests(forDays: deleteNotifications.1, andUniqueID: habit.uniqueID) }
        if updateNotifications { self.userNotificationCenter.createNotificationRequest(forHabit: habit) }
        self.persistenceManager.save()
        self.notificationCenter.reload(history: true, archiveDetail: true, archivedHabitDetail: true)
        var snapshot = self.dataSource.snapshot()
        DispatchQueue.main.async {
            snapshot.reloadItems([habit])
            self.dataSource.apply(snapshot, animatingDifferences: true)
            self.sortHabits()
        }
    }
    
    func finish(habit: Habit, confetti: Bool) {
        self.userNotificationCenter.deleteNotificationRequests(forDays: habit.days, andUniqueID: habit.uniqueID)
        habit.archive.updateActive(toState: false)
        self.persistenceManager.delete(habit)
        self.notificationCenter.reload(history: true)
        if let index = self.habits.firstIndex(of: habit) {
            self.habits.remove(at: index)
            updateDataSource(on: self.habits)
        }
        
        if confetti {
            createAndStartParticles()
        }
    }
}

extension HomeCollectionViewController: HabitCellDelegate {
    func presentNewHabitViewController(with habit: Habit) {
        let editHabitVC = HabitDetailTableViewController(persistenceManager: self.persistenceManager, delegate: self, habitToEdit: habit)
        let navController = UINavigationController(rootViewController: editHabitVC)
        navController.navigationBar.tintColor = .systemGreen
        DispatchQueue.main.async {
            self.present(navController, animated: true)
        }
    }
    
    func checkboxSelectionChanged(atIndex index: Int, forHabit habit: Habit, fromStatus oldStatus: Status, toStatus newStatus: Status, forState state: Bool?) {
        habit.checkBoxPressed(fromStatus: oldStatus, toStatus: newStatus, atIndex: index, withState: state)
        self.persistenceManager.save()
        self.notificationCenter.reload(history: true, archiveDetail: true, archivedHabitDetail: true)
        
        if habit.archive.completedTotal == habit.goal {
            presentGoalReachedViewController(withHabit: habit, andDelegate: self)
        }
        
        // call sort?
    }
    
    func presentAlertController(with alert: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

extension HomeCollectionViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text else { return }
        if filter.isEmpty { updateDataSource(on: self.habits); return }
        
        filteredHabits = self.habits.filter { ($0.title?.lowercased().contains(filter.lowercased()))! }
        updateDataSource(on: filteredHabits)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateDataSource(on: self.habits)
    }
}

extension HomeCollectionViewController: GoalReachedDelegate {
    func finishButtonTapped(forHabit habit: Habit) {
        finish(habit: habit, confetti: false)
    }
    
    func adjustButtonTapped(forHabit habit: Habit) {
        let goalViewController = GoalsViewController(habit: habit, persistenceManager: self.persistenceManager)
        let navController = UINavigationController(rootViewController: goalViewController)
        DispatchQueue.main.async {
            self.present(navController, animated: true)
        }
    }
}
