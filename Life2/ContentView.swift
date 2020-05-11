//
//  ContentView.swift
//  Life2
//
//  Created by Work on 5/5/20.
//  Copyright © 2020 Isaac Ruiz. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    
    func tap(id: UUID) -> some Gesture {
        TapGesture()
            .onEnded { _ in
                self.viewModel.notify(.tappedCell(id))
            }
    }
    
    var body: some View {

        return VStack {
            Text(self.viewModel.detlaString)
            GridStack(
                rows: self.viewModel.height,
                columns: self.viewModel.width,
                values:  self.$viewModel.cellState) { value in
                    Circle()
                        .fill( value.isAlive ? Color.white : Color.black)
                        .frame(width: 10, height: 10)
                        .gesture(self.tap(id: value.id))
                        .animation(.linear(duration: 1.0))
                    
            }
        }
    }
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    @Binding var values: [Cell]
    let content: (Cell) -> Content

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0 ..< rows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0 ..< self.columns, id: \.self) { column -> Content in
                        let index = row * self.columns + column
                        return self.content(index >= self.values.count ? .dead() : self.values[index])
                    }
                }
            }
        }
    }
}
