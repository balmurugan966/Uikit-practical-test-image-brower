//
//  ImageCarouselCell.swift
//  DevExamUikit
//
//  Created by balamuruganc on 11/02/25.
//

import UIKit

// MARK: - ImageCarouselCell
/// A custom UICollectionViewCell subclass that displays an image in an image carousel.
/// This cell contains a single UIImageView that fills the entire cell.
class ImageCarouselCell: UICollectionViewCell {
    
    /// A private UIImageView instance that displays the carousel image.
    private let imageView = UIImageView()
    
    // MARK: - Initializers
    
    /// Overrides the designated initializer to configure the cell when created programmatically.
    /// - Parameter frame: The frame rectangle for the cell, measured in points.
    override init(frame: CGRect) {
        super.init(frame: frame)  // Call the superclass initializer with the provided frame.
        
        // Set the background colors to clear to avoid any unwanted default backgrounds,
        // borders, or separator lines that might be applied by the system.
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Call the helper method to set up the imageView.
        setupImageView()
    }
    
    /// Required initializer for loading the cell from a storyboard or nib.
    /// Since this cell is intended to be created programmatically, this initializer is not implemented.
    /// - Parameter coder: An unarchiver object.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    /// Configures the imageView by setting its content mode, clipping behavior, corner radius, and layout constraints.
    private func setupImageView() {
        // Set the content mode to scaleAspectFill so the image fills the view while maintaining its aspect ratio.
        imageView.contentMode = .scaleAspectFill
        
        // Enable clipping to ensure that any parts of the image that extend beyond the imageView's bounds are not visible.
        imageView.clipsToBounds = true
        
        // Set the corner radius for the imageView to achieve rounded corners.
        imageView.layer.cornerRadius = 15
        
        // Set the background color of the imageView to clear to avoid any default background color.
        imageView.backgroundColor = .clear
        
        // Add the imageView as a subview of the cell's contentView.
        contentView.addSubview(imageView)
        
        // Disable the autoresizing mask translation to use Auto Layout constraints.
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate Auto Layout constraints to make the imageView fill the entire contentView.
        NSLayoutConstraint.activate([
            // Constrain the top edge of the imageView to the top edge of the contentView.
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            // Constrain the bottom edge of the imageView to the bottom edge of the contentView.
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            // Constrain the leading (left) edge of the imageView to the leading edge of the contentView.
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            // Constrain the trailing (right) edge of the imageView to the trailing edge of the contentView.
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    // MARK: - Public Methods
    
    /// Configures the cell with an image based on the provided image name.
    /// - Parameter imageName: The name of the image asset to display.
    /// If the image cannot be loaded from assets, a default system image is used.
    func configure(with imageName: String) {
        // Attempt to load an image with the given name; if not found, use the default "photo" system image.
        imageView.image = UIImage(named: imageName) ?? UIImage(systemName: "photo")
    }
}
