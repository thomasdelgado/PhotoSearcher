//
//    PhotoRowView.swift
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

struct PhotoRowView: View {
    var photo: Photo

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: photo.smallPhotoURL, content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }, placeholder: {
                randomPlaceholderColor()
                    .opacity(0.1)
            })
            .frame(minHeight: photoHeight)
            .overlay(ImageGradient())
            Text(photo.user?.name ?? "")
                .font(.headline)
                .foregroundColor(.white)
                .shadow(radius: 10)
                .padding()
        }
        .edgesIgnoringSafeArea(.all)
    }

    var photoHeight: CGFloat {
        guard let width = photo.width,
              let height = photo.height else { return 0 }
        return CGFloat(height) * UIScreen.main.bounds.width / CGFloat(width)
    }

    func randomPlaceholderColor() -> Color {
        placeholderColors.randomElement()!
    }

    let placeholderColors: [Color] = [
        .red, .blue, .orange, .mint, .purple, .yellow, .green, .pink
    ]
}

struct PhotoRowView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoRowView(photo: Photo.mock)
    }
}
