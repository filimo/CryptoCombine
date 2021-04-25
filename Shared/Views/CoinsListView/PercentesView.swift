//
//  PercentesView.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 24.04.21.
//

import SwiftUI

struct PercentesView: View {
    let coin: CoinInfo
    
    var body: some View {
        percentCellView(btcPercent: coin.quoteBTC.percent_change_1h, usdPercent: coin.quoteUSD.percent_change_1h)
        percentCellView(btcPercent: coin.quoteBTC.percent_change_24h, usdPercent: coin.quoteUSD.percent_change_24h)
        percentCellView(btcPercent: coin.quoteBTC.percent_change_7d, usdPercent: coin.quoteUSD.percent_change_7d)
        percentCellView(btcPercent: coin.quoteBTC.percent_change_30d, usdPercent: coin.quoteUSD.percent_change_30d)
        percentCellView(btcPercent: coin.quoteBTC.percent_change_60d, usdPercent: coin.quoteUSD.percent_change_60d)
        percentCellView(btcPercent: coin.quoteBTC.percent_change_90d, usdPercent: coin.quoteUSD.percent_change_90d)
    }
    
    private func percentCellView(btcPercent: Double, usdPercent: Double) -> some View {
        let priceBTC = coin.quoteBTC.price + coin.quoteBTC.price * btcPercent / 100
        let upPriceUSD = coin.quoteUSD.price / (usdPercent / 100)
        let downPriceUSD = (coin.quoteUSD.price - coin.quoteUSD.price * usdPercent / 100)
        let priceUSD = usdPercent > 0 ? upPriceUSD : downPriceUSD
        let totalUSD = priceUSD * coin.count

        return VStack(alignment: .trailing) {
            Text(NumberFormatter.fraction10Format.string(from: NSNumber(value: priceBTC)) ?? "")

            Text(NumberFormatter.fraction2Format.string(from: NSNumber(value: btcPercent)) ?? "")
                .foregroundColor(.orange)

            Text(NumberFormatter.fraction10Format.string(from: NSNumber(value: priceUSD)) ?? "")

            Text(NumberFormatter.fraction2Format.string(from: NSNumber(value: usdPercent)) ?? "")
                .foregroundColor(.green)

            Text(NumberFormatter.fraction2Format.string(from: NSNumber(value: totalUSD)) ?? "")
        }
    }
}

struct PercentsView_Previews: PreviewProvider {
    static var previews: some View {
        CoinsListView()
    }
}
