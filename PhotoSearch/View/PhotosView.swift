//
//    PhotosView.swift
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


import SwiftUI

struct PhotosView: View {
    @StateObject var store = PhotoStore()
    @State var text = ""

    @Environment(\.isSearching)
    private var isSearching: Bool

    var body: some View {
        NavigationView {
            PhotosListView(store: store)
                .navigationTitle("Photos")
                .searchable(text: $text) {
                    ForEach(store.suggestions, id: \.self) { suggestion in
                        Text(suggestion)
                            .searchCompletion(suggestion)
                    }
                }
                .onSubmit(of: .search) {
                    async {
                        await store.search(with: text)
                    }
                }
        }
        .refreshable {
            await store.update(with: text)
        }
        .task {
            await store.load()
        }
    }
}

struct PhotosListView: View {
    @ObservedObject var store: PhotoStore

    var body: some View {
        if store.isLoading {
            ProgressView()
        } else {
            List {
                ForEach(store.photos) { photo in
                    PhotoRowView(photo: photo)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0.5,
                                                  leading: .zero,
                                                  bottom: 0.5,
                                                  trailing: .zero))
                }
            }.listStyle(.plain)
        }

    }
}

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosView()
    }
}
