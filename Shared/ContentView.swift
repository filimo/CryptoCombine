//
//  ContentView.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 22.04.21.
//
import SwiftUI

struct ContentView: View {
    @StateObject var store = Store()

    var body: some View {
        VStack {
            Button("Refresh") {
                store.refreshCoinsInfoToBTC()
            }
            .padding()

            switch store.coinToBTCInfo {
            case .success(let result):
                Text("\(result.status.total_count)")
                    .padding()
            case .failure(let error):
                if let error = error as? CustomError,
                   error == .empty {
                    Text("0")
                } else {
                    Text("\(error.localizedDescription)")
                        .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
