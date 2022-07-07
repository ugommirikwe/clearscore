import XCTest
@testable import clearscore

/// The [MainViewModel](x-source-tag://MainViewModel) invokes the remote service API call at initialization to fetch data, which it then populates its
/// fields with. These fields are observed and rendered by the [MainViewController](x-source-tag://MainViewController), meaning testing it ensures
/// that even the view controllers are ultimately quality assured.
///
/// The view model [fetchCreditScore method](x-source-tag://MainViewModel.fetchCreditScore) that invokes the remote service API async function
/// isn't marked "async", rather it does this within an async Task block.
///
/// This presents a unique testing challenge that can currently only be solved using a variation of
/// the method that have been used for testing completion handler asynchronous operations: i.e. with the `XCTestExpectation` API and, in this unique
/// circumstances, the `DispatchQueue.main.asyncAfter` function.
@MainActor
final class ClearScoreTests: XCTestCase {
    
    /// Test that the [MainViewModel](x-source-tag://MainViewModel) correctly invokes the remote service API at initialization and then populates its
    /// fields with the data it retrieves--happy path.
    ///
    /// This test injects the view model with the [RemoteAPIServiceMock()](x-source-tag://RemoteAPIServiceMock) class, which conforms to the
    /// [RemoteServiceAPIProtocol](x-source-tag://RemoteServiceAPIProtocol).
    func testViewModelInitializationFetchesCreditScoreAndPopulatesFields() {        
        let expectation = XCTestExpectation(
            description: "MainViewModel fetches data and updates fields on initialization."
        )

        let vm = MainViewModel(remoteServiceAPI: RemoteAPIServiceMock())
        
        // Verify initial state
        XCTAssertEqual(vm.loadingData, true)
        XCTAssertEqual(vm.errorToDisplay, "")
        XCTAssertNil(vm.creditScoreData)
        
        let asyncWaitDuration = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + asyncWaitDuration) {
            expectation.fulfill()
            
            // Verify state after
            XCTAssertEqual(vm.loadingData, false)
            XCTAssertEqual(vm.errorToDisplay, "")
            XCTAssertEqual(
                vm.creditScoreData?.creditReportInfo.score,
                CreditScoreAPIResponse.testFixture().creditReportInfo.score
            )
            XCTAssertEqual(
                vm.creditScoreData?.creditReportInfo.maxScoreValue,
                CreditScoreAPIResponse.testFixture().creditReportInfo.maxScoreValue
            )
        }
        wait(for: [expectation], timeout: asyncWaitDuration)
    }
    
    /// The [MainViewModel](x-source-tag://MainViewModel) may receive an error from the remote service API call that it invokes in initialization,
    /// so it has to handle this.
    ///
    /// This test inects the view model with the [RemoteAPIServiceMockThrowing()](x-source-tag://RemoteAPIServiceMockThrowing) class whose
    /// [fetchCreditScore()](x-source-tag://RemoteAPIServiceMockThrowing.fetchCreditScore) method throws a `URLError(.badURL)`
    /// error, so it checks that the view model populates its [errorToDisplay](x-source-tag://MainViewModel.errorToDisplay) property accordingly.
    func testViewModelHandlesErrorThrownWhileFetchingCreditScore() {
        let expectation = XCTestExpectation(description: "MainViewModel handles thrown error while initializing.")
        
        let vm = MainViewModel(remoteServiceAPI: RemoteAPIServiceMockThrowing())
        
        // Verify initial state
        XCTAssertEqual(vm.loadingData, true)
        XCTAssertEqual(vm.errorToDisplay, "")
        XCTAssertNil(vm.creditScoreData)
        
        let asyncWaitDuration = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + asyncWaitDuration) {
            expectation.fulfill()
            
            // Verify state after
            XCTAssertEqual(vm.errorToDisplay, URLError(.badURL).localizedDescription)
            XCTAssertNil(vm.creditScoreData)
            XCTAssertEqual(vm.loadingData, false)
        }
        wait(for: [expectation], timeout: asyncWaitDuration)
    }
}

