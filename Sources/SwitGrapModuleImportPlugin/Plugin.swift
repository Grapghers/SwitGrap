import Foundation
import SwitGrapPluginSupport

// MARK: - Dylib makeXCGrapherPlugin exporting

@_cdecl("makeSwitGrapherPlugin")
public func makeXCGrapherPlugin() -> UnsafeMutableRawPointer {
    Unmanaged.passRetained(XCGrapherModuleImportPlugin()).toOpaque()
}

// MARK: - Custom Plugin

public class XCGrapherModuleImportPlugin: SwitGrapherPlugin {

    override public func process(file: SwitGrapherFile) throws -> [Any] {
        [] // We don't care about reading file info manually for this particular plugin
    }

    override public func process(library: SwitGrapherImport) throws -> [Any] {
        // We want to store:
        // - Who is being imported (library.moduleName)
        // - Who is doing the importing (library.importerName)
        // - A custom color we can use for rendering the arrow (see Extensions.swift)
        let importInfo = ImportInfo(
            importedModuleName: library.moduleName,
            importerModuleName: library.importerName,
            color: library.moduleType.customColor
        )

        return [importInfo]
    }

    override public func makeArrows(from processingResults: [Any]) throws -> [SwitGrapherArrow] {
        processingResults
            // This is safe because we only ever returned an `ImportInfo` from the process(x:) functions above
            .map { $0 as! ImportInfo }

            // For every item returned from a process(x:) function, make an edge (arrow) from the importing module to the imported module.
            .map {
                SwitGrapherArrow(
                    origin: $0.importerModuleName,
                    destination: $0.importedModuleName,
                    color: $0.color
                )
            }
    }

}
