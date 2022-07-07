import XCTest

final class MainViewControllerScreen: UITestPageObject {
    private lazy var navBar: XCUIElement = {
        app.navigationBars[MainViewAccessibilityIdentifier.navBar]
    }()
    
    private lazy var refreshButton: XCUIElement = {
        navBar.buttons[MainViewAccessibilityIdentifier.refreshNavBarButton]
    }()
    
    private lazy var errorTextView: XCUIElement = {
        app.staticTexts[MainViewAccessibilityIdentifier.errorText]
    }()
    
    private lazy var spinner: XCUIElement = {
        app.staticTexts[MainViewAccessibilityIdentifier.spinner]
    }()
    
    private lazy var creditScoreHeaderText: XCUIElement = {
        app.staticTexts[MainViewAccessibilityIdentifier.creditScoreHeaderLabel]
    }()
    
    private lazy var creditScoreValueText: XCUIElement = {
        app.staticTexts[MainViewAccessibilityIdentifier.creditScoreValue]
    }()
    
    private lazy var creditScoreMaxText: XCUIElement = {
        app.staticTexts[MainViewAccessibilityIdentifier.creditScoreMaxLabel]
    }()
    
    @discardableResult
    func verifyNavBarDisplaysTitle(_ title: String, wait: TimeInterval = 0) -> Self {
        XCTAssertTrue(navBar.staticTexts[localize(title)].waitForExistence(timeout: wait))
        return self
    }
    
    @discardableResult
    func verifyNavigatedBackToMainScreen() -> Self {
        XCTAssertTrue(creditScoreValueText.exists)
        XCTAssertEqual(
            creditScoreValueText.identifier,
            MainViewAccessibilityIdentifier.creditScoreValue
        )
        return self
    }
    
    @discardableResult
    func verifyRefreshButtonIsVisibleAndEnabled() -> Self {
        XCTAssertTrue(refreshButton.isEnabled)
        return self
    }
    
    @discardableResult
    func verifyCreditScoreIsDisplaying(_ value: Int) -> Self {
        guard  creditScoreValueText.waitForExistence(timeout: 1) else {
            XCTFail("Time ran out waiting for element \(creditScoreValueText) to appear on screen")
            return self
        }
        
        XCTAssertEqual(creditScoreValueText.label, String(value))
        return self
    }
    
    @discardableResult
    func verifyCreditScoreMaxDisplayed(is value: Int) -> Self {
        XCTAssertEqual(
            creditScoreMaxText.label,
            localize(R.string.creditScoreMaxLabel.localized, with: [value])
        )
        return self
    }
    
    @discardableResult
    func tapCreditScoreValueText() -> DetailsViewControllerScreen {
        creditScoreValueText.tap()
        return DetailsViewControllerScreen(app: app)
    }
    
    @discardableResult
    func verifyDisplaysErrorMessage(_ message: String) -> Self {
        XCTAssertEqual(errorTextView.label, message)
        return self
    }
}
