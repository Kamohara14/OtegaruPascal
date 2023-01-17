//
//  APIServiceError.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/12/06.
//

import Foundation

// エラー準拠
enum APIServiceError: Error {
    // URLが不正である
    case invalidURL
    // APIレスポンスにエラーが発生
    case responseError
    // JSONのパース時にエラーが発生
    case parseError(Error)
}
