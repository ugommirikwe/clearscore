import Foundation

enum R {
    /// Provides statically (rather than "stringly") typed access to all localized strings in this app.
    enum string: String {
        case creditScoreLabelText = "creditScoreLabelText"
        case creditScoreMaxLabel = "creditScoreMaxLabel"
        case mainViewControllerNavBarTitle = "mainViewControllerNavBarTitle"
        case detailsViewControllerNavBarTitle = "detailsViewControllerNavBarTitle"
        case refreshNavBarButton = "refreshNavBarButton"
        
        var localized: String {
            NSLocalizedString(self.rawValue, comment: self.rawValue)
        }
        
        func localized(with args: [CVarArg]) -> String {
            String(format: self.localized, arguments: args)
        }
    }
}
