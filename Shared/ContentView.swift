//
//  ContentView.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 22.04.21.
//
import SwiftUI

struct ContentView: View {
    @StateObject var store = Store()

    @State var latest: Latest?

    var body: some View {
        VStack {
            Button("Refresh") {
                store.refreshCoinsInfoToBTC()
            }
            .padding()

            switch store.latest {
            case .success(let result):
                Text("\(result.status.total_count)")
                    .padding()
            case .failure(let error):
                Text("\(error.localizedDescription)")
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
