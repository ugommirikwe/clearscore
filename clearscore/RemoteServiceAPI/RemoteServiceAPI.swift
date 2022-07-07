import Foundation

/// Defines the signature for types that provide the functionality for invoking remote services endpoints and retrieving data for this app.
///
/// - Tag: RemoteServiceAPIProtocol
protocol RemoteServiceAPIProtocol {
    /// - Tag: RemoteServiceAPIProtocol.fetchCreditScore
    func fetchCreditScore() async throws -> CreditScoreAPIResponse
}

/// - Tag: RemoteAPIService
final class RemoteServiceAPI: RemoteServiceAPIProtocol {
    let urlString: String
    
    init(_ urlString: String = "https://5lfoiyb0b3.execute-api.us-west-2.amazonaws.com/prod/mockcredit/values") {
        self.urlString = urlString
    }
    
    /// - Tag: RemoteAPIService.fetchCreditScore
    func fetchCreditScore() async throws -> CreditScoreAPIResponse {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let response: CreditScoreAPIResponse = try await ApiUtil.get(url: url)
        return response
    }
}
