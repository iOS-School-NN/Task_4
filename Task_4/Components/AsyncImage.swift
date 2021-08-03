//
//  AsyncImage.swift
//  task3
//
//  Created by R S on 31.07.2021.
//
import SwiftUI

struct AsyncImage: View {
    @StateObject private var loader: ImageLoader
    private let image: (UIImage) -> Image
    
    init(url: URL, @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)) {
           _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
        self.image = image
       }

    var body: some View {
        content
            .onAppear(perform: loader.load)
    }

    private var content: some View {
        Group {
            if loader.image != nil {
                image(loader.image!)

            } else {
                ActivityIndicator()
            }
        }
    }
}
