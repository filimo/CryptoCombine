//
//  ContentView.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 22.04.21.
//
import Combine
import Foundation
import SwiftUI

class Store: ObservableObject {
    typealias Output = Result<Latest, Error>

    @Published var latest = Output.success(Latest(status: Latest.Status(total_count: 0)))

    func refreshCoinsInfoToBTC() {
        if let url = Bundle.main.url(forResource: "CoinMarketCap-latest", withExtension: "json") {
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: Latest.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
                .asResult()
                .receive(on: DispatchQueue.main)
                .assign(to: &$latest)
        }
    }
}

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
