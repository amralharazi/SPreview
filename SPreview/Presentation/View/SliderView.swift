//
//  SliderView.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import SwiftUI


struct SliderView: View {
    
    // MARK: Properties
    let sliderHeight: CGFloat = 5
    
    @Binding var startAnimating: Bool
    @Binding var reset: Bool
    //    {
    //        didSet {
    //            print("rest")
    //            withAnimation {
    //                slider = 0
    //
    //            }
    //        animationDuration = 30.0
    //        }
    //    }
    @Binding var seekToSecond: CGFloat
    
    @State var slider: CGFloat = 0
    @State private var maxValue: CGFloat = UIScreen.main.bounds.width*0.95
    @State var animate = false
    
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var animationDuration: Double = 30.0
    
    @State private var startedDragging = false
    @State private var sliderWidthBeforeDragging: CGFloat = 0
    
    // MARK: Content
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack (alignment: .leading) {
                    Rectangle()
                        .foregroundStyle(Color.bienso)
                    
                    Rectangle()
                        .foregroundStyle(Color.white)
                        .frame(width: CGFloat(slider), height: sliderHeight)
                        .gesture(DragGesture(minimumDistance: 0)
                            .onChanged({ dragValue in
                                
                                if !startedDragging  {
                                    sliderWidthBeforeDragging = slider
                                }
                                startedDragging =  true
                                
                                let dragWidth = dragValue.translation.width
                                
                                slider = sliderWidthBeforeDragging + dragWidth
                                
                                // Ensure that slider stays within the desired range
                                //                                            if slider < 0 {
                                //                                                slider = 0
                                //                                            } else if slider > maxValue {
                                //                                                slider = maxValue
                                //                                            }
                                mapValue(value: slider )
                                
                            })
                                .onEnded({ _ in
                                    startedDragging =  false
                                })
                        )
                        .onReceive(timer) { _ in
                            animationDuration -= 0.1
                            if animationDuration <= 0.0 {
                                timer.upstream.connect().cancel()
                            } else {
                                withAnimation(.easeIn) {
                                    slider += maxValue/30.0/10.0
                                }
                            }
                        }
                }
                .frame(width: geometry.size.width, height: sliderHeight)
                .clipShape(RoundedRectangle(cornerRadius: sliderHeight/2))
            }
        }
        .onChange(of: startAnimating){
            if startAnimating {
                timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
            } else {
                timer.upstream.connect().cancel()
            }
        }
        .onChange(of: reset){
            print(reset)
            if reset {
                slider = 0
                timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
                startAnimating = true
                animationDuration = 30.0
            }
            reset = false
        }
        
    }
    
    // MARK: Functions
    private func mapValue(value: Double)  {
        let minValue = 0.0
        let maxMappedValue = 30.0
        
        let clampedValue = min(max(value, minValue), maxValue)
                let normalizedValue = (clampedValue - minValue) / (maxValue - minValue)
        let mappedValue = (normalizedValue * (maxMappedValue))
        
        animationDuration = 30-mappedValue
        seekToSecond = mappedValue
    }
    
}

#Preview(traits: .sizeThatFitsLayout) {
    SliderView( startAnimating: .constant(false),
                reset: .constant(false),
                seekToSecond: .constant(0))
    .frame(height: 5)
}
