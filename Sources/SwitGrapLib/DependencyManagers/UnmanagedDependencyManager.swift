import Foundation
import SwitGrapPluginSupport

/// A dependency manager that always claims to be managing modules passed into it
/// but never knows what their dependencies are.
struct UnmanagedDependencyManager {}

extension UnmanagedDependencyManager: DependencyManager {

    var pluginModuleType: SwitGrapherImport.ModuleType {
        .other
    }

    func isManaging(module: String) -> Bool {
        true
    }

    func dependencies(of module: String) -> [String] {
        []
    }

}
