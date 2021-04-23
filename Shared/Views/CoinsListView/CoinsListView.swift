//
//  CoinsListView.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 23.04.21.
//

import SwiftUI

struct CoinsListView: View {
    @StateObject var store = Store.shared

    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]

        return ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                coinsListHeaderView

                ForEach(store.coinToBTCInfo?.data ?? [], id: \.id) { coin in
                    CoinRowView(coin: .constant(coin))
                }
            }
        }
    }

    @ViewBuilder
    private var coinsListHeaderView: some View {
        Text("Name")
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
