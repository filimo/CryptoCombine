//
//  ContentView.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 22.04.21.
//
import Foundation
import SwiftUI

struct ContentView: View {
    @ObservedObject var store = Store.shared

    var body: some View {
        VStack {
            HStack {
                TextField("CMC_PRO_API_KEY", text: $store.CMC_PRO_API_KEY)
                    .frame(maxWidth: 200)

                Button("Refresh") {
                    store.refreshCoinsInfo(convert: "BTC")
                    store.refreshCoinsInfo(convert: "USD")
                }

                coinsStatusView
                    .padding()

                Toggle("Favorite", isOn: $store.onlyFavoritedCoins)
                    .toggleStyle(SwitchToggleStyle(tint: .green))

                TextField("Input coin name", text: $store.coinNameFilter)
                    .frame(maxWidth: 100)

                Button(action: {
                    store.coinNameFilter = Pasteboard.string
                }, label: {
                    Image(systemName: "square.and.arrow.down.fill")
                })
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

//                for coin in coinsInfo.data {
//                    if let index = store.coinToBTCInfo?.data.firstIndex(where: { $0.id == coin.id }) {
//                        coinsInfo.data[index].quote[""] = store.coinToUSDInfo?.data
//                    }
//                }
            }
        })
        .onReceive(store.$coinToUSDInfoPublisher, perform: { coinsInfo in
            if var coinsInfo = try? coinsInfo.get() {
                coinsInfo.sortedByName()
                store.coinToUSDInfo = coinsInfo

//                for coin in coinsInfo.data {
//                    if let index = store.coinToBTCInfo?.data.firstIndex(where: { $0.id == coin.id }) {
//                        coinsInfo.data[index].quote[""] = store.coinToUSDInfo?.data
//                    }
//                }
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
