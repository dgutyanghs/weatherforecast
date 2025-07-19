import SwiftUI

struct MountainView: View {
    var body: some View {
        ZStack {
            // Mountain landscape
            VStack(spacing: 0) {
                // Sky area
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white,
                                Color.mint.opacity(0.3)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 200)
                
                // Mountain silhouettes
                ZStack {
                    // Back mountains
                    MountainShape(peaks: [0.3, 0.7, 0.4, 0.8, 0.5])
                        .fill(Color.mint.opacity(0.6))
                        .frame(height: 120)
                    
                    // Middle mountains
                    MountainShape(peaks: [0.5, 0.9, 0.3, 0.6, 0.8])
                        .fill(Color.mint.opacity(0.8))
                        .frame(height: 100)
                        .offset(y: 20)
                    
                    // Front mountains
                    MountainShape(peaks: [0.2, 0.6, 0.9, 0.4, 0.7])
                        .fill(Color.mint)
                        .frame(height: 80)
                        .offset(y: 40)
                    
                    // River/valley
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 60))
                        path.addQuadCurve(
                            to: CGPoint(x: 400, y: 60),
                            control: CGPoint(x: 200, y: 80)
                        )
                        path.addLine(to: CGPoint(x: 400, y: 120))
                        path.addLine(to: CGPoint(x: 0, y: 120))
                        path.closeSubpath()
                    }
                    .fill(Color.mint.opacity(0.3))
                }
            }
            .frame(height: 280)
            .clipped()
        }
    }
}

struct MountainShape: Shape {
    let peaks: [Double]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let stepWidth = width / Double(peaks.count - 1)
        
        path.move(to: CGPoint(x: 0, y: height))
        
        for (index, peak) in peaks.enumerated() {
            let x = Double(index) * stepWidth
            let y = height * (1 - peak)
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    MountainView()
}