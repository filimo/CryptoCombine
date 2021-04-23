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

    private var count: Binding<String> {
        Binding<String>(
            get: {
                "\(store.extraCoinInfoList[coin.id]?.count ?? 0)"
            },
            set: {
                ExtraCoinInfoList.setCount(coin: coin, count: Double($0) ?? 0)
            }
        )
    }

    static let priceFormat: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        return formatter
    }()

    init(coin: CoinInfo) {
        self.coin = coin
    }

    var body: some View {
        if filterByFavorite, filterByName {
            HStack {
                Image(systemName: store.extraCoinInfoList[coin.id]?.isFavorite == true ? "star.fill" : "star")
                    .onTapGesture {
                        ExtraCoinInfoList.toggleFavorite(coin: coin)
                    }

                Text("\(coin.name) (\(coin.symbol))")

                Spacer()
            }

            HStack {
                TextField("Count",
                          text: count)
                    .frame(maxWidth: 100)

                Button(action: {
                    count.wrappedValue = Pasteboard.string
                    ExtraCoinInfoList.setFavorite(coin: coin)
                }, label: {
                    Image(systemName: "square.and.arrow.down.fill")
                })
            }

            priceCellView(coin.quoteBTC.price)
            percentCellView(coin.quoteBTC.percent_change_1h)
            percentCellView(coin.quoteBTC.percent_change_24h)
            percentCellView(coin.quoteBTC.percent_change_7d)
            percentCellView(coin.quoteBTC.percent_change_30d)
            percentCellView(coin.quoteBTC.percent_change_60d)
            percentCellView(coin.quoteBTC.percent_change_90d)
        }
    }

    var filterByFavorite: Bool {
        (store.onlyFavoritedCoins &&
            store.extraCoinInfoList[coin.id]?.isFavorite == true) ||
            store.onlyFavoritedCoins == false
    }

    var filterByName: Bool {
        store.coinNameFilter.isEmpty
            || (store.coinNameFilter.isEmpty == false
                && coin.symbol.range(of: store.coinNameFilter, options: .caseInsensitive) != nil)
    }

    private func priceCellView(_ value: Double) -> some View {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.minimumFractionDigits = 10
        numberFormatter.maximumFractionDigits = 10
        
        numberFormatter.string(from: NSNumber(value: value))

        return HStack {
            Spacer()
            Text(numberFormatter.string(from: NSNumber(value: value)) ?? "")
        }
    }

    private func percentCellView(_ value: Double) -> some View {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        numberFormatter.string(from: NSNumber(value: value))

        return HStack {
            Spacer()
            Text(numberFormatter.string(from: NSNumber(value: value)) ?? "")
        }
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinsListView()
    }
}
