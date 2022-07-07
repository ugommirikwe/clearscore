import XCTest

class UITestPageObject {
    let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    func localize(_ key: String) -> String {
        let uiTestBundle = Bundle(for: type(of: self))
        return NSLocalizedString(key, bundle: uiTestBundle, comment: "")
    }
    
    func localize(_ key: String, with args: [CVarArg]) -> String {
        String(format: localize(key), arguments: args)
    }
    
    @discardableResult
    func grabScreenshotAndName(
        it name: String,
        _ lifetime: XCTAttachment.Lifetime = .deleteOnSuccess,
        _ add: ((XCTAttachment) -> Void)? = nil
    ) -> Self {
        add?(UITestPageObject.screenshot(named: name, lifetime))
        return self
    }
    
    static func screenshot(
        named name: String? = nil,
        uiDeviceName: String = UIDevice.current.name,
        _ lifetime: XCTAttachment.Lifetime = .deleteOnSuccess
    ) -> XCTAttachment {
        let screenshot = XCUIScreen.main.screenshot()
        
        var nameProvided = ""
        if let name = name, !name.isEmpty {
            nameProvided = "Screenshot-\(name)-\(uiDeviceName).png"
        } else {
            nameProvided = "Screenshot-\(uiDeviceName).png"
        }
        
        let attachment = XCTAttachment(
            uniformTypeIdentifier: "public.png",
            name: nameProvided,
            payload: screenshot.pngRepresentation,
            userInfo: nil
        )
        attachment.lifetime = lifetime
        return attachment
    }
}
