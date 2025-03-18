//
//  ViewController.swift
//  Chart
//
//  Created by Petar  on 18.3.25..
//

import UIKit
import DGCharts

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var lineChartView: LineChartView!
    @IBOutlet private weak var rnLowTextField: UITextField!
    @IBOutlet private weak var rnHighTextField: UITextField!
    @IBOutlet private weak var vLowTextField: UITextField!
    @IBOutlet private weak var vHighTextField: UITextField!
    @IBOutlet private weak var minTextField: UITextField!
    @IBOutlet private weak var maxTextField: UITextField!
    @IBOutlet private weak var applyButton: UIButton!
    
    //MARK: - Properties
    private var chartEntries: [ChartDataEntry] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setInitialConfigurationValues()
        fetchDummyData()
        updateChart()
    }
}

//MARK: - Actions
extension ViewController {
    
    @IBAction private func applyConfigTapped() {
        view.endEditing(true)
        updateChart()
    }
}

//MARK: - ChartView delegate methods
extension ViewController: ChartViewDelegate {
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        let actualScaleX = chartView.viewPortHandler.scaleX
        let isZoomedIn = actualScaleX > 1.3
        lineChartView.xAxis.valueFormatter = DateValueFormatter(isZoomedIn: isZoomedIn)
        lineChartView.notifyDataSetChanged()
    }
}

//MARK: - Private API
extension ViewController {
    
    ///This function generates 30 random double values for the next 30 hours
    private func fetchDummyData() {
        let now = Date().timeIntervalSince1970
        let interval: TimeInterval = 1 * 3600

        chartEntries = (0..<30).map { i in
            let timestamp = now + (interval * Double(i))
            return ChartDataEntry(x: timestamp, y: Double.random(in: 0...100))
        }
    }
    
    ///Updates the chart with new data and colors the data points.
    private func updateChart() {
        guard let rnLow = Double(rnLowTextField.text ?? ""), let rnHigh = Double(rnHighTextField.text ?? ""),
              let vLow = Double(vLowTextField.text ?? ""), let vHigh = Double(vHighTextField.text ?? ""),
              let minValue = Double(minTextField.text ?? ""), let maxValue = Double(maxTextField.text ?? "") else {
            AlertManager.showOkAlert(viewController: self, title: "Error", message: "Please enter valid values to input fields!")
            return
        }
        
        let dataSet = LineChartDataSet(entries: chartEntries, label: "Chart task - Petar Novakovic")
        dataSet.colors = [.black]
        dataSet.circleHoleColor = nil
        dataSet.drawCirclesEnabled = true
        dataSet.circleHoleRadius = 3
        dataSet.drawValuesEnabled = false
        
        let pointColors = chartEntries.map { entry in
            if entry.y >= rnLow && entry.y <= rnHigh {
                return UIColor.green
            } else if entry.y <= vLow || entry.y >= vHigh {
                return UIColor.red
            } else {
                return UIColor.orange
            }
        }
        dataSet.circleColors = pointColors
        
        lineChartView.leftAxis.axisMinimum = minValue
        lineChartView.leftAxis.axisMaximum = maxValue
        
        let data = LineChartData(dataSet: dataSet)
        lineChartView.data = data
    }
    
    private func setupViews() {
        applyButton.layer.cornerRadius = 10
        lineChartView.delegate = self
        lineChartView.xAxis.valueFormatter = DateValueFormatter(isZoomedIn: false)
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.granularity = 3600
        lineChartView.rightAxis.enabled = false
        lineChartView.legend.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private func setInitialConfigurationValues() {
        rnLowTextField.text = "40"
        rnHighTextField.text = "60"
        vLowTextField.text = "20"
        vHighTextField.text = "80"
        minTextField.text = "0"
        maxTextField.text = "100"
    }
}
