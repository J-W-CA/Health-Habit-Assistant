//
//  NewHabitDetailTableViewController.swift
//  WeeklyHabitTracker
//
//  Created by Jason Wang on 7/17/20.
//  Copyright © 2020 Jason Wang. All rights reserved.
//

import UIKit

class HabitDetailTableViewController: UITableViewController {
    private let headerReuseIdentifier = "header"
    private let cellReuseIdentifier = "cell"
    
    private let persistenceManager: PersistenceService
    private weak var habitDelegate: HabitDetailDelegate?
    private var editMode: Bool
    private var habit: Habit!
    
    private var habitTitle: String?
    private var habitDays: [Bool] = [false, false, false, false, false, false, false]
    private var habitColor: Int64?
    private var habitGoal: Int64 = -1
    private var habitTracking: Bool = true
    private var habitPriority: Int64 = 0
    private var habitFlag: Bool = false
    private var habitReminder: Date? = CalUtility.getTimeAsDate(time: "9:00 AM")
    private var habitDateCreated: Date = CalUtility.getCurrentDate()
    
    private let priorityStepper = UIStepper()
    private let flagSwitch = UISwitch()
    
    private let haptics = UISelectionFeedbackGenerator()
    private let regularConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 15, weight: .regular), scale: .default)
    private let largeConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 17), scale: .large)
    private let exclamationAttachment = NSTextAttachment()
    
    // MARK: - Initializers
    init(persistenceManager: PersistenceService, delegate: HabitDetailDelegate, habitToEdit: Habit? = nil) {
        self.persistenceManager = persistenceManager
        self.habitDelegate = delegate
        if let editingHabit = habitToEdit {
            self.habit = editingHabit
            self.editMode = true
            self.habitTitle = editingHabit.title
            self.habitDays = editingHabit.days
            self.habitColor = editingHabit.color
            self.habitGoal = editingHabit.goal
//            self.habitTracking =
            self.habitPriority = editingHabit.priority
            self.habitFlag = editingHabit.flag
            self.habitReminder = editingHabit.reminder
        } else {
            self.editMode = false
        }
        
        self.exclamationAttachment.image = UIImage(named: "exclamationmark", in: nil, with: regularConfig)
        self.exclamationAttachment.image = exclamationAttachment.image?.withTintColor(.secondaryLabel)
        
        super.init(style: .insetGrouped)
        
        configureStepper()
        configureFlagSwitch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("habit detail deinit")
    }
    
    // MARK: - UITableView Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        title = self.editMode ? "Habit Details" : "New Habit"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
        if self.editMode {
            let finButton = UIBarButtonItem(image: UIImage(named: "checkmark"), style: .done, target: self, action: #selector(finishButtonTapped))
            navigationItem.rightBarButtonItems = [saveButton, finButton]
        } else {
            navigationItem.rightBarButtonItems = [saveButton]
        }
        
        tableView.register(HabitDetailHeader.self, forHeaderFooterViewReuseIdentifier: self.headerReuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SectionNumber.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case SectionNumber.firstSection.rawValue: return 300
        default: return 20
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case SectionNumber.secondSection.rawValue: return 50
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case SectionNumber.firstSection.rawValue:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerReuseIdentifier) as! HabitDetailHeader
            header.set(delegate: self)
            if self.editMode {
                header.set(title: self.habit.title)
                header.set(days: self.habit.days)
                header.set(color: self.habit.color)
            }
            return header
        default: return UIView()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let dateCreatedLabel = FormingSecondaryLabel()
        switch section {
        case SectionNumber.secondSection.rawValue:
            if self.editMode {
                dateCreatedLabel.set(text: "Date Created: \(CalUtility.getDateAsString(date: self.habit.dateCreated))")
            } else {
                dateCreatedLabel.set(text: "Date Created: \(CalUtility.getDateAsString(date: CalUtility.getCurrentDate()))")
            }
            return dateCreatedLabel
        default: return UIView()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SectionNumber.firstSection.rawValue: return FirstSection.allCases.count
        default: return SecondSection.allCases.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath)
        cell = UITableViewCell(style: .value1, reuseIdentifier: self.cellReuseIdentifier)
        cell.imageView?.tintColor = .label
        switch indexPath.section {
        case SectionNumber.firstSection.rawValue:
            switch indexPath.row {
            case FirstSection.goals.rawValue:
                cell.textLabel?.text = "Goal"
                cell.imageView?.image = UIImage(named: "star.circle", in: nil, with: self.largeConfig)
                if self.habitGoal > 0 {
                    cell.detailTextLabel?.text = "Complete \(self.habitGoal)"
                } else {
                    cell.detailTextLabel?.text = "Off"
                }
                cell.accessoryType = .disclosureIndicator
            case FirstSection.tracking.rawValue:
                cell.textLabel?.text = "Tracking"
                cell.imageView?.image = UIImage(named: "xmark.circle", in: nil, with: self.largeConfig)
                if self.habitTracking {
                    cell.detailTextLabel?.text = "On"
                } else {
                    cell.detailTextLabel?.text = "Off"
                }
                cell.accessoryType = .disclosureIndicator
            default: ()
            }
        case SectionNumber.secondSection.rawValue:
            switch indexPath.row {
            case SecondSection.reminder.rawValue:
                cell.textLabel?.text = "Reminder"
                if let reminder = self.habitReminder { cell.detailTextLabel?.text = CalUtility.getTimeAsString(time: reminder) }
                else { cell.detailTextLabel?.text = "None" }
                cell.imageView?.image = UIImage(named: "clock", in: nil, with: self.largeConfig)
                cell.accessoryType = .disclosureIndicator
            case SecondSection.priority.rawValue:
                cell.textLabel?.text = "Priority"
                cell.detailTextLabel?.attributedText = createExclamation(fromPriority: self.habitPriority)
                cell.imageView?.image = UIImage(named: "exclamationmark.circle", in: nil, with: self.largeConfig)
                cell.accessoryView = self.priorityStepper
                cell.selectionStyle = .none
            case SecondSection.flag.rawValue:
                cell.textLabel?.text = "Flag"
                cell.imageView?.image = UIImage(named: "flag.circle", in: nil, with: self.largeConfig)
                cell.accessoryView = self.flagSwitch
                cell.selectionStyle = .none
            default: ()
            }
        default: ()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case SectionNumber.firstSection.rawValue:
            switch indexPath.row {
            case FirstSection.goals.rawValue:
                let goalView = GoalsViewController(goal: self.habitGoal, delegate: self, row: .goals, section: .firstSection)
                self.navigationController?.pushViewController(goalView, animated: true)
            case FirstSection.tracking.rawValue: print("tracking")
            default: ()
            }
        case SectionNumber.secondSection.rawValue:
            if indexPath.row == SecondSection.reminder.rawValue {
                let reminderView = ReminderViewController(reminder: self.habitReminder, delegate: self, row: .reminder, section: .secondSection)
                self.navigationController?.pushViewController(reminderView, animated: true)
            }
        default: ()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Configuration Functions
    func configureStepper() {
        priorityStepper.minimumValue = 0
        priorityStepper.maximumValue = 3
        priorityStepper.value = Double(self.habitPriority)
        priorityStepper.addTarget(self, action: #selector(stepperTapped), for: .valueChanged)
    }
    
    func configureFlagSwitch() {
        flagSwitch.isOn = self.habitFlag
        flagSwitch.addTarget(self, action: #selector(flagSwitchTapped), for: .valueChanged)
    }
    
    // MARK: - Functions
    func presentIncompleteAlert() {
        let alert = UIAlertController(title: "Incomplete Habit", message: "Please ensure that you have a color and at least one day selected.", preferredStyle: .alert)
        alert.view.tintColor = .systemGreen
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func createExclamation(fromPriority num: Int64) -> NSAttributedString {
        let attrString = NSMutableAttributedString()
        switch num {
        case 1:
            attrString.append(NSAttributedString(attachment: self.exclamationAttachment))
            attrString.append(NSAttributedString(string: "           "))
        case 2:
            attrString.append(NSAttributedString(attachment: self.exclamationAttachment))
            attrString.append(NSAttributedString(attachment: self.exclamationAttachment))
            attrString.append(NSAttributedString(string: "           "))
        case 3:
            attrString.append(NSAttributedString(attachment: self.exclamationAttachment))
            attrString.append(NSAttributedString(attachment: self.exclamationAttachment))
            attrString.append(NSAttributedString(attachment: self.exclamationAttachment))
            attrString.append(NSAttributedString(string: "           "))
        default:
            attrString.append(NSAttributedString(string: "None"))
        }
        return attrString
    }
    
    func saveHabitData() {
        self.habit.title = self.habitTitle
        self.habit.color = self.habitColor!
        
        if self.editMode {
            if self.habitDays[CalUtility.getCurrentDay()] != self.habit.days[CalUtility.getCurrentDay()] {
                if self.habitDays[CalUtility.getCurrentDay()] { self.habit.buttonState = false }
            }
            
            var deleteNotifications: (Bool, [Bool]) = (false, [])
            var updateNotifications = false
            if self.habitReminder == nil {
                let days = self.habit.days
                deleteNotifications = (true, days)
            } else if (self.habitReminder != self.habit.reminder) || (self.habitDays != self.habit.days ) {
                let days = self.habit.days
                deleteNotifications = (true, days)
                updateNotifications = true
            }
            
            if self.habit.days != self.habitDays {
                var statuses = [Status]()
                for (index, day) in self.habitDays.enumerated() {
                    if day {
                        switch self.habit.statuses[index] {
                        case .completed: statuses.append(.completed)
                        case .failed: statuses.append(.failed)
                        case .incomplete: statuses.append(.incomplete)
                        case .empty: statuses.append(.incomplete)
                        default: ()
                        }
                    } else { statuses.append(.empty) }
                }
                
                for (oldStatus, newStatus) in zip(self.habit.statuses, statuses) {
                    self.habit.archive.updateStats(fromStatus: oldStatus, toStatus: newStatus)
                }
                
                self.habit.days = self.habitDays
                self.habit.statuses = statuses
                self.habit.archive.updateCurrentArchivedHabit(withStatuses: statuses)
            }
            
            self.habit.goal = self.habitGoal
            self.habit.priority = self.habitPriority
            self.habit.reminder = self.habitReminder
            self.habit.flag = self.habitFlag
            
            self.habit.archive.title = self.habit.title ?? ""
            self.habit.archive.color = self.habit.color
            self.habit.archive.flag = self.habit.flag
            self.habit.archive.priority = self.habit.priority
            self.habit.archive.reminder = self.habit.reminder
            self.habit.archive.goal = self.habit.goal
            self.habit.archive.habit = self.habit
            
            self.habitDelegate!.update(habit: self.habit, deleteNotifications: deleteNotifications, updateNotifications: updateNotifications)
        } else {
            self.habit.days = self.habitDays
            var statuses = [Status]()
            for day in self.habit.days {
                if day {
                    statuses.append(.incomplete)
                } else {
                    statuses.append(.empty)
                }
            }
            self.habit.statuses = statuses
            self.habit.goal = self.habitGoal
            self.habit.priority = self.habitPriority
            self.habit.reminder = self.habitReminder
            self.habit.flag = self.habitFlag
            self.habit.dateCreated = CalUtility.getCurrentDate()
            self.habit.buttonState = false
            self.habit.uniqueID = UUID().uuidString
            
            let initialArchive = Archive(context: self.persistenceManager.context)
            initialArchive.title = self.habit.title ?? ""
            initialArchive.color = self.habit.color
            initialArchive.habit = self.habit
            initialArchive.flag = self.habit.flag
            initialArchive.priority = self.habit.priority
            initialArchive.reminder = self.habit.reminder
            initialArchive.goal = self.habit.goal
            initialArchive.active = true
            initialArchive.successRate = 1.0
            initialArchive.completedTotal = 0
            initialArchive.failedTotal = 0
            initialArchive.incompleteTotal = Int64(self.habit.days.filter({ $0 == true }).count)
            initialArchive.currentWeekNumber = 1
            
            initialArchive.createNewArchivedHabit(withStatuses: self.habit.statuses, andDate: CalUtility.getCurrentDate(), andDay: CalUtility.getCurrentDay())
            self.habit.archive = initialArchive
            
            self.habitDelegate!.add(habit: self.habit)
        }
    }
    
    // MARK: - Selectors
    @objc func saveButtonTapped() {
        guard !self.habitDays.allSatisfy( { $0 == false } ), self.habitColor != nil else {
            self.presentIncompleteAlert()
            return
        }
        
        if self.editMode {
            saveHabitData()
        } else {
            self.habit = Habit(context: self.persistenceManager.context)
            saveHabitData()
        }
        
        DispatchQueue.main.async { self.dismiss(animated: true) }
    }
    
    @objc func finishButtonTapped() {
        DispatchQueue.main.async {
            let deleteVC = UIAlertController(title: "Are you sure you want to finish this habit?",
                                             message: "Finishing a habit removes it from Habits and archives it in History.",
                                             preferredStyle: .alert)
            deleteVC.view.tintColor = .systemGreen
            deleteVC.addAction(UIAlertAction(title: "Finish", style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.habitDelegate!.finish(habit: self.habit, confetti: true)
                self.dismiss(animated: true)
            })
            deleteVC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(deleteVC, animated: true)
        }
    }
    
    @objc func cancelButtonTapped() {
        DispatchQueue.main.async { self.dismiss(animated: true) }
    }
    
    @objc func stepperTapped(sender: UIStepper) {
        self.haptics.selectionChanged()
        tableView.cellForRow(at: IndexPath(row: SecondSection.priority.rawValue, section: SectionNumber.secondSection.rawValue))?.detailTextLabel?.attributedText = createExclamation(fromPriority: Int64(sender.value))
        self.habitPriority = Int64(sender.value)
    }
    
    @objc func flagSwitchTapped(sender: UISwitch) {
        self.haptics.selectionChanged()
        self.habitFlag = sender.isOn
    }
}

// MARK: - Delegates
extension HabitDetailTableViewController: HabitDetailHeaderDelegate {
    func send(title: String?) {
        self.habitTitle = title
    }
    
    func send(day: Int, andFlag flag: Bool) {
        self.habitDays[day] = flag
    }
    
    func send(color: Int64?) {
        self.habitColor = color
    }
}

extension HabitDetailTableViewController: HabitDetailTableViewDelegate {
    func update(text: String, data: Any?, atSection section: Int, andRow row: Int) {
        tableView.cellForRow(at: IndexPath(row: row, section: section))?.detailTextLabel?.text = text
        switch section {
        case SectionNumber.firstSection.rawValue:
            switch row {
            case FirstSection.goals.rawValue: self.habitGoal = data as! Int64
            case FirstSection.tracking.rawValue: self.habitTracking = data as! Bool
            default: ()
            }
        case SectionNumber.secondSection.rawValue:
            switch row {
            case SecondSection.reminder.rawValue: self.habitReminder = data as? Date
            default: ()
            }
        default: ()
        }
    }
}

// MARK: - Protocols
protocol HabitDetailDelegate: AnyObject {
    func add(habit: Habit)
    func update(habit: Habit, deleteNotifications: (Bool, [Bool]), updateNotifications: Bool)
    func finish(habit: Habit, confetti: Bool)
}

protocol HabitDetailTableViewDelegate: AnyObject {
    func update(text: String, data: Any?, atSection section: Int, andRow row: Int)
}

// MARK: - Enums
enum SectionNumber: Int, CaseIterable {
    case firstSection, secondSection
}

enum FirstSection: Int, CaseIterable {
    case goals, tracking
}

enum SecondSection: Int, CaseIterable {
    case reminder, priority, flag
}
