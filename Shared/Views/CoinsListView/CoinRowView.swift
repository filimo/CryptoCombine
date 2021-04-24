//
//  CoinRowView.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 23.04.21.
//

import SwiftUI

struct CoinRowView: View {
    var coin: CoinInfo

    @ObservedObject var store = Store.shared

    private var _count: Binding<String> {
        Binding<String>(
            get: {
                "\(store.extraCoinInfoList[coin.id]?.count ?? 0)"
            },
            set: {
                ExtraCoinInfoList.setCount(coin: coin, count: Double($0) ?? 0)
            }
        )
    }

    var filterByFavorite: Bool {
        (store.onlyFavoritedCoins &&
            store.extraCoinInfoList[coin.id]?.isFavorite == true) ||
            store.onlyFavoritedCoins == false
    }

    var filterByName: Bool {
        store.coinNameFilter.isEmpty
            || (store.coinNameFilter.isEmpty == false
                && coin.symbol == store.coinNameFilter.uppercased())
    }
    
    var favoriteName: String {
        store.extraCoinInfoList[coin.id]?.isFavorite == true ? "star.fill" : "star"
    }

    init(coin: CoinInfo) {
        self.coin = coin
    }

    var body: some View {
        if filterByFavorite, filterByName {
            favoriteView
            countView
            priceView
            PercentesView(coin: coin)
        }
    }

    var favoriteView: some View {
        HStack {
            Image(systemName: favoriteName)
                .onTapGesture {
                    ExtraCoinInfoList.toggleFavorite(coin: coin)
                }

            nameView

            Spacer()
        }
    }

    var nameView: some View {
        Text("\(coin.name) (\(coin.symbol))")
            .foregroundColor(.blue)
            .onTapGesture {
                let url = "https://coinmarketcap.com/currencies/\(coin.slug)/"

                Application.openBrowser(url: url)
            }
    }

    var countView: some View {
        HStack {
            TextField("Count", text: _count)
                .frame(maxWidth: 100)

            Button(action: {
                _count.wrappedValue = Pasteboard.string
                ExtraCoinInfoList.setFavorite(coin: coin)
            }, label: {
                Image(systemName: "square.and.arrow.down.fill")
            })
        }
    }

    var priceView: some View {
        VStack {
            priceCellView(coin.quoteBTC.price)
            priceCellView(coin.totalBTC).foregroundColor(.orange)
            priceCellView(coin.priceUSD)
            priceCellView(coin.totalUSD).foregroundColor(.green)
            Text("")
        }
    }

    private func priceCellView(_ value: Double) -> some View {
        Text(NumberFormatter.fraction10Format.string(from: NSNumber(value: value)) ?? "")
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinsListView()
    }
}
