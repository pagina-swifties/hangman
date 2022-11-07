import Foundation

// Main Code
/// Holds the list of all users
let users = getUsers(filename: "users.txt")
/// Holds the list of all words available
let words = getWords(filename: "words.txt")

print("Enter username: ", terminator: "")

/// Holds the username of the User
let username: String = readLine()!

print("Enter password: ", terminator: "")

/// Holds the password of the user
let password: String = readLine()!

// Authenticate user
/// Holds the login status
let loginSuccessful: Bool = login(username: username, password: password)
if !loginSuccessful {
    print("Login failed :(")
    // Stop running
    exit(0)
}

print("Login successful!\n")

/// Holds the current user
var currentUser = User(username: username, password: password)
/// Holds the current word to be guessed
var currentWord = getNewWord(words: words)

/// Holds the list of words already guessed
var guessedWordArray = Array(repeating: "_", count: currentWord.count)
/// Holds the incomplete word being guessed by the player
var guessedWord = guessedWordArray.joined(separator: "")
/// Holds the list of guessed letters
var guessedLetters: [Character] = []

// print("Word: \(currentWord)")
print("Word: \(guessedWord)\n")
print("--------------------------------------------------------------------------------------------------\n")

while (currentUser.lives! != 0) { // Run while player still has lives left
    let input = readCharacter()

    if guessedLetters.contains(input) { // Skip iteration if player already guessed the letter
        print("You already guessed that letter!\n")
        continue
    }

    // Add input to guessedLetters
    guessedLetters.append(input)

    if guessLetter(letter: input, word: currentWord) { // If player guess is correct
        let indices = getIndicesOfLetter(letter: input, word: currentWord)
        for i in indices {
            guessedWordArray[i] = String(input) // Replace "_" with letter at the indices
        }
        guessedWord = guessedWordArray.joined(separator: "") // Join the guessedWordArray
        print("You guessed a letter!\nYour formed word: \(guessedWord).\nLives left:       \(currentUser.lives!)")

        if guessedWord == currentWord { // If player guessed the word
            print("You guessed the word!\n")

            // Get new word to guess
            currentWord = getNewWord(words: words)

            // Reset variables
            guessedWordArray = Array(repeating: "_", count: currentWord.count)
            guessedWord = guessedWordArray.joined(separator: "")
            guessedLetters = []

            // print("New word: \(currentWord)")
            print("New word: \(guessedWord)")
        }
    } else {
        currentUser.lives! -= 1
        print("Wrong guess!\nLives left:       \(currentUser.lives!)")
    }

    print()
    print("--------------------------------------------------------------------------------------------------\n")
}
print("Game over! You lost all your lives.")

// Functions

/// Get the list of words
///
/// - Parameter filename: The filename of the file to be read
///
/// - Returns: A list of words
func getWords(filename: String) -> [String] {
    var words: [String] = []
    do {
        let file = try String(contentsOfFile: filename) // Read contents of file
        let lines = file.components(separatedBy: "\n") // Split the file using the specified delimiter
        for word in lines { // Iterate through every line
            let w = word.replacingOccurrences(of: "\r", with: "") // Replace all instances of "\r" with an empty space
            words.append(w) // Add "w" to words array
        }
    }
    catch {
        print(error.localizedDescription) // Print error description
        return [] // Return empty array
    }
    return words
}

/**
Get list of users

 - Parameter filename: The filename of the file to be read

 - Returns: A list of users
*/
func getUsers(filename: String) -> [User] {
    var users: [User] = []
    do {
        let file = try String(contentsOfFile: filename) // Read contents of file
        let lines = file.components(separatedBy: "\n") // Split the file using the specified delimiter
        for line in lines { // Iterate through every line
            let lineArray = (line.components(separatedBy: ",")) // Split the line using the specified delimiter

            // print(lineArray)

            // Add new user to users array
            users.append(User(username: lineArray[0], password: (lineArray[1]).replacingOccurrences(of: "\r", with: "")))
        }
    }
    catch {
        print(error.localizedDescription) // Print error message
        exit(0)
    }
    return users
}

/// - Parameters:
///
///     - username: The username of the user
///     - password: The password of the user
///
/// - Returns: ``true`` if the user exists, and ``false`` if it does not
func login(username: String, password: String) -> Bool {
    for user in users { // Iterate through users array
        if user.username == username && user.password == password { // If user exists
            return true
        }
    }
    return false
}

/// Reads a character from the keyboard
///
/// - Returns: A character from the keyboard
func readCharacter() -> Character {
    var input: String = ""
    while true { // Loop until input is only one character
        print("Enter a letter:   ", terminator: "")
        input = readLine()!

        if input.count == 1 { // If input is only one character
            break
        }

        // If input is invalid
        print("Please enter a character\n")
    }
    return Character(input)
}

/// Allows the user to guess a letter in a word
///
/// - Parameters:
///
///     - letter: The guessed letter
///     - word: The word where the letter is guessed
///
/// - Returns: true if the given letter is in the given word, and false if not
func guessLetter(letter: Character, word: String) -> Bool {
    for c in word { // Iterate through the letters of the word
        if (letter == c) { // If the guessed letter is in the word
            return true
        }
    }
    return false
}

/// Gets the indices where a letter appears in a word
///
/// - Parameters:
///
///     - letter: The letter to be found in the word
///     - word: The word where the letter will be found
///
/// - Returns: An array of indices where a letter appears in a word
func getIndicesOfLetter(letter: Character, word: String) -> [Int] {
    var indices: [Int] = []
    let array = Array(word) // Create array of characters based on word
    for i in 0..<word.count { // Iterate through every letter of word
        if (array[i] == letter) { // Add indice number to indices array if the letter in the current index is equal to the guessed letter
            indices.append(i)
        }
    }
    return indices
}

/// - Parameter words: An array of words
///
/// - Returns: Returns a random word from the given array of words
func getNewWord(words: [String]) -> String {
    return words[Int.random(in: 0..<words.count)] // Return random word
}

/// The class for the User
class User {
    /// The username of the user
    var username: String?

    /// The password of the user
    var password: String?

    /// The number of lives of the user
    var lives: Int?

    init() {
        self.username = nil
        self.password = nil
        self.lives = nil
    }

    init(username: String, password: String) {
        self.username = username
        self.password = password
        self.lives = 6
    }
}
