//
//  Store.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 22.04.21.
//
import Combine
import CoreData
import Foundation

class Store: ObservableObject {
    private init() {
        let didSaveNotification = NSManagedObjectContext.didMergeChangesObjectIDsNotification
           NotificationCenter.default.addObserver(self, selector: #selector(didSave(_:)),
                                                   name: didSaveNotification, object: nil)
    }
    static let shared = Store()

    typealias Output = Result<CoinsInfo, Error>

    @Published private(set) var coinToBTCInfoPublisher = Output.failure(CustomError.empty)
    @Published private(set) var coinToUSDInfoPublisher = Output.failure(CustomError.empty)

    @Published var coinNameFilter = ""

    @Published var coinsInfo: CoinsInfo? = nil

    @Published var extraCoinInfoList: ExtraCoinInfoList = [:]

    @Published var onlyFavoritedCoins = false
    @Published(key: "CMC_PRO_API_KEY") var CMC_PRO_API_KEY = ""

    private var coinsCanellable: AnyCancellable?

    var persistenceController: PersistenceController {
        PersistenceController.shared
    }

    var viewContext: NSManagedObjectContext {
        persistenceController.container.viewContext
    }

    func requestCoinsInfo(convert: String) -> URLRequest {
        let urlString = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest"

        var components = URLComponents(string: urlString)!

        components.queryItems = [
            URLQueryItem(name: "start", value: "1"),
            URLQueryItem(name: "limit", value: "5000"),
            URLQueryItem(name: "convert", value: convert)
        ]

        var request = URLRequest(url: components.url!)

        request.setValue(CMC_PRO_API_KEY, forHTTPHeaderField: "X-CMC_PRO_API_KEY")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }

    func refreshCoinsInfo(convert: String) {
        let request = requestCoinsInfo(convert: convert)

//        guard let url = URL(string: urlString) else {
//            coinToBTCInfoPublisher = Output.failure(CustomError.fileNotFound(urlString))
//            return
//        }

        switch convert {
        case "USD":
            URLSession.shared.dataTaskPublisher(for: request)
                .asResult()
                .receive(on: DispatchQueue.main)
                .assign(to: &$coinToUSDInfoPublisher)
        default:
            URLSession.shared.dataTaskPublisher(for: request)
                .asResult()
                .receive(on: DispatchQueue.main)
                .assign(to: &$coinToBTCInfoPublisher)
        }
    }
    
    @objc func didSave(_ notification: Notification) {
      // handle the save notification
      let insertedObjectsKey = NSManagedObjectContext.NotificationKey.insertedObjects.rawValue
      print(notification.userInfo?[insertedObjectsKey])
    }
}

extension Store {
    private func latestPublisher(convert: String) -> AnyPublisher<Data, URLSession.DataTaskPublisher.Failure> {
        URLSession.shared
            .dataTaskPublisher(for: Store.shared.requestCoinsInfo(convert: "BTC"))
            .map(\.data)
            .eraseToAnyPublisher()
    }

    private func latestRealPublisher() -> AnyPublisher<(Data, Data), URLSession.DataTaskPublisher.Failure> {
        Publishers.CombineLatest(latestPublisher(convert: "BTC"), latestPublisher(convert: "USD"))
            .eraseToAnyPublisher()
    }

    private func latestMockPublisher() -> AnyPublisher<(Data, Data), Just<Data>.Failure> {
        Publishers.CombineLatest(Just(Coins.btcMock), Just(Coins.usdMock))
            .eraseToAnyPublisher()
    }

    func requestToCoinMarketCap() {
        coinsCanellable =
//            latestRealPublisher()
            latestMockPublisher()
            .sink(
                receiveCompletion: { error in
                    print(error)
                },
                receiveValue: { btcData, usdData in
                    do {
                        try self.viewContext.execute(Coins.removeAllRequest)

                        Coins.decoder.userInfo[.managedObjectContext] = self.viewContext

                        _ = try Coins.decoder.decode(Coins.self, from: btcData)
                        _ = try Coins.decoder.decode(Coins.self, from: usdData)

                        try self.viewContext.save()
                    } catch {
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                })
    }

    func removeAllCoins() {
        do {
            try viewContext.execute(Coins.removeAllRequest)
        } catch {
            print(error)
        }
    }
}
