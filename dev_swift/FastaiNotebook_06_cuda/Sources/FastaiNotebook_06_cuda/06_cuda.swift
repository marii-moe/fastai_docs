/*
THIS FILE WAS AUTOGENERATED! DO NOT EDIT!
file to edit: 06_cuda.ipynb

*/
        
import Path
import TensorFlow
import Python

public struct CnnModel: Layer {
    public var reshapeToSquare: Reshape<Float>
    public var conv1: Conv2D<Float>
    public var conv2: Conv2D<Float>
    public var conv3: Conv2D<Float>
    public var conv4: Conv2D<Float>
    public var pool = AvgPool2D<Float>(poolSize: (2, 2), strides: (1, 1))
    public var flatten = Flatten<Float>()
    public var linear: Dense<Float>
    
    public init(sizeIn: Int, channelIn:Int, channelOut:Int, nFilters:[Int]) {
        reshapeToSquare = Reshape<Float>([-1, Int32(sizeIn), Int32(sizeIn), Int32(channelIn)])
        conv1 = Conv2D<Float>(
            filterShape: (5, 5, 1, nFilters[0]), 
            strides: (2, 2), 
            padding: .same, 
            activation: relu)
        conv2 = Conv2D<Float>(
            filterShape: (3, 3, nFilters[0], nFilters[1]),
            strides: (2, 2),
            padding: .same,
            activation: relu)
        conv3 = Conv2D<Float>(
            filterShape: (3, 3, nFilters[1], nFilters[2]),
            strides: (2, 2),
            padding: .same,
            activation: relu)
        conv4 = Conv2D<Float>(
            filterShape: (3, 3, nFilters[2], nFilters[3]),
            strides: (2, 2),
            padding: .same,
            activation: relu)
        linear = Dense<Float>(inputSize: nFilters[3], outputSize: channelOut)
    }
    
    @differentiable
    public func applied(to input: Tensor<Float>, in context: Context) -> Tensor<Float> {
        // There isn't a "sequenced" defined with enough layers.
        let intermediate =  input.sequenced(
            in: context,
            through: reshapeToSquare, conv1, conv2, conv3, conv4)
        return intermediate.sequenced(in: context, through: pool, flatten, linear)
    }
}
