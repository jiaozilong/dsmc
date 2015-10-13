module Types

  export Cell,
         Block,
         Point3D,
         Particle,
         Triangle


type Triangle
  id::Int64
  center::Array{Float64,1}
  nodes::Array{Float64,2}
  area::Float64
  surfaceNormal::Array{Float64,1}
end

type Particle
  x::Float64
  y::Float64
  z::Float64
  vx::Float64
  vy::Float64
  vz::Float64
  mass::Float64
  weight::Float64
end


type Cell
    origin::Vector{Float64}
    halfSize::Vector{Float64}
    nodes::Array{Float64,2}
    volume::Float64
    data::Vector{Float64}
    triangles::Vector{Triangle}
    hasTriangles::Bool
    particles::Vector{Particle}
end

type Block
    origin::Vector{Float64}
    halfSize::Vector{Float64}
    isLeaf::Int64
    children::Vector{Block}
    cells::Vector{Cell}
    nestingLevel::Int64
    nx::Int64
    ny::Int64
    nz::Int64
end

type Point3D
    x::Float64
    y::Float64
    z::Float64
end

end