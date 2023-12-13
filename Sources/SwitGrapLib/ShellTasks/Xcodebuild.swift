import Foundation

@available(iOS 13.0, *)
struct Xcodebuild: SwiftPackageDependencySource {
    let projectFile: FileManager.Path
    let target: String

    func computeCheckoutsDirectory() throws -> String {
        // Clone all the packages into $DERIVED_DATA/SourcePackages/checkouts
        let output = try execute()
            .breakIntoLines()

        // Find the $DERIVED_DATA path
        let derivedDataDir = output
            .first(where: { $0.contains(" BUILD_DIR = ") })!
            .replacingOccurrences(of: "BUILD_DIR =", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .scan {
                $0.scanAndStoreUpToAndIncluding(string: "DerivedData/")
                $0.scanAndStoreUpTo(string: "/")
            }
        return derivedDataDir.appending("/SourcePackages/checkouts")
    }

}

@available(iOS 13.0, *)
extension Xcodebuild: ShellTask {

    var stringRepresentation: String {
        "xcodebuild -project \"\(projectFile)\" -target \"\(target)\" -showBuildSettings"
    }

    var commandNotFoundInstructions: String {
        "Missing command 'xcodebuild'"
    }

}
