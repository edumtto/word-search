import SwiftUI

final class NavigationState: ObservableObject {
    @Published var path: NavigationPath {
        didSet {
            debugPrint("> nav path count: \(path.count)")
        }
    }
    
    init(path: NavigationPath = NavigationPath()) {
        self.path = path
    }
    
    func cleanPath() {
        path.removeLast(path.count)
    }
}
