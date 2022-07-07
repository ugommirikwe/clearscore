import UIKit

/// - Tag: CircularProgressView
final class CircularProgressView: UIView {
    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    
    var progressColor = UIColor.white {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var trackColor = UIColor.white {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeCircularPath()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeCircularPath()
    }
    
    private func makeCircularPath() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width/2
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2),
            radius: (frame.size.width - 1.5)/2,
            startAngle: CGFloat(-0.5 * .pi),
            endAngle: CGFloat(1.5 * .pi),
            clockwise: true
        )
        trackLayer.path = circlePath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = 5.0
        trackLayer.strokeEnd = 1.0
        layer.addSublayer(trackLayer)
        
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 5.0
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0.0
        layer.addSublayer(progressLayer)
    }
    
    /// - Tag: setProgressWithAnimation
    func setProgressWithAnimation(duration: TimeInterval, value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        progressLayer.strokeEnd = CGFloat(value)
        progressLayer.add(animation, forKey: "animateprogress")
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct CircularProgressView_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let cv = CircularProgressView(frame: .init(origin: .init(), size: .init(width: 200, height: 200)))
            cv.progressColor = UIColor.systemOrange
            cv.trackColor = UIColor.systemBackground
            cv.setProgressWithAnimation(duration: 2.0, value: 0.7)
            return cv
        }
    }
}
#endif
