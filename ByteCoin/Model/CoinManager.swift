import Foundation

protocol CoinManagerDelegate {
    func didUpdate(str: String)
    func didEndUpWithError()
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    let apiKey: String = Keys.token
    let baseURL: String = "https://rest.coinapi.io/v1/exchangerate/BTC"
    
    let currencyArray: [String] = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func constructUrl(_ c: String) -> String {
        "\(baseURL)/\(c)?apiKey=\(apiKey)"
    }
    
    func getCoinPrice(for currency: String) {
        performRequest(with: constructUrl(currency))
    }
    
    func performRequest(with url: String) {
        if let url = URL(string: url) {
            let session: URLSession = URLSession(configuration: .default)
            let handleClosure = { (data: Data?, urlResponse: URLResponse?, error: Error?) in
                if data != nil, let coin = self.parseJsonResult(data!) {
                    delegate?.didUpdate(str: coin.getValue)
                } else if error != nil { delegate?.didEndUpWithError(); return }
            }
            let task: URLSessionTask = session.dataTask(with: url, completionHandler: handleClosure)
            task.resume()
        }
    }
    
    func parseJsonResult(_ coinData: Data) -> CoinResult? {
        let decoder: JSONDecoder = JSONDecoder()
        do {
            let decodedData: CoinModel = try decoder.decode(CoinModel.self, from: coinData)
            return CoinResult(rate: decodedData.rate)
        } catch {
            delegate?.didEndUpWithError();
            return nil
        }
    }
}
