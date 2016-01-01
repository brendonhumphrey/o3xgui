import Foundation
import Cocoa
import OpenZFSInterface

class DateController : NSObject, CPTPlotDataSource {
    private let oneDay : Double = 24 * 60 * 60;
    private let oneMinute : Double = 60

    @IBOutlet var hostView : CPTGraphHostingView? = nil

    private var graph : CPTXYGraph? = nil

    private var plotData = [Double]()
    
    private var kPlotIdentifier = "Data Source Plot";
    private var kMaxDataPoints : CUnsignedInt = 52;
    private var kFrameRate : CDouble = 1.0;  // frames per second
    private var currentIndex : UInt = 0;
    
    var previousArcStatSample : ArcStatSample = ArcStatSample()
    var dataTimer : NSTimer = NSTimer()
    
    // MARK: - Initialization

    func titleSize() -> CGFloat {
        return 24.0;
    }
    
    override func awakeFromNib()
    {
//        self.plotData = newPlotData()

        // If you make sure your dates are calculated at noon, you shouldn't have to
        // worry about daylight savings. If you use midnight, you will have to adjust
        // for daylight savings time.
        let refDate = NSDateFormatter().dateFromString("12:00 Oct 29, 2009")

        // Create graph
        let newGraph = CPTXYGraph(frame: CGRectZero)

        let theme = CPTTheme(named: kCPTDarkGradientTheme)
        newGraph.applyTheme(theme)

        if let host = self.hostView {
            host.hostedGraph = newGraph;
        }

        newGraph.plotAreaFrame!.paddingTop   = titleSize() * CGFloat(0.5)
        newGraph.plotAreaFrame!.paddingRight  = titleSize() * CGFloat(0.5);
        newGraph.plotAreaFrame!.paddingBottom = titleSize() * CGFloat(2.625);
        newGraph.plotAreaFrame!.paddingLeft   = titleSize() * CGFloat(2.5);
        newGraph.plotAreaFrame!.masksToBorder = false;
        
        // Grid line styles
        let majorGridLineStyle = CPTMutableLineStyle();
        majorGridLineStyle.lineWidth = 0.75;
        majorGridLineStyle.lineColor = CPTColor(genericGray: CGFloat(0.2))

        let minorGridLineStyle = CPTMutableLineStyle();
        minorGridLineStyle.lineWidth = 0.25;
        minorGridLineStyle.lineColor = CPTColor.whiteColor().colorWithAlphaComponent(CGFloat(0.1))
        
        // Axes
        // X axis
        let axisSet = newGraph.axisSet as! CPTXYAxisSet
        let x = axisSet.xAxis
        x!.labelingPolicy        = .Automatic //CPTAxisLabelingPolicyAutomatic
        x!.orthogonalPosition    = 0.0
        x!.majorGridLineStyle    = majorGridLineStyle
        x!.minorGridLineStyle    = minorGridLineStyle
        x!.minorTicksPerInterval = 9
        x!.labelOffset           = titleSize() * CGFloat(0.25)
        x!.title                 = "X Axis";
        x!.titleOffset           = titleSize() * CGFloat(1.5)
        
        let labelFormatter = NSNumberFormatter()
        labelFormatter.numberStyle = .NoStyle
        x!.labelFormatter           = labelFormatter;
        
        // Y axis
        let y = axisSet.yAxis
        y!.labelingPolicy        = .Automatic //CPTAxisLabelingPolicyAutomatic;
        y!.orthogonalPosition    = 0.0
        y!.majorGridLineStyle    = majorGridLineStyle
        y!.minorGridLineStyle    = minorGridLineStyle
        y!.minorTicksPerInterval = 3
        y!.labelOffset           = titleSize() * CGFloat(0.25)
        y!.title                 = "Y Axis"
        y!.titleOffset           = titleSize() * CGFloat(1.25)
        y!.axisConstraints       = CPTConstraints(lowerOffset: 0.0)

        // Rotate the labels by 45 degrees, just to show it can be done.
     //   x.labelRotation = CGFloat(M_PI_4);
        
        // Create the plot
        let dataSourceLinePlot = CPTScatterPlot()
        dataSourceLinePlot.identifier     = kPlotIdentifier;
        dataSourceLinePlot.cachePrecision = .Double //CPTPlotCachePrecisionDouble;
        
        var lineStyle = dataSourceLinePlot.dataLineStyle?.mutableCopy() as! CPTMutableLineStyle
        lineStyle.lineWidth              = 3.0;
        lineStyle.lineColor              = CPTColor.greenColor()
        dataSourceLinePlot.dataLineStyle = lineStyle;
        
        dataSourceLinePlot.dataSource = self;
        newGraph.addPlot(dataSourceLinePlot)
        
        // Plot space
        let plotSpace = newGraph.defaultPlotSpace as! CPTXYPlotSpace
        plotSpace.xRange = CPTPlotRange(location:0.0, length:52.0) // (kMaxDataPoints - 2)) // - 2)))
        plotSpace.yRange = CPTPlotRange(location:0.0, length:10000.0)
        
        // Create a plot that uses the data source method
//        let dataSourceLinePlot = CPTScatterPlot(frame: CGRectZero())
//        dataSourceLinePlot.identifier = "Date Plot"

//        if let lineStyle = dataSourceLinePlot.dataLineStyle?.mutableCopy() as? CPTMutableLineStyle {
//            lineStyle.lineWidth              = 3.0
//            lineStyle.lineColor              = CPTColor.greenColor()
//            dataSourceLinePlot.dataLineStyle = lineStyle
//        }

        dataSourceLinePlot.dataSource = self
        newGraph.addPlot(dataSourceLinePlot)

        self.graph = newGraph
        
        dataTimer.invalidate()
        dataTimer = NSTimer(timeInterval: 1.0 / kFrameRate, target: self, selector: "newData", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(dataTimer, forMode: NSRunLoopCommonModes)
    }

    func newData() {
        let sample = ArcStatSample.readFromSysctl() as ArcStatSample
        let diff = sample.difference(previousArcStatSample) as ArcStatSample
        
        previousArcStatSample = sample
         NSLog("%lu %lu %lu", sample.size, sample.read, diff.read)
        
        
        let theGraph = graph
        let thePlot = theGraph?.plotWithIdentifier(kPlotIdentifier)
        
//        if ( thePlot ) {
        if ( plotData.count >= Int(kMaxDataPoints) ) {
            plotData.removeAtIndex(0)
            thePlot?.deleteDataInIndexRange(NSMakeRange(0, 1))
        }
        
        let plotSpace = theGraph?.defaultPlotSpace
        let location = (currentIndex >= UInt(kMaxDataPoints) ? currentIndex - UInt(kMaxDataPoints) + 2 : 0);
        let oldRange = CPTPlotRange(location: (location > 0) ? (location - 1) : 0, length: UInt(kMaxDataPoints) - 2)
        let newRange = CPTPlotRange(location: location, length: UInt(kMaxDataPoints) - 2)
        
        CPTAnimation.animate(
            plotSpace!,
            property: "xRange",
            fromPlotRange: oldRange,
            toPlotRange: newRange,
            duration: CGFloat(1.0/kFrameRate))
        
        currentIndex++
        
        let data = Double(sample.size) * 1.0 / (1024.0 * 1024.0)
        
        plotData.append(data)
        
        NSLog("%f %f", data, plotData[plotData.count - 1])

        thePlot?.insertDataAtIndex(UInt(plotData.count) - 1, numberOfRecords: 1)
    }
    
    /*
    func newPlotData() -> [Double]
    {
        var newData = [Double]()

        for _ in 0 ..< 5 {
            newData.append(1.2 * Double(arc4random()) / Double(UInt32.max) + 1.2)
        }
        return newData
    }
*/
    // MARK: - Plot Data Source Methods

    func numberOfRecordsForPlot(plot: CPTPlot) -> UInt
    {
        return UInt(plotData.count)
    }

    func numberForPlot(plot: CPTPlot, field: UInt, recordIndex: UInt) -> AnyObject?
    {
        var num : NSNumber = 0;
        
        switch CPTScatterPlotField(rawValue: Int(field))! {
        case .X:
            num = recordIndex + currentIndex - UInt(plotData.count);
            
        case .Y:
            num = plotData[Int(recordIndex)]
            
        default: break
        }
        
        return num;
    }
}
