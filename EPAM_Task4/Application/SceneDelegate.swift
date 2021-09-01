import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundImage = UIImage.getColorImage(color: .white, size: tabBarController.tabBar.bounds.size)

        let moduleBuilder: ModuleBuilderProtocol = ModuleBuilder()
        let moduleRouter: ModuleRouterProtocol = ModuleRouter(tabBarController: tabBarController, moduleBuilder: moduleBuilder)
        moduleRouter.setup()

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
