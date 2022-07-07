import Foundation

/// - Tag: RemoteAPIServiceMock
final class RemoteAPIServiceMock: RemoteServiceAPIProtocol {
    /// - Tag: RemoteAPIServiceMock.fetchCreditScore
    func fetchCreditScore() async throws -> CreditScoreAPIResponse {
        .testFixture()
    }
}

/// - Tag: RemoteAPIServiceMockThrowing
final class RemoteAPIServiceMockThrowing: RemoteServiceAPIProtocol {
    /// - Tag: RemoteAPIServiceMockThrowing.fetchCreditScore
    func fetchCreditScore() async throws -> CreditScoreAPIResponse {
        throw URLError(.badURL)
    }
}
