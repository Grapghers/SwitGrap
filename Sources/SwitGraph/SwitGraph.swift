// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

public class XcodeProjectParser: NSObject {  // NSObject를 상속하도록 변경
    // 파일 구조를 정의하는 내부 구조체
    public struct FileStructure {
        var files: [String]  // 파일 목록
        var dependencies: [String: [String]]  // 의존성 목록
    }

    // 의존성 정보를 담는 내부 구조체
    public struct DependencyInfo {
        var libraryName: String  // 라이브러리 이름
        var dependentLibraries: [String]  // 의존하는 라이브러리 목록
    }

    public var fileStructure: FileStructure?  // 파일 구조를 저장하는 프로퍼티

    // 초기화 메서드
    public override init() {  // NSObject를 상속하면서 override 키워드 사용
        super.init()
    }

    // Xcode 프로젝트를 파싱하는 메서드
    public func parseXcodeProject(fileURL: URL) {
        do {
            let data = try Data(contentsOf: fileURL)
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        } catch {
            print("Xcode 프로젝트 파일을 읽는 중 오류 발생: \(error.localizedDescription)")
            fileStructure = nil
        }
    }

    // 의존성 그래프를 그리는 메서드
    public func drawDependencyGraph() {
        guard let fileStructure = fileStructure else {
            print("Xcode 프로젝트 파일이 파싱되지 않았습니다.")
            return
        }

        for (file, dependencies) in fileStructure.dependencies {
            print("\(file)은(는) 다음에 의존합니다: \(dependencies.joined(separator: ", "))")
        }
    }

    // 특정 라이브러리의 의존성 정보를 가져오는 메서드
    public func getLibraryDependencies(targetLibrary: String) -> DependencyInfo? {
        guard let fileStructure = fileStructure else {
            print("Xcode 프로젝트 파일이 파싱되지 않았습니다.")
            return nil
        }

        let dependencies = fileStructure.dependencies[targetLibrary] ?? []

        return DependencyInfo(libraryName: targetLibrary, dependentLibraries: dependencies)
    }
}

extension XcodeProjectParser: XMLParserDelegate {
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        // 현재 엘리먼트에 대한 처리 로직

        // 예시: <File> 엘리먼트를 만났을 때
        if elementName == "File" {
            // 파일 이름을 가져오기
            if let fileName = attributeDict["name"] {
                // 파일 구조가 없다면 초기화
                if fileStructure == nil {
                    fileStructure = FileStructure(files: [], dependencies: [:])
                }
                
                // 파일 목록에 추가
                fileStructure?.files.append(fileName)
            }
        }
        
        // 예시: <Dependencies> 엘리먼트를 만났을 때
        if elementName == "Dependencies" {
            // 현재 처리 중인 파일의 의존성을 파싱
            guard let currentFile = fileStructure?.files.last else {
                print("Error: Found <Dependencies> without a corresponding <File> element.")
                return
            }
            
            // 의존성 목록을 가져오기
            if let dependenciesString = attributeDict["list"] {
                let dependencies = dependenciesString.components(separatedBy: ",")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                
                // 파일 구조에 의존성 추가
                fileStructure?.dependencies[currentFile] = dependencies
            }
        }
    }
}
