//
//  APIService.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/12/06.
//

import Foundation
import Combine

protocol APIServiceType {
    // Request型を受け取る
    func request<Request>(with request: Request)
    // パブリッシャー(Deocdable、APIServiceError)
    -> AnyPublisher<Request.Response, APIServiceError>
    // Request型をAPIRequestTypeに準拠
    where Request: APIRequestType
}

final class APIService: APIServiceType {
    
    // ベースのURL
    private let baseURLString: String
    
    // インスタンス生成時にURLをセット
    init(baseURLString: String = "https://api.openweathermap.org") {
        self.baseURLString = baseURLString
    }
    
    // リクエスト
    func request<Request>(with request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request : APIRequestType {
        // URLを作成する
        guard let pathURL = URL(string: request.path, relativeTo: URL(string: baseURLString)) else {
            // エラーを返す(不正なURL)
            return Fail(error: APIServiceError.invalidURL).eraseToAnyPublisher()
        }
        
        // urlComponents(作成したpathURLを使用、BaseURLを使用しているためtrue)
        var urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)!
        // 取ってきたqueryItemsを入れる
        urlComponents.queryItems = request.queryItems
        
        // パラメータが付いた状態のURLをリクエストとして受け取る
        var request = URLRequest(url: urlComponents.url!)
        // Content-Typeをjsonにする
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // デコーダー
        let decorder = JSONDecoder()
        // JSONのスネークケースをSwift側が自動的でキャメルケースにしてparseしてくれる
        decorder.keyDecodingStrategy = .convertFromSnakeCase
        
        // URLSessionのPublisherを実行
        return URLSession.shared.dataTaskPublisher(for: request)
        // mapでレスポンスデータのストリームに変換(レスポンスデータは使わない)
        .map { data, urlResponse in
            return data
        }
        // エラーが起きたらresponseErrorを返す
        .mapError { _ in
            APIServiceError.responseError
        }
        // JSONからデータオブジェクトにデコード
        .decode(type: Request.Response.self, decoder: decorder)
        // エラーが起きたらparseErrorを返す
        .mapError{ error in
            APIServiceError.parseError(error)
        }
        // ストリームをメインスレッドに流れるように変換
        .receive(on: RunLoop.main)
        // PublisherをAnyPublisherにする
        .eraseToAnyPublisher()
        
    }
    
}
