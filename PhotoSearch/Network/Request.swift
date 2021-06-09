//
//    Request.swift
//    Places
//    Created by Thomas Delgado on 08/06/21
//
//    MIT License
//
//    Copyright (c) 2021 Thomas Delgado. All rights reserved.
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.
        

import Foundation

public struct Request {
    let url: URL
    let method: HttpMethod
    var headers: [String: String] = [:]

    public init(url: String, method: HttpMethod, headers: [String: String] = [:]) throws {
        guard let url = URL(string: url) else { throw NetworkError.invalidURL }
        self.url = url
        self.method = method
        self.headers = headers
    }
}

public extension Request {
    var urlRequest: URLRequest {
        var request = URLRequest(url: url)

        switch method {
        case .post(let parameters), .put(let parameters):
            request.httpBody = encode(parameters)
        case .get(let parameters):
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value as? String)
            }
            guard let url = components?.url else {
                preconditionFailure("Couldn't create a url from components...")
            }
            request = URLRequest(url: url)
        default:
            break
        }

        request.allHTTPHeaderFields = headers
        request.httpMethod = method.name
        return request
    }

    private func encode(_ parameters: Parameters?) -> Data? {
        if let parameters = parameters {
            do {
                return try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch let error {
                debugPrint(error)
            }
        }
        return nil
    }
}

public typealias Parameters = [String: Any]

public enum HttpMethod {
    case get(Parameters)
    case put(Parameters?)
    case post(Parameters?)
    case delete
    case head

    var name: String {
        switch self {
        case .get: return "GET"
        case .put: return "PUT"
        case .post: return "POST"
        case .delete: return "DELETE"
        case .head: return "HEAD"
        }
    }
}
