import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager: CoinManager = CoinManager()
    var currentCurrency: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
}

//MARK: - UIPicker
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency: String = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: currency)
        currentCurrency = currency
    }
}

//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
    func didUpdate(str: String) {
        updateUI(v: str)
    }
    
    func didEndUpWithError() {
        updateUI(v: "Error was encoutered")
    }
    
    func updateUI(v: String) {
        DispatchQueue.main.async { [self] in
            valueLabel.text = v
            currencyLabel.text = currentCurrency
        }
    }
}

