//
//  Context.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

import Foundation

/// Describe the place in the code.
public struct Context {

    let file: String
    let fileID: String
    let line: Int
    let column: Int
    let function: String

    public init(file: String = #file, fileID: String = #fileID, line: Int = #line, column: Int = #column, function: String = #function) {
        self.file = file
        self.fileID = fileID
        self.line = line
        self.column = column
        self.function = function
    }

    public static func here(file: String = #file, fileID: String = #fileID, line: Int = #line, column: Int = #column, function: String = #function) -> Context {
        Self.init(
            file: file,
            fileID: fileID,
            line: line,
            column: column,
            function: function
        )
    }
}

extension Context: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(fileID), L\(line):C\(column) | \(function)"
    }
}
