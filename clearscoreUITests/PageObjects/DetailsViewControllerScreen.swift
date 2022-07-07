import XCTest

final class DetailsViewControllerScreen: UITestPageObject {
    private lazy var navBar: XCUIElement = {
        app.navigationBars[DetailsViewAccessibilityIdentifier.navBar]
    }()
    
    private lazy var backButton: XCUIElement = {
        navBar.buttons.firstMatch
    }()
    
    private lazy var creditScoreValueText: XCUIElement = {
        app.staticTexts[DetailsViewAccessibilityIdentifier.creditScoreValue]
    }()
    
    private lazy var creditScoreMaxText: XCUIElement = {
        app.staticTexts[DetailsViewAccessibilityIdentifier.creditScoreMaxLabel]
    }()
    
    @discardableResult
    func verifyNavBarDisplaysTitle(_ title: String) -> Self {
        XCTAssert(navBar.staticTexts[localize(title)].exists)
        return self
    }
    
    @discardableResult
    func verifyCreditScoreIsDisplaying(_ value: Int) -> Self {
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
    func verifyBackButtonIsDisplayed(labeled label: String) -> Self {
        XCTAssertEqual(backButton.label, localize(label))
        return self
    }
    
    @discardableResult
    func tapBackButton() -> MainViewControllerScreen {
        backButton.tap()
        return MainViewControllerScreen(app: app)
    }
    
}
