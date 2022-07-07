import Combine

/// - Tag: MainViewModel
@MainActor
final class MainViewModel: ObservableObject {
    /// - Tag: MainViewModel.loadingData
    @Published private(set) var loadingData: Bool = false
    
    /// - Tag: MainViewModel.creditScoreData
    @Published private(set) var creditScoreData: CreditScoreAPIResponse? = nil
    
    /// - Tag: MainViewModel.errorToDisplay
    @Published private(set) var errorToDisplay: String = ""
    
    private let remoteServiceAPI: RemoteServiceAPIProtocol
    
    init(remoteServiceAPI: RemoteServiceAPIProtocol = RemoteServiceAPI()) {
        self.remoteServiceAPI = remoteServiceAPI
        fetchCreditScore()
    }
    
    /// - Tag: MainViewModel.fetchCreditScore
    func fetchCreditScore() {
        loadingData = true
        errorToDisplay = ""
        creditScoreData = nil
        
        Task {
            do {
                creditScoreData = try await remoteServiceAPI.fetchCreditScore()
            } catch {
                errorToDisplay = error.localizedDescription
            }
            loadingData = false
        }
    }
}
