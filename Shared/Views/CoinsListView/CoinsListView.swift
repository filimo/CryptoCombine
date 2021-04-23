//
//  CoinsListView.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 23.04.21.
//

import SwiftUI

struct CoinsListView: View {
    @ObservedObject var store = Store.shared

    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.fixed(150)),
            GridItem(.fixed(150)),
            GridItem(.fixed(100)),
            GridItem(.fixed(100)),
            GridItem(.fixed(100)),
            GridItem(.fixed(100)),
            GridItem(.fixed(100)),
            GridItem(.fixed(100)),
        ]

        return ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                coinsListHeaderView

                ForEach(store.coinToBTCInfo?.data ?? [], id: \.id) { coin in
                    CoinRowView(coin: coin)
                }
            }
        }
    }

    @ViewBuilder
    private var coinsListHeaderView: some View {
        Text("Name")
        Text("Count")
        Text("Price")
        Text("1h")
        Text("24h")
        Text("7d")
        Text("30d")
        Text("60d")
        Text("90d")
    }
}

struct CoinsListView_Previews: PreviewProvider {
    static var previews: some View {
        CoinsListView()
    }
}
