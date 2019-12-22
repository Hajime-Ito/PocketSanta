//
//  WebAPI.swift
//  PocketSanta
//
//  Created by hajime ito on 2019/12/19.
//  Copyright © 2019 hajime. All rights reserved.
//

import Foundation

typealias Input = Request

enum HTTPMethodAndPayload {
    // GETメソッドの定義
    case get
    
    // Method名を返す
    var method: String {
        switch self {
        case .get:
            return "GET"
        }
    }
    
    var body: Data? {
        switch self {
        case .get:
            // GETにはPayloadはないのでnil
            return nil
        }
    }
}

typealias Request = (
    url: URL,
    // クエリ文字列。URLQueryItemという標準のクラスを使用している。
    queries: [URLQueryItem],
    // ヘッダー情報。ヘッダー名と値の辞書になっている。
    headers: [String: String],
    // HTTPMethodとPayloadの組み合わせ。GETにはPayloadはない。
    methodAndPayload: HTTPMethodAndPayload
)

enum Output {
    // Responseがある場合
    case hasResponse(Response)
    // Responseがない場合
    case noResponse(ConnectionError)
}

enum ConnectionError {
    // 予期しない形のResponseが返ってきた場合
    case malformedURL(debugInfo: String)
    // DataやResponseがない場合
    case noDataOrResponse(debugInfo: String)
}

typealias Response = (
    statusCode: HTTPStatus,
    headers: [String: String],
    payload: Data
)

enum HTTPStatus {
    case ok
    case notFound
    case unsupported(code: Int)
    
    static func from(code: Int) -> HTTPStatus {
        switch code {
        // 200が返ってきた場合は成功
        case 200:
            return .ok
        // 404が返ってきた場合はnotFound
        case 404:
            return .notFound
        // それ以外の時はそのままcodeを返す
        default:
            return .unsupported(code: code)
        }
    }
}

enum WebAPI {
    /* Swiftでは同じ関数名でも、引数が違えば定義可能 */
    
    static func call(with input: Input) {
        // 下のクロージャを引数にもつ func call(input, block: ()->() in ...)をう呼び出している。
        self.call(with: input) { _ in
            // 何もしない
        }
    }
    
    // @escapingは非同期呼び出しを明示的にするために必要な印
    // 引数の最後がクロージャな場合は以下のように処理部分を外に書くことができる(Trailing Closure)
    static func call(with input: Input, _ block: @escaping (Output) -> Void) {
        // requestオブジェクトを受け取る。
        let urlRequest = self.createURLRequest(by: input)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
            // URLSession.shared.dataTask()の呼び出し先の処理が終わった後に実行される。
            // つまりレスポンスが返ってきた後に実行される(非同期)
            let output = self.createOutput(
                data: data,
                urlResponse: urlResponse as? HTTPURLResponse,
                error: error)
            
            // コールバックに Outputオブジェクトを返す。
            block(output)
        }
        
        // サーバとの通信を始める。(こっちの方がblock(output)より先に実行される。)
        task.resume()
    }
    
    // input情報からrequestオブジェクトを生成して返す
    static private func createURLRequest(by input: Input) -> URLRequest {
        // inputの中のurlをrequestのurlとして指定
        // requestを生成
        var request = URLRequest(url: input.url)
        // HTTPMethodを指定
        request.httpMethod = input.methodAndPayload.method
        // リクエストボディを指定
        request.httpBody = input.methodAndPayload.body
        // Headerファイルを指定
        request.allHTTPHeaderFields = input.headers
        return request
    }
    
    // data, urlResponse, error情報から適切なOutputを返す。
    // data, urlResponse, errorはそれぞれない場合があるので全てOptional型
    static private func createOutput(data: Data?, urlResponse: HTTPURLResponse?, error: Error?) -> Output {
        // data, responseが存在しない場合。
        guard let data = data, let response = urlResponse else {
            // Outputの中のnoResponse(ConnectionError)を返す。
            // .noDataOrResponseはConnectionErrorの中の一つの要素でdebugInfoを引数にもつ。
            return .noResponse(.noDataOrResponse(debugInfo: error.debugDescription))
        }
        // data, responseが存在する場合。
        
        // 初期化
        var headers: [String: String] = [:]
        // レスポンスのヘッダ情報は全て[String:String]の辞書型に入れる
        for (key, value) in response.allHeaderFields.enumerated() {
            headers[key.description] = String(describing: value)
        }
        
        // Outputの中のhasResponseを返す
        return .hasResponse((
            statusCode: .from(code: response.statusCode),
            headers: headers,
            payload: data
        ))
    }
}

