import UIKit
import Combine

/// - Tag: MainViewController
final class MainViewController: UIViewController {
    private var viewModel: MainViewModel
    private lazy var mainView = MainView(onTapAction: navigateToDetailsScreen)
    private var cancellables = Set<AnyCancellable>()
    
    /// Initializes this view controller with the [MainViewModel](x-source-tag://MainViewModel) that provides the data and functionalities required to be
    /// rendered in its view and child view controllers.
    ///
    /// - Parameter viewModel: Instance of [MainViewModel](x-source-tag://MainViewModel)
    init(_ viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        subscribeToViewModelData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = R.string.mainViewControllerNavBarTitle.localized
        
        navigationController?.navigationBar.accessibilityIdentifier = MainViewAccessibilityIdentifier.navBar
        
        let refreshNavBarButton = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshData)
        )
        refreshNavBarButton.isEnabled = viewModel.loadingData
        refreshNavBarButton.accessibilityIdentifier = MainViewAccessibilityIdentifier.refreshNavBarButton
        self.navigationItem.setRightBarButton(refreshNavBarButton, animated: true)
    }
    
    private func subscribeToViewModelData() {
        Publishers.CombineLatest3(
            viewModel.$loadingData,
            viewModel.$errorToDisplay,
            viewModel.$creditScoreData
        )
        .sink { [weak self] isLoading, errorToDisplay, creditScoreData in
            guard let self = self else { return }
            
            self.navigationItem.rightBarButtonItem?.isEnabled = !isLoading
            self.navigationItem.rightBarButtonItem?.tintColor = errorToDisplay.isEmpty ? UIColor(named: "AccentColor") : .white
            
            self.mainView.render(with: MainView.Props(
                isLoading: isLoading,
                creditScore: creditScoreData?.creditReportInfo.score ?? 0,
                creditScoreMax: creditScoreData?.creditReportInfo.maxScoreValue ?? 0,
                errorText: errorToDisplay
            ))
        }
        .store(in: &cancellables)
    }
    
    @objc private func refreshData() {
        viewModel.fetchCreditScore()
    }
    
    private func navigateToDetailsScreen() {
        guard let creditScoreData = viewModel.creditScoreData?.creditReportInfo else { return }
        
        let detailsVC = DetailsViewController((
            score: creditScoreData.score,
            maxScoreValue: creditScoreData.maxScoreValue
        ))
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MainViewControllerPreviews_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            MainViewController(.init())
        }
    }
}
#endif
