//
//  ChartCell.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct Cell : View {
    @Binding var value: Double
    var index: Int = 0
    var width: Float
    var numberOfDataPoints: Int
    var cellWidth: Double {
        return Double(width)/(Double(numberOfDataPoints) * 1.5)
    }
    var accentColor: Color
    var gradient: GradientColor?
    
    @State var scaleValue: Double = 0
    @Binding var touchLocation: CGFloat
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 105)
                .fill(LinearGradient(gradient: gradient?.getGradient() ?? GradientColor(start: Colors.GradientLowerGreen, end: Colors.GradientUpperGreen).getGradient(), startPoint: .bottom, endPoint: .top))
            }
            .frame(width: CGFloat(self.cellWidth))
//            .frame(height: value)
            .scaleEffect(CGSize(width: 1, height: self.scaleValue == 0.0 ? 0.02 : self.scaleValue), anchor: .bottom)
            .onAppear(){
                self.scaleValue = self.value
            }
//        .animation(Animation.spring().delay(self.touchLocation < 0 ?  Double(self.index) * 0.04 : 0))
            .animation(Animation.spring().delay(-1 < 0 ?  1 * 0.04 : 0))
            .onChange(of: value) { newVal in
                self.scaleValue = self.value
            }
    }
    
}

#if DEBUG
struct ChartCell_Previews : PreviewProvider {
    static var previews: some View {
        Cell(value: .constant(Double(0.75)), width: 320, numberOfDataPoints: 12, accentColor: Colors.OrangeStart, gradient: nil, touchLocation: .constant(-1))
    }
}
#endif
