//
//  StatisticsViewController.swift
//  DevExamUikit
//
//  Created by balamuruganc on 11/02/25.
//

import UIKit

// MARK: - StatisticsViewController
/// A view controller that displays statistical information in a modal bottom sheet.
class StatisticsViewController: UIViewController {
    
    /// The text containing statistics that will be displayed in the view.
    let statsText: String
    
    // MARK: - Initializers
    
    /// Custom initializer that accepts a statistics text string.
    /// - Parameter statsText: The text that contains statistics to be displayed.
    init(statsText: String) {
        self.statsText = statsText           // Assign the provided statistics text to the property.
        super.init(nibName: nil, bundle: nil)  // Call the superclass's initializer with nil nibName and bundle.
        modalPresentationStyle = .pageSheet   // Set the modal presentation style to page sheet (bottom sheet) for iOS 15+.
    }
    
    /// Required initializer for cases where the view controller is instantiated from a storyboard or nib.
    /// Since dependency injection is used and we're not loading from a storyboard, this is not implemented.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")  // Crash if this initializer is called.
    }
    
    // MARK: - View Lifecycle Methods
    
    /// Called after the controller’s view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()  // Call the superclass implementation.
        
        // Configure the view's appearance.
        view.backgroundColor = .white       // Set the background color of the view to white.
        view.layer.cornerRadius = 20          // Apply a corner radius to make the view's corners rounded.
        view.clipsToBounds = true             // Ensure subviews are clipped to the rounded corners.
        
        // Create and configure a UILabel to display the statistics text.
        let label = UILabel()               // Initialize a UILabel instance.
        label.numberOfLines = 0             // Allow the label to display multiple lines.
        label.text = statsText              // Set the label's text to the statistics text.
        label.textAlignment = .center       // Center-align the text within the label.
        view.addSubview(label)              // Add the label as a subview of the main view.
        label.translatesAutoresizingMaskIntoConstraints = false  // Disable autoresizing mask constraints to use Auto Layout.
        
        // Set up Auto Layout constraints for the label to position it with consistent margins.
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),      // 20-point margin from the top of the view.
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),  // 20-point margin from the left side.
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), // 20-point margin from the right side.
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)   // 20-point margin from the bottom of the view.
        ])
    }
}
