//
//  CustomTableViewCell.swift
//  DevExamUikit
//
//  Created by balamuruganc on 11/02/25.
//

import UIKit

// MARK: - CustomTableViewCell
/// A custom UITableViewCell subclass that displays an image alongside a title and subtitle.
/// This cell uses a horizontal stack view containing an image view and a vertical stack view for labels.
class CustomTableViewCell: UITableViewCell {
    
    /// A private UIImageView for displaying an image.
    private let customImageView = UIImageView()
    
    /// A private UILabel for displaying the title text.
    private let titleLabel = UILabel()
    
    /// A private UILabel for displaying the subtitle text.
    private let subtitleLabel = UILabel()
    
    // MARK: - Initializers
    
    /// Overrides the designated initializer to set up the cell when created programmatically.
    /// - Parameters:
    ///   - style: The style of the table view cell.
    ///   - reuseIdentifier: The reuse identifier for the cell.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // Call the superclass initializer
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Call the setupCell method to configure subviews and layout.
        setupCell()
    }
    
    /// Required initializer for decoding the cell from a storyboard or nib.
    /// Since this cell is intended to be used programmatically, this initializer is not implemented.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    /// Configures the cell's subviews and layout.
    private func setupCell() {
        // Configure the customImageView properties
        customImageView.contentMode = .scaleAspectFill  // Scale the image to fill the view while maintaining its aspect ratio.
        customImageView.clipsToBounds = true             // Clip any content that exceeds the bounds.
        customImageView.layer.cornerRadius = 10          // Apply a corner radius for rounded corners.
        
        // Configure the titleLabel's appearance
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)  // Set the font to bold with a size of 16.
        
        // Configure the subtitleLabel's appearance
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)   // Set the font to system font with a size of 14.
        subtitleLabel.textColor = .gray                      // Set the text color to gray.
        
        // Create a vertical stack view to arrange titleLabel and subtitleLabel vertically.
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical  // Stack the labels vertically.
        stackView.spacing = 4       // Set a spacing of 4 points between the labels.
        
        // Create a horizontal stack view to arrange customImageView and the vertical stack (stackView).
        let containerView = UIStackView(arrangedSubviews: [customImageView, stackView])
        containerView.axis = .horizontal  // Arrange subviews horizontally.
        containerView.spacing = 10          // Set a spacing of 10 points between the image and text stack.
        
        // Add the containerView to the cell's contentView.
        contentView.addSubview(containerView)
        
        // Disable autoresizing mask translation to use Auto Layout constraints.
        containerView.translatesAutoresizingMaskIntoConstraints = false
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate Auto Layout constraints.
        NSLayoutConstraint.activate([
            // Set a fixed width and height for the customImageView (50x50 points).
            customImageView.widthAnchor.constraint(equalToConstant: 50),
            customImageView.heightAnchor.constraint(equalToConstant: 50),
            
            // Constrain the containerView to the contentView with 10-point margins on all sides.
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Public Methods
    
    /// Configures the cell with provided title, subtitle, and image name.
    /// - Parameters:
    ///   - title: The text for the titleLabel.
    ///   - subTitle: The text for the subtitleLabel.
    ///   - imageName: The name of the image asset to display in the customImageView.
    func configure(with title: String, with subTitle: String, imageName: String) {
        titleLabel.text = title                     // Set the title label's text.
        subtitleLabel.text = subTitle               // Set the subtitle label's text.
        // Attempt to load the image using the provided image name; if not found, use the default system "photo" image.
        customImageView.image = UIImage(named: imageName) ?? UIImage(systemName: "photo")
    }
}
