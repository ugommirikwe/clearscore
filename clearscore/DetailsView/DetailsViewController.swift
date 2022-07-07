import UIKit

/// - Tag: DetailsViewController
final class DetailsViewController: UIViewController {
    private let detailsView = DetailsView()
    
    /// Initializes the view controller with required pieces of data to be displayed.
    ///
    /// - Parameters:
    ///   - score: The credit score.
    ///   - maxScoreValue: The maximum credit score value.
    init(_ viewState: (score: Int, maxScoreValue: Int)) {
        self.detailsView.render(with: DetailsView.Props(
            creditScore: viewState.score,
            creditScoreMax: viewState.maxScoreValue
        ))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = R.string.detailsViewControllerNavBarTitle.localized
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.accessibilityIdentifier = DetailsViewAccessibilityIdentifier.navBar
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.clear
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = UIColor.lightText
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationItem.standardAppearance = nil
        navigationItem.scrollEdgeAppearance = nil
        navigationItem.compactAppearance = nil
        
        navigationController?.navigationBar.tintColor = nil
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct DetailsViewControllerPreviews_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            DetailsViewController((score: 314, maxScoreValue: 700))
        }
    }
}
#endif
