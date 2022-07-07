import UIKit

/// - Tag: SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let mainViewController = MainViewController(makeMainViewModel())
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
    
    /// - Tag: SceneDelegate.makeMainViewModel
    private func makeMainViewModel() -> MainViewModel {
        #if DEBUG
        if CommandLine.arguments.contains("-UITests") {
            print("Running UI tests")
            
            var viewModel: MainViewModel
            
            if CommandLine.arguments.contains("-Throws") {
                viewModel = .init(remoteServiceAPI: RemoteAPIServiceMockThrowing())
            } else {
                viewModel = .init(remoteServiceAPI: RemoteAPIServiceMock())
            }
            
            return viewModel
        }
        #endif
        
        return MainViewModel()
    }
}
