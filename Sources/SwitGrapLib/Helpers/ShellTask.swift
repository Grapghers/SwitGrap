import Foundation

protocol ShellTask {

    /// 명령의 원시 쉘 표현입니다.
    var stringRepresentation: String { get }

    /// 명령을 찾을 수 없을 때 표시할 로컬라이즈된 문자열입니다.
    var commandNotFoundInstructions: String { get }

}

extension ShellTask {

    @discardableResult
    func execute() throws -> String {
        let task = Process()
        let stdout = Pipe()
        let stderr = Pipe()

        task.standardOutput = stdout
        task.standardError = stderr
        task.arguments = ["-c", stringRepresentation]
        task.launchPath = "/bin/bash"
        task.launch()

        Log(stringRepresentation, dim: true)

        let output = stdout.fileHandleForReading.readDataToEndOfFile()
        let errorOutput = stderr.fileHandleForReading.readDataToEndOfFile()

        task.waitUntilExit()

        if task.terminationStatus == 0 {
            return String(data: output, encoding: .utf8)!
        } else if task.terminationStatus == 127 {
            LogError(commandNotFoundInstructions)
            throw CommandError.commandNotFound(message: commandNotFoundInstructions)
        } else {
            LogError("명령이 종료 코드 \(task.terminationStatus)로 실패했습니다.")
            throw CommandError.failure(stderr: String(data: errorOutput, encoding: .utf8)!)
        }
    }

}

enum CommandError: LocalizedError {

    case failure(stderr: String)
    case commandNotFound(message: String)

    var errorDescription: String? {
        switch self {
        case let .failure(stderr): return stderr
        case let .commandNotFound(message): return message
        }
    }

}
