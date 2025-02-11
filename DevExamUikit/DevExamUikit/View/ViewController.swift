//
//  ViewController.swift
//  DevExamUikit
//
//  Created by balamuruganc on 11/02/25.
//
import UIKit

// MARK: - ViewController Class Declaration
// This ViewController manages a UI that includes an image carousel (collection view),
// a search bar, a table view displaying filtered data, a floating button to show statistics,
// and a page control for pagination. It conforms to multiple delegate and data source protocols.
class ViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // Dependency Injection: The view model is injected into this view controller.
    let viewModel: ViewModel
    
    // UI Components
    let searchBar = UISearchBar()
    var collectionView: UICollectionView!
    let tableView = UITableView()
    let floatingButton = UIButton()
    let pageControl = UIPageControl()
    
    // MARK: - Initializers
    
    /// Designated initializer for the ViewController.
    /// - Parameter viewModel: A ViewModel instance to manage data and business logic.
    ///                        It has a default value, so dependency injection is optional.
    init(viewModel: ViewModel = ViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // Required initializer to support storyboard instantiation.
    required init?(coder: NSCoder) {
        // Provide a default ViewModel if instantiated from a storyboard.
        self.viewModel = ViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white  // Set the background color of the view
        
        // Setup UI components by calling dedicated setup functions.
        setupPageControl()        // Initialize and configure the page control
        setupCollectionView()     // Initialize and configure the collection view (image carousel)
        setupSearchBar()          // Initialize and configure the search bar
        setupTableView()          // Initialize and configure the table view
        setupFloatingButton()     // Initialize and configure the floating button
        setupConstraints()        // Set up Auto Layout constraints for all UI components
        
        // Create a tap gesture recognizer to dismiss the keyboard when tapping anywhere in the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        // Allow other touch events to be recognized by not canceling touches in the view.
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)  // Add the tap gesture recognizer to the main view
    }
    
    // MARK: - Keyboard Handling
    /// Dismisses the keyboard by ending editing on the view.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Setup UI Components
    
    /// Sets up the collection view that functions as an image carousel.
    func setupCollectionView() {
        // Initialize a flow layout for the collection view.
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal  // Set scrolling direction to horizontal
        // Set the size of each item to 90% of the view's width and a fixed height of 200.
        layout.itemSize = CGSize(width: view.frame.width * 0.9, height: 200)
        layout.minimumLineSpacing = 0  // Initial spacing (will be overridden shortly)
        // Center the carousel items by adding side insets.
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 10,
            bottom: 0,
            right: 10
        )
        
        // Re-configure layout properties (overriding previous spacing values).
        layout.scrollDirection = .horizontal  // Ensure horizontal scrolling remains enabled
        layout.itemSize = CGSize(width: view.frame.width * 0.9, height: 200)  // Confirm item size
        layout.minimumLineSpacing = 10  // Set minimum spacing between items
        
        // Initialize the collection view with the layout.
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self         // Set self as the delegate to handle events
        collectionView.dataSource = self       // Set self as the data source for providing cells
        collectionView.isPagingEnabled = true   // Enable paging so scrolling stops at each item
        collectionView.showsHorizontalScrollIndicator = false // Hide horizontal scroll indicator
        // Register the custom cell class for reuse with identifier "cell".
        collectionView.register(ImageCarouselCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white // Set background color of the collection view
        view.addSubview(collectionView)         // Add the collection view to the view hierarchy
    }
    
    /// Sets up and configures the page control for the image carousel.
    func setupPageControl() {
        // Set the total number of pages to match the number of horizontal images.
        pageControl.numberOfPages = viewModel.horizontalImages.count
        pageControl.currentPage = 0  // Set the initial page to the first one (index 0)
        pageControl.currentPageIndicatorTintColor = .black  // Color for the current page dot
        pageControl.pageIndicatorTintColor = .lightGray     // Color for the inactive page dots
        // Add a target-action for when the page control's value changes (user taps a dot).
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        view.addSubview(pageControl)  // Add the page control to the view hierarchy
    }
    
    /// Returns a dynamic subtitle for a given item (for example, the length of the string).
    func dynamicSubtitle(for item: String) -> String {
        return "Length: \(item.count) characters"
    }
    
    /// Action method called when the page control value changes.
    @objc func pageControlChanged(_ sender: UIPageControl) {
        let index = sender.currentPage  // Get the current page index from the page control
        let indexPath = IndexPath(item: index, section: 0)  // Create an index path for the collection view cell
        // Scroll the collection view to the corresponding cell.
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    /// Sets up and configures the search bar.
    func setupSearchBar() {
        searchBar.delegate = self          // Set self as the search bar delegate to listen for text changes
        searchBar.placeholder = "Search"   // Set the placeholder text for the search bar
        view.addSubview(searchBar)         // Add the search bar to the view
    }
    
    /// Sets up and configures the table view.
    func setupTableView() {
        tableView.delegate = self                 // Set self as the delegate for table view events
        tableView.dataSource = self               // Set self as the data source to provide cells
        // Register the custom table view cell class for reuse with identifier "cell".
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)                // Add the table view to the view hierarchy
    }
    
    /// Sets up and configures the floating button.
    func setupFloatingButton() {
        // Set the button's image to a system "ellipsis" icon.
       
        if let rotatedImage = UIImage(systemName: "ellipsis")?
            .rotated(by: .pi / 2)?
            .withRenderingMode(.alwaysTemplate) {
            floatingButton.setImage(rotatedImage, for: .normal)
            floatingButton.tintColor = .white  // The image will be rendered in white.
        }

        floatingButton.backgroundColor = .blue     // Set the background color of the button
        floatingButton.layer.cornerRadius = 25     // Make the button circular (assuming width/height = 50)
        floatingButton.layer.shadowRadius = 5      // Set the shadow radius for a subtle shadow effect
        // Add an action to the button that will show statistics when the button is tapped.
        floatingButton.addTarget(self, action: #selector(showStatistics), for: .touchUpInside)
        view.addSubview(floatingButton)            // Add the floating button to the view hierarchy
    }
    
    /// Sets up Auto Layout constraints for all UI components.
    func setupConstraints() {
        // Disable Auto Layout's automatic constraints for each component.
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate an array of constraints to lay out the UI components.
        NSLayoutConstraint.activate([
            // Position the page control below the collection view and center it horizontally.
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // Duplicate constraints (redundant) can be removed if desired.
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 5),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Position the collection view at the top with a horizontal margin of 10.
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            
            // Place the search bar below the page control with horizontal margins.
            searchBar.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            // Position the table view below the search bar to fill the remainder of the screen.
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Position the floating button at the bottom-right corner with a fixed size.
            floatingButton.widthAnchor.constraint(equalToConstant: 50),
            floatingButton.heightAnchor.constraint(equalToConstant: 50),
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Floating Button Action
    /// This method is called when the floating button is tapped.
    @objc func showStatistics() {
        let statsText = viewModel.showStatistics()  // Generate statistics text from the view model
        let statsVC = StatisticsViewController(statsText: statsText)  // Create a new StatisticsViewController with the statistics
        // If running on iOS 15 or later, configure the sheet presentation controller for modal appearance.
        if let sheet = statsVC.sheetPresentationController {
            sheet.detents = [.medium()]  // Set the sheet height to medium
        }
        // Present the StatisticsViewController modally.
        present(statsVC, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionView Data Source Methods
    
    /// Returns the number of items in the collection view (equal to the number of horizontal images).
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.horizontalImages.count
    }
    
    /// Configures and returns each cell for the collection view (image carousel).
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue a reusable cell of type ImageCarouselCell using identifier "cell".
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCarouselCell
        // Configure the cell with the corresponding image name from the view model.
        cell.configure(with: viewModel.horizontalImages[indexPath.row])
        return cell  // Return the configured cell
    }
    
    // MARK: - UIScrollView Delegate Methods
    
    /// Called when the scroll view stops decelerating after a swipe.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Determine the visible rectangle of the collection view.
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        // Calculate the center point of the visible rectangle.
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        // Get the index path for the cell at the center point.
        if let _ = collectionView.indexPathForItem(at: visiblePoint) {
            // Calculate the current page based on the collection view's width.
            let pageWidth = collectionView.frame.width
            let currentPage = Int((collectionView.contentOffset.x + pageWidth / 2) / pageWidth)
            pageControl.currentPage = currentPage  // Update the page control's current page
            viewModel.selectedIndex = currentPage  // Update the selected index in the view model
            viewModel.updateListForSelectedImage() // Refresh the filtered list data in the view model
            tableView.reloadData()                 // Reload the table view to display updated data
        }
    }
    
    /// Updates the page control's current page as the collection view scrolls.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(collectionView.contentOffset.x / collectionView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    // MARK: - UICollectionView Delegate Method
    
    /// Called when a collection view cell is selected.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedIndex = indexPath.row  // Update the selected index based on the tapped cell
        viewModel.updateListForSelectedImage()     // Refresh the filtered list data in the view model
        tableView.reloadData()                     // Reload the table view to reflect changes
    }
    
    // MARK: - UITableView Data Source Methods
    
    /// Returns the number of rows in the table view (based on the filtered data count).
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredData.count
    }
    
    /// Configures and returns each table view cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell of type CustomTableViewCell using identifier "cell".
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        // Configure the cell with:
        // - The item text from the filtered data.
        // - A dynamic subtitle (e.g., the length of the item text).
        // - An image name corresponding to the currently selected horizontal image.
        cell.configure(with: viewModel.filteredData[indexPath.row],
                       with: dynamicSubtitle(for: viewModel.filteredData[indexPath.row]),
                       imageName: viewModel.horizontalImages[viewModel.selectedIndex])
        return cell  // Return the configured table view cell
    }
    
    // MARK: - UISearchBar Delegate Method
    
    /// Called when the text in the search bar changes.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearchText(searchText)  // Update the filtered data based on the search text in the view model
        tableView.reloadData()                  // Reload the table view to reflect the search results
    }
}
