//
//    PhotoStore.swift
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

class PhotoStore: ObservableObject {
    @Published
    var photos: [Photo] = []
    @Published
    var isLoading: Bool = true
    let service: PhotoService
    let suggestions = ["Portrait", "Fashion", "Architecture", "Minimal", "Nature", "Sports"]

    init(service: PhotoService = PhotoService()) {
        self.service = service
    }

    func load() async {
        do {
            photos = try await service.searchPhotos()
            isLoading = false
        } catch {
            print(error)
        }
    }

    func update(with query: String) async {
        do {
            await DispatchQueue.main.wait()
            photos = try await service.searchPhotos(query: query)
        } catch {
            print(error)
        }
    }

    func search(with query: String) async {
        do {
            isLoading = true            
            photos = try await service.searchPhotos(query: query)
            isLoading = false
        } catch {
            print(error)
        }
    }
}
