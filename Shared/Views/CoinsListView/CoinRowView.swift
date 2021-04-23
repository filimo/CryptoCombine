//
//  CoinRowView.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 23.04.21.
//

import SwiftUI

struct CoinRowView: View {
    @Binding var coin: CoinInfo

    @ObservedObject var store = Store.shared
    @State var count: String = ""

    var body: some View {
        if filterByFavorite, filterByName {
            HStack {
                Image(systemName: coin.isFavorite == true ? "star.fill" : "star")
                    .onTapGesture {
                        CoinInfo.toggleFavorite(coin: coin)
                    }

                Text("\(coin.name) (\(coin.symbol))")

                Spacer()
            }

            TextField("Count", text: $count)
            cellView(coin.quoteBTC.price)
            cellView(coin.quoteBTC.percent_change_1h)
            cellView(coin.quoteBTC.percent_change_24h)
            cellView(coin.quoteBTC.percent_change_7d)
            cellView(coin.quoteBTC.percent_change_30d)
            cellView(coin.quoteBTC.percent_change_60d)
            cellView(coin.quoteBTC.percent_change_90d)
        }
    }

    var filterByFavorite: Bool {
        (store.onlyFavoritedCoins &&
            coin.isFavorite == true) ||
            store.onlyFavoritedCoins == false
    }

    var filterByName: Bool {
        store.coinNameFilter.isEmpty
            || (store.coinNameFilter.isEmpty == false
                    && coin.symbol.range(of: store.coinNameFilter, options: .caseInsensitive) != nil)
    }

    private func cellView(_ value: Double) -> some View {
        HStack {
            Spacer()
            Text("\(value)")
        }
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinsListView()
    }
}
