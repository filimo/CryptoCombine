//
//  ContentView.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 22.04.21.
//
import SwiftUI

struct ContentView: View {
    @StateObject var store = Store.shared

    var body: some View {
        VStack {
            HStack {
                Button("Refresh") {
                    store.refreshCoinsInfoToBTC()
                }

                coinsStatusView
                    .padding()

                Toggle("Favorite", isOn: $store.onlyFavoritedCoins)
                    .toggleStyle(SwitchToggleStyle(tint: .green))

                TextField("Input coin name", text: $store.coinNameFilter)
                    .frame(maxWidth: 100)
            }
            .padding([.horizontal, .top])

            CoinsListView()
                .padding([.horizontal, .bottom])
        }
        .frame(minWidth: 500, minHeight: 500)
        .onReceive(store.$coinToBTCInfoPublisher, perform: { coinsInfo in
            if var coinsInfo = try? coinsInfo.get() {
                coinsInfo.sortedByName()
                store.coinToBTCInfo = coinsInfo
            }
        })
    }

    @ViewBuilder
    private var coinsStatusView: some View {
        switch store.coinToBTCInfoPublisher {
        case .success:
            Text("\(store.coinToBTCInfo?.status.total_count ?? 0)")
        case .failure(let error):
            if let error = error as? CustomError,
               error == .empty
            {
                Text("\(store.coinToBTCInfo?.status.total_count ?? 0)")
            } else {
                Text("\(error.localizedDescription)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
