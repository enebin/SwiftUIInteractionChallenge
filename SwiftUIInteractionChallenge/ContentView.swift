//
//  ContentView.swift
//  SwiftUIInteractionChallenge
//
//  Created by Enebin on 11/7/23.
//

import SwiftUI

struct ContentView: View {
    let circlesData = [
        CircleData(
            label: "Expressive",
            coordinate: (x: -0.2209559268150387, y: -0.6597031040497751),
            radius: 0.16753215819093129),
        CircleData(
            label: "Funny",
            coordinate: (x: 0.3864041646343055, y: 0.6054490800846822),
            radius: 0.2817543825249447),
        CircleData(
            label: "Extrovert",
            coordinate: (x: -0.5711411358905634, y: -0.23634056797191685),
            radius: 0.381890736863092),
        CircleData(
            label: "Positive",
            coordinate: (x: -0.26152337336370673, y: 0.46187070430546906),
            radius: 0.381890736863092),
        CircleData(
            label: "Sensitive",
            coordinate: (x: 0.3709271337823364, y: -0.23634056797191685),
            radius: 0.5601775328098079)
    ]

    let widthUnit: CGFloat = 400
    
    @State var circlePadding: CGFloat = 50
    @State var isSheetDragging = false
    @State var showItem: CircleData?
    @Namespace var animation
    
    var body: some View {
        ZStack {
            ForEach(circlesData) { datum in
                circleItem(data: datum)
                    .onTapGesture {
                        showItem = datum
                    }
            }
            .zIndex(ZIndex.low.rawValue)
            
            if let item = showItem {
                BackgroundBlurringView(style: .light)
                    .ignoresSafeArea()
                    .zIndex(ZIndex.middle.rawValue)
                
                detailView(data: item)
                    .zIndex(ZIndex.high.rawValue)
            }
        }
        .animation(.spring, value: showItem)
        .animation(isSheetDragging ? nil : .spring, value: circlePadding)
    }
    
    func circleItem(data: CircleData) -> some View {
        Circle()
            .foregroundStyle(.blue.opacity(0.4))
            .overlay {
                Text(data.label).font(.caption2)
            }
            .matchedGeometryEffect(id: data.id.uuidString, in: animation)
            .frame(width: data.radius * widthUnit)
            .offset(
                x: data.coordinate.x * widthUnit / 2,
                y: data.coordinate.y * widthUnit / 2)
    }
    
    func detailView(data: CircleData) -> some View {
        VStack(alignment: .center) {
            Circle()
                .foregroundStyle(.blue)
                .overlay {
                    Text(data.label).font(.title)
                }
                .matchedGeometryEffect(id: data.id.uuidString, in: animation)
                .frame(
                    width: max(150, widthUnit - circlePadding),
                    height: max(150, widthUnit - circlePadding))
                .onTapGesture {
                    self.showItem = nil
                }
            
            Spacer().frame(minHeight: 5, maxHeight: 30)
            
            CustomBottomSheet(
                sheetHeightOffset: $circlePadding,
                isSheetDragging: $isSheetDragging,
                onDismiss: { showItem = nil }
            ) {
                ScrollView {
                    ForEach(0..<10) { Text("\($0)") }
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    private enum ZIndex: CGFloat {
        case high = 3
        case middle = 2
        case low = 0
    }
}

struct CustomBottomSheet<Content>: View where Content: View {
    @Binding var sheetHeightOffset: CGFloat
    @Binding var isSheetDragging: Bool
    
    @State private var sheetPosition: SheetPosition = .middle
    
    let content: Content
    let onDismiss: () -> Void
    let defaultOffset: CGFloat
    
    init(
        sheetHeightOffset: Binding<CGFloat>,
        isSheetDragging: Binding<Bool>,
        defaultOffset: CGFloat = 50,
        onDismiss: @escaping () -> Void,
        @ViewBuilder content: () -> Content)
    {
        self._sheetHeightOffset = sheetHeightOffset
        self._isSheetDragging = isSheetDragging
        self.onDismiss = onDismiss
        self.content = content()
        
        self.defaultOffset = defaultOffset
        self.sheetHeightOffset = defaultOffset
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                self.handle()
                    .padding(.vertical, 7)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                isSheetDragging = true
                                sheetHeightOffset -= value.translation.height
                            }
                            .onEnded(onDragEnded)
                    )
                
                self.content
                
                Spacer()
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
            .background {
                RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
            }
            
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func handle() -> some View {
        Capsule()
            .foregroundColor(.gray.opacity(0.7))
            .frame(width: 100, height: 5)
    }
    
    func onDragEnded(_ value: DragGesture.Value) {
        defer { isSheetDragging = false }
        
        let velocity = CGSize(
            width:  value.predictedEndLocation.x - value.location.x,
            height: value.predictedEndLocation.y - value.location.y
        ).height
        
        let velocityThreshold: CGFloat = 100
        switch velocity {
        case _ where velocity > velocityThreshold:
            sheetPosition = sheetPosition.previous()
        case _ where velocity < -velocityThreshold:
            sheetPosition = sheetPosition.next()
        default:
            sheetPosition = .middle
        }
        
        sheetHeightOffset = sheetPosition.position + defaultOffset
        
        if case .dismiss = sheetPosition { onDismiss() }
    }
    
    enum SheetPosition: CaseIterable {
        case dismiss
        case middle
        case high
        
        var position: CGFloat {
            switch self {
            case .high:
                return 200
            case .middle:
                return 0
            case .dismiss:
                return 0
            }
        }
    }
}

extension CaseIterable where Self: Equatable, AllCases: BidirectionalCollection {
    func previous() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let previous = all.index(before: idx)
        
        if idx == all.startIndex {
            return self
        } else {
            return all[previous]
        }
    }

    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        
        if next == all.endIndex {
            return self
        } else {
            return all[next]
        }
    }
}


#Preview {
    ContentView()
}
