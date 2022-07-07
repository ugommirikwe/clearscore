import UIKit

class DetailsView: UIView {
    
    /// - Tag: DetailsView.Props
    struct Props {
        let creditScore: Int
        let creditScoreMax: Int
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        super.init(frame: .zero)
        insetsLayoutMarginsFromSafeArea = false
        setupSubviews()
    }
    
    /// Populates this view with required pieces of data.
    ///
    /// - Parameter props: [State](x-source-tag://DetailsView.Props) data to be displayed in this view.
    ///
    /// - Tag: DetailsView.render
    func render(with props: DetailsView.Props) {
        creditScoreValue.text = "\(props.creditScore)"
        creditScoreMaxLabel.text = R.string.creditScoreMaxLabel.localized(with: [props.creditScoreMax])
    }
    
    private lazy var creditScoreValue: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        label.textColor = UIColor.white
        label.isUserInteractionEnabled = true
        label.accessibilityIdentifier = DetailsViewAccessibilityIdentifier.creditScoreValue
        return label
    }()
    
    private lazy var creditScoreMaxLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = UIColor.white
        label.isUserInteractionEnabled = true
        label.accessibilityIdentifier = DetailsViewAccessibilityIdentifier.creditScoreMaxLabel
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.addArrangedSubviews(creditScoreValue, creditScoreMaxLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var headerSectionView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemOrange
        v.addSubview(stackView)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private func setupSubviews() {
        addSubviews(headerSectionView)
        addSubviewsContraints()
    }
    
    private func addSubviewsContraints() {
        let headerSectionViewHeight = CGFloat(300)
        let margins = layoutMarginsGuide
        NSLayoutConstraint.activate([
            headerSectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerSectionView.topAnchor.constraint(equalTo: topAnchor),
            headerSectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerSectionView.heightAnchor.constraint(equalToConstant: headerSectionViewHeight),
            
            stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 150),
            stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: headerSectionView.bottomAnchor, constant: -90)
        ])
        
        if let image = UIImage(named: "background") {
            let frame = headerSectionView.frame
            let backgroundImage = UIImageView(frame: .init(
                x: 0,
                y: 0,
                width: frame.width,
                height: headerSectionViewHeight
            ))
            backgroundImage.autoresizingMask = [.flexibleWidth]
            backgroundImage.contentMode = .scaleAspectFill
            backgroundImage.image = image
            headerSectionView.insertSubview(backgroundImage, at: 0)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct DetailsView_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let dv = DetailsView()
            dv.render(with: DetailsView.Props(creditScore: 400, creditScoreMax: 600))
            return dv
        }
    }
}
#endif
