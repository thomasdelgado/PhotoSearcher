//
//    PhotoService.swift
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

class PhotoService {
    let url = "https://api.unsplash.com/photos/"
    let searchUrl = "https://api.unsplash.com/search/photos/"
    let clientKey = "client_id"
    let queryKey = "query"

    func searchPhotos(query: String = "") async throws -> [Photo] {
        if query.isEmpty {
            return try await photos()
        } else {
            return try await photos(query: query)
        }
    }

    private func photos() async throws -> [Photo] {
        let clientId: String = try EnvManager.value(for: ConfigKeys.unsplashClientId)
        let parameters: Parameters = [clientKey: clientId]
        let request = try Request(url: url, method: .get(parameters))
        let (data, response) = try await URLSession.shared.data(for: request.urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == StatusCode.ok else { throw NetworkError.requestFailed }
        return try JSONDecoder().decode([Photo].self, from: data)
    }

    private func photos(query: String) async throws -> [Photo] {
        let clientId: String = try EnvManager.value(for: ConfigKeys.unsplashClientId)
        let parameters: Parameters = [clientKey: clientId,
                                        "query": query]
        let request = try Request(url: searchUrl, method: .get(parameters))
        let (data, response) = try await URLSession.shared.data(for: request.urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == StatusCode.ok else { throw NetworkError.requestFailed }
        return try JSONDecoder().decode(PhotoSearchResult.self, from: data).results
    }
}
