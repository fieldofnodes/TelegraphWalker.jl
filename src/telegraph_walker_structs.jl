# Define type
abstract type MeanSquaredDisplacement end


# Define structs
struct DisplacementPositions <: MeanSquaredDisplacement
     p::RandomWalker.Walker2D
     q::RandomWalker.Walker2D
end

struct TaxiCabDistance{T} <: MeanSquaredDisplacement
     d::T
end

struct TaxiCabDistanceXY{T} <: MeanSquaredDisplacement
    dₓ::T
    dy::T
end



