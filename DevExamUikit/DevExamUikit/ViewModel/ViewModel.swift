import Foundation

/// A ViewModel that manages image selection, vertical data lists, filtering, and statistics generation.
class ViewModel {
    
    /// The index of the currently selected image in the horizontal image array.
    var selectedIndex: Int = 0
    
    /// An array of image names used for a horizontal image carousel.
    let horizontalImages = [
        "A_breathtaking_nature_scene_featuring_a_serene_mou",
        "A_breathtaking_nature_scene_featuring_a_serene_wat",
        "A_scenic_coastal_view_with_waves_crashing_on_a_roc",
        "A_tranquil_forest_scene_with_a_winding_path_leadin"
    ]
    
    /// A 2D array where each sub-array represents a vertical list of strings (for example, fruit names).
    let verticalData: [[String]] = [
        ["apple", "banana", "orange", "blueberry"],
        ["grape", "melon", "kiwi", "strawberry"],
        ["pear", "pineapple", "mango", "cherry"],
        ["fig", "date", "plum", "papaya"]
    ]
    
    /// An array containing the filtered list of strings based on the current selection and search query.
    var filteredData: [String] = []
    
    /// Initializes the ViewModel.
    /// - It sets the initial filteredData based on the default selected index.
    init() {
        updateListForSelectedImage() // Initialize filteredData with the vertical list corresponding to the default selected index.
    }
    
    /// Updates the filteredData to match the vertical data corresponding to the currently selected horizontal image.
    func updateListForSelectedImage() {
        filteredData = verticalData[selectedIndex] // Set filteredData as the entire vertical list at the current selected index.
    }
    
    /// Updates the filteredData based on the provided search text.
    ///
    /// - Parameter searchText: The string used to filter the vertical data list.
    func updateSearchText(_ searchText: String) {
        if searchText.isEmpty {
            // If the search text is empty, reset filteredData to the full vertical list at the selected index.
            filteredData = verticalData[selectedIndex]
        } else {
            // Otherwise, filter the vertical data list to include only items that contain the search text (case-insensitive).
            filteredData = verticalData[selectedIndex].filter { item in
                item.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    /// Generates a statistics summary for the vertical list corresponding to the currently selected image.
    ///
    /// - Returns: A formatted string that shows:
    ///   - The list number (1-based).
    ///   - The total number of items in the list.
    ///   - The top three most frequent characters in the list items along with their counts.
    func showStatistics() -> String {
        let list = verticalData[selectedIndex]       // Retrieve the vertical list based on the current selected index.
        let counts = characterFrequency(list: list)    // Calculate character frequencies for the list.
        var statsText = "List \(selectedIndex + 1) (\(list.count) items)\n"  // Create a header for the statistics.
        
        // Append the top three most frequent characters and their counts.
        for (char, count) in counts.prefix(3) {
            statsText += "\(char) = \(count)\n"
        }
        return statsText  // Return the complete statistics string.
    }
    
    /// Calculates the frequency of each character in a list of strings.
    ///
    /// - Parameter list: An array of strings whose characters will be counted.
    /// - Returns: An array of tuples where each tuple contains a character and its frequency,
    ///            sorted in descending order by frequency.
    private func characterFrequency(list: [String]) -> [(Character, Int)] {
        var freq: [Character: Int] = [:]  // Create a dictionary to hold character counts.
        
        // Iterate over each string in the list.
        for word in list {
            // Iterate over each character in the string.
            for char in word {
                // Increment the count for the character, initializing to 0 if not already present.
                freq[char, default: 0] += 1
            }
        }
        // Return an array of tuples sorted by count in descending order.
        return freq.sorted { $0.value > $1.value }
    }
}
