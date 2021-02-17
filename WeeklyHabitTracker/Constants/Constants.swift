import UIKit

// MARK: Asserts
struct Asserts {
    // Tab Bar
    static let plusSquare = UIImage(systemName: "plus.square.on.square")!
    static let plusSquareFill = UIImage(systemName: "plus.square.on.square.fill")!
    static let house = UIImage(systemName: "house")!
    static let houseFill = UIImage(systemName: "house.fill")!
    static let star = UIImage(systemName: "star")!
    static let starFill = UIImage(systemName: "star.fill")!
    
    // Screens
    static let personOnBicycle = UIImage(named: "person_on_bicycle")!
    static let circle = UIImage(named: "circle")!
    static let personOnScooter = UIImage(named: "person_on_scooter")!
    
    // Common
    static let placeHolder = UIImage(named: "placeholder")!
}


// MARK: Strings
struct Strings {
    // Get Started Screen
    static let areYouReady = "Are you ready?\nNow we gonna build your\n morning routine!"
    static let itsTimeToBuild = "It's time to build\n"
    static let someHabits = "some habits!"
    
    // User Details Screen
    static let nameQuestion = "Okay firstly,\nhow can I call you?"
    static let enterYourName = "Enter your name"
    
    // Make Habbits Screen
    static let create = "Create"
    static let nameYourHabbit = "Name your habit:"
    static let buildOrQuitHabbit = "Build or Quit this habit?"
    static let howManyDays = "How many days you have been doing this?"
    static let oneDay = "1 Day"
    static let setYourGoal = "Set your goal:"
    static let one = "1"
    static let moreTimesPerDay = "Or more times per day"
    static let days = "Days"
    
    // Home Screen
    static let home = "Home"
    
    // Habit Details Screen
    static let habit = "Habit"
    static let habitType = "Habit Type"
    static let numberOfDays = "Number of Days"
    static let goal = "Goal"
    
    // Life Styles Screen
    static let lifestyles = "Lifestyles"
    
    // Common
    static let successful = "Successful"
    static let failed = "Failed"
    static let congradulations = "Congradulations"
    static let youHaveNewLifeStyleNow = "You have a new lifestyle now 🏆🏆🏆"
    static let empty = ""
    static let somethingWentWrong = "Something went wrong"
    static let habitSavedSuccessfully = "Habit saved successfully"
    static let habitUpdatedSuccessfully = "Habit updated successfully"
    static let unableToCompleteRequest = "Unable to complete request"
    static let doYouWantToDeleteThisHabit = "Do you want to delete this habit?"
    static let youCannotUndoThisAction = "You can not undo this action"
    static let habitDeletedSuccessfully = "Habit deleted successfully"
    
    // Empty State
    static let noHabitYet = "No habits yet?\nGo and make some habits"
    static let noLifestylesYet = "Lets make some habits into lifestyles"

    // Buttons
    static let ok = "Ok"
    static let back = "Back"
    static let continueString = "Continue"
    static let build = "Build"
    static let quit = "Quit"
    static let save = "Save"
    static let update = "Update"
    static let delete = "Delete"
    static let cancel = "Cancel"
}


// MARK: Globle Constants
struct GlobalConstants {
    static let charactorLimit = 15
    static let lifeStyleDays = 66
}


// MARK: Global Dimensions
struct GlobalDimensions {
    static let height: CGFloat = 50
    static let cornerRadius: CGFloat = height / 2
    static let borderWidth: CGFloat = 0.5
}


// MARK: Fonts
struct Fonts {
    static let avenirNext = "Avenir Next"
}
