import XCTest
@testable import clearscore

final class ClearscoreUITests: XCTestCase {
    private var app: XCUIApplication!

    /// - Tag: setUp
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-UITests"]
    }
    
    override func tearDown() {
        let screenshot = UITestPageObject.screenshot(named: "Completed", .deleteOnSuccess)
        add(screenshot)
        app.terminate()
    }

    /// In a perfect world everything goes according to plan. But to be sure, let's verify this.
    ///
    /// This `XCTestCase`'s [setUp](x-source-tag://setUp) above adds a string, "`-UITests`", to this test app's `launchArguments` and, thus,
    /// leads the app through a flow in the [SceneDelegate.makeMainViewModel](x-source-tag://SceneDelegate.makeMainViewModel) function.
    /// This injects an instance of [RemoteAPIServiceMock](x-source-tag://RemoteAPIServiceMock) required by the
    /// [MainViewModel](x-source-tag://MainViewModel), which the app then initializes the default screen/entry view,
    /// [MainViewController](x-source-tag://MainViewController), with.
    ///
    /// - Tag: testHappyPathFlow
    func testHappyPathFlow() throws {
        app.launch()
        
        MainViewControllerScreen(app: app)
            .verifyNavBarDisplaysTitle(R.string.mainViewControllerNavBarTitle.localized)
            .verifyRefreshButtonIsVisibleAndEnabled()
            .verifyCreditScoreIsDisplaying(434)
            .verifyCreditScoreMaxDisplayed(is: 700)
            .grabScreenshotAndName(it: "MainViewControllerScreen", .keepAlways, add)
            .tapCreditScoreValueText()
            .verifyNavBarDisplaysTitle(R.string.detailsViewControllerNavBarTitle.localized)
            .verifyCreditScoreIsDisplaying(434)
            .verifyCreditScoreMaxDisplayed(is: 700)
            .grabScreenshotAndName(it: "DetailsViewControllerScreen", .keepAlways, add)
            .verifyBackButtonIsDisplayed(labeled: R.string.mainViewControllerNavBarTitle.localized)
            .tapBackButton()
            .verifyNavigatedBackToMainScreen()
    }
    
    /// Unlike the [testHappyPathFlow](x-source-tag://testHappyFlow), this test function verifies what happens if the app encounters any error. At this
    /// point it just displays an error message on screen.
    ///
    /// By appending the string, "`-Throws`", to the test app's `launchArguments` this function leads the test app through a pathway in the
    /// [SceneDelegate.makeMainViewModel](x-source-tag://SceneDelegate.makeMainViewModel) function. This injects an instance of
    /// [RemoteAPIServiceMockThrowing](x-source-tag://RemoteAPIServiceMockThrowing) required by the
    /// [MainViewModel](x-source-tag://MainViewModel), which the app then initializes the default screen/entry view,
    /// [MainViewController](x-source-tag://MainViewController), with .
    ///
    /// The [RemoteAPIServiceMockThrowing.fetchCreditScore](x-source-tag://RemoteAPIServiceMockThrowing.fetchCreditScore) function
    /// just throws a `URLError.badURL` error object, simulating a possible error the app can encounter while requesting data from the remote API service. This
    /// test simply verifies that the resultant error message is ultimately displayed on screen--in this case the localized string representation of the
    /// `URLError.badURL` error object.
    ///
    /// - Tag: testDisplaysErrorWhenViewModelReportsOne
    func testDisplaysErrorWhenViewModelReportsOne() throws {
        app.launchArguments.append("-Throws")
        app.launch()

        MainViewControllerScreen(app: app)
            .verifyNavBarDisplaysTitle(R.string.mainViewControllerNavBarTitle.localized)
            .verifyDisplaysErrorMessage(URLError(.badURL).localizedDescription)
            .grabScreenshotAndName(it: "MainViewControllerScreen__With_Error_Display", .keepAlways, add)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(
                metrics: [
                    XCTApplicationLaunchMetric(),
                    XCTClockMetric(),
                    XCTCPUMetric(),
                    XCTStorageMetric(),
                    XCTMemoryMetric()
                ]
            ) {
                app.launch()
            }
        }
    }
}
