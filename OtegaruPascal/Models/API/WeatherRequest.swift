//
//  WeatherRequest.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/12/06.
//

import Foundation

protocol APIRequestType {
    associatedtype Response: Decodable
    
    // プロパティ(getのみ)
    var path: String { get }
    
    // (無い可能性がある)
    var queryItems: [URLQueryItem]? { get }
}

struct WeatherRequest: APIRequestType {
    typealias Response = WeatherResponse

    private let lat: String
    private let lon: String
    
    // プロパティ(URLの基本部分。今回はonecallを使用する)
    var path = "/data/2.5/onecall"
    
    // URL組み立て
    var queryItems: [URLQueryItem]?
    
    // URL組み立て(現在地から緯度経度を取得する)
    init(lat: String, lon: String) {
        self.lat = lat
        self.lon = lon
        print("lat: \(lat) lon: \(lon)")
        self.queryItems = [
            // .initでURLQueryItemのインスタンスを作っている
            // 緯度
            .init(name: "lat", value: lat),
            // 経度
            .init(name: "lon", value: lon),
            // 除外するパラメータ(1時間ごとのデータのみとる)
            .init(name: "exclude", value: "current,minutely,daily"),
            // 表示形式(温度を摂氏で取る)
            .init(name: "units", value: "metric"),
            // 言語(日本語)
            .init(name: "lang", value: "ja"),
            // APIKey
            //.init(name: "appid", value: "91eaa4d57444ba4830a20c875ac4b764")
            .init(name: "appid", value: infoForKey("OpenWeatherAPIKey"))
        ]
    }
    
    // APIKeyを取得する
    private func infoForKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)
    }
}
