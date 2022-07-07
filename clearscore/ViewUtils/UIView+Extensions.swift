import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { view in addSubview(view) }
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { view in addArrangedSubview(view) }
    }
}
