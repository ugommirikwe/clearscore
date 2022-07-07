import UIKit

/// - Tag: MainView
final class MainView: UIView {
    
    /// - Tag: MainView.Props
    struct Props {
        let isLoading: Bool
        let creditScore: Int
        let creditScoreMax: Int
        let errorText: String
    }
    
    /// Initializes this view while providing the closure to invoke when the [circular progress view](x-source-tag://CircularProgressView) is tapped.
    ///
    /// - Parameter onTapAction: The closure to invoke when the circular progress view is tapped.
    required init(onTapAction: @escaping () -> Void) {
        self.onTapAction = onTapAction
        super.init(frame: .zero)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private init() {
        fatalError("Use init(onTapAction:)")
    }
    
    /// Populates this view with required pieces of data.
    ///
    /// - Parameter props: [State](x-source-tag://MainView.Props) data to be displayed in this view.
    ///
    /// - Tag: MainView.render
    func render(with props: MainView.Props) {
        if props.isLoading {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
            
            toggleErrorBannerDisplay(with: props.errorText)
            
            if props.creditScore == 0 { return }
            
            creditScoreLabel.text = R.string.creditScoreLabelText.localized
            creditScoreMaxLabel.text = R.string.creditScoreMaxLabel.localized(with: [props.creditScoreMax])
            animateDigitChange(to: props.creditScore, duration: animationDuration)
            
            let fraction = Float(props.creditScore) / Float(props.creditScoreMax)
            circularView.setProgressWithAnimation(duration: animationDuration, value: fraction)
        }
    }
    
    private var onTapAction: () -> Void
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        spinner.style = .large
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.accessibilityIdentifier = MainViewAccessibilityIdentifier.spinner
        return spinner
    }()
    
    private lazy var circularView: CircularProgressView = {
        var cv = CircularProgressView(frame: .init(origin: .init(), size: .init(width: 250, height: 250)))
        cv.progressColor = UIColor.systemOrange
        cv.trackColor = UIColor.systemBackground
        cv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapGesture))
        cv.addGestureRecognizer(tap)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.accessibilityIdentifier = MainViewAccessibilityIdentifier.circularView
        return cv
    }()
    private let animationDuration = 2.0
    
    private lazy var creditScoreTextStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapGesture))
        stackView.addGestureRecognizer(tap)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var creditScoreLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.isUserInteractionEnabled = true
        label.accessibilityIdentifier = MainViewAccessibilityIdentifier.creditScoreHeaderLabel
        return label
    }()
    
    private lazy var creditScoreValue: UILabel = {
        var label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 50)
        label.textColor = UIColor.systemOrange
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = MainViewAccessibilityIdentifier.creditScoreValue
        return label
    }()
    
    private lazy var creditScoreMaxLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = MainViewAccessibilityIdentifier.creditScoreMaxLabel
        return label
    }()
    
    private lazy var errorText: UILabel = {
        let top = UIApplication.shared.windows[0].safeAreaInsets.top
        var label = LabelWithPadding(withInsets: top > 20 ? 60 : 30, 20, 20, 50)
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.backgroundColor = UIColor.systemRed
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = MainViewAccessibilityIdentifier.errorText
        return label
    }()
    
    private func setupSubViews() {
        creditScoreTextStackView.addArrangedSubviews(creditScoreLabel, creditScoreValue, creditScoreMaxLabel)
        addSubviews(circularView, creditScoreTextStackView, errorText, spinner)
        addSubviewsContraints()
    }
    
    private func addSubviewsContraints() {
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            errorText.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorText.topAnchor.constraint(equalTo: topAnchor),
            errorText.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            circularView.heightAnchor.constraint(equalToConstant: 250),
            circularView.widthAnchor.constraint(equalToConstant: 250),
            circularView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circularView.centerYAnchor.constraint(equalTo: centerYAnchor),
            creditScoreTextStackView.centerXAnchor.constraint(equalTo: circularView.centerXAnchor),
            creditScoreTextStackView.centerYAnchor.constraint(equalTo: circularView.centerYAnchor)
        ])
    }
    
    @objc private func onTapGesture(_ sender:UITapGestureRecognizer) {
        onTapAction()
    }
    
    private func animateDigitChange(from: Int = 0, to: Int, duration: Double = 2.0, steps: Int = 20) {
        let steps = min(to, steps)
        let rate = duration / Double(steps)
        let diff = to - from
        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + rate * Double(i)) {
                withAnimation {
                    self.creditScoreValue.text = "\(Int(Double(from) + Double(diff) * (Double(i) / Double(steps))))"
                }
            }
        }
    }
    
    private func toggleErrorBannerDisplay(with text: String) {
        let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        errorText.text = text
        UIView.transition(with: errorText, duration: 2, options: .showHideTransitionViews) {
            self.errorText.isHidden = text.isEmpty
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MainView_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let mainView = MainView(onTapAction: {})
            mainView.render(with: MainView.Props(
                isLoading: false,
                creditScore: 400,
                creditScoreMax: 600,
                errorText: "Some error here"
            ))
            return mainView
        }
    }
}
#endif
