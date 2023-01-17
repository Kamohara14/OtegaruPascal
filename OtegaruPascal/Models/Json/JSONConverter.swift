//
//  JSONConverter.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/11/22.
//

import Foundation

class JSONConverter {
    // URL
    let url: URL
    // 初期化時にurl格納
    init(urlString: String) {
        url = URL(string: urlString)!
    }
    // URL処理
    func resume(handler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        // URLからリクエストを作る
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: handler)
        task.resume()
    }
}
