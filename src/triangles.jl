function pick_point!(tri::Triangle, coords)
  A = B = C = 0.0
  r1 = rand()
  r2 = rand()
  sqrt_r1 = sqrt(r1)

  for i=1:3
    A = (1 - sqrt_r1) * tri.nodes[i,1]
    B = (sqrt_r1 * (1 - r2)) * tri.nodes[i,2]
    C = (sqrt_r1 * r2) * tri.nodes[i,3]
    coords[i] = A + B + C
  end
end

function tri2cell(tri, cell)
  if !in(tri, cell.triangles)
    push!(cell.triangles, tri)
  end
end

function isTriangleInCell(tri, cell)
  score = 0
  for i=1:3
    if cell.origin[i] - cell.halfSize[i] <= tri.center[i] <= cell.origin[i] + cell.halfSize[i]
      score += 1
    end
    if score == 3
      return true
    end
  end
  for k=1:3
    score = 0
    for i=1:3
      if cell.origin[i] - cell.halfSize[i] <= tri.nodes[i,k] <= cell.origin[i] + cell.halfSize[i]
        score += 1
      end
    end
    if score == 3
      return true
    end
  end
  return false
end

function assign_triangles!(oct, allTriangles, allCells)
  for cell in allCells
    for tri in allTriangles
      if isTriangleInCell(tri, cell)
        push!(cell.triangles, tri)
      end
    end
  end
end

function calculate_surface_normals(nodeCoords, triIndices, nTriangles)
  n_hat = zeros(Float64, 3, nTriangles)
  vi = zeros(Float64, 3)
  vj = zeros(Float64, 3)
  vk = zeros(Float64, 3)

  for ii=1:nTriangles
    i = triIndices[1, ii]
    j = triIndices[2, ii]
    k = triIndices[3, ii]

    vi = vec(nodeCoords[1:3, i])
    vj = vec(nodeCoords[1:3, j])
    vk = vec(nodeCoords[1:3, k])
    r = cross(vj-vi, vk-vi)
    r = r/norm(r)
    for kk = 1:3
      n_hat[kk, ii] = r[kk]
    end
  end

  return n_hat

end

function build_triangles(nodeCoords, triIndices, nTriangles)
  triangles = zeros(Float64, 3, 3, nTriangles)
  for i=1:nTriangles
    for j=1:3
      for k=1:3
        triangles[k,j,i] = nodeCoords[k,triIndices[j,i]]
      end
    end
  end
  return triangles
end

function calculate_tri_centers(triangles, nTriangles)
  triCenters = zeros(Float64, 3, nTriangles)
  for i=1:nTriangles
    for j=1:3
      triCenters[j,i] = sum(triangles[j,1:3,i])/3.0
    end
  end
  return triCenters
end


function calculate_tri_areas(triangles, nTriangles)
  triAreas = zeros(Float64, nTriangles)
  for i=1:nTriangles
    P = vec(triangles[1:3,2,i] - triangles[1:3,1,i])
    Q = vec(triangles[1:3,3,i] - triangles[1:3,1,i])
    S = sqrt(sum(cross(P,Q).^2))
    triAreas[i] = 0.5 * S
  end
  return triAreas
end

function compute_sza(oct, r_hat)
  for cell in oct.cells
    for tri in cell.triangles
      tri.cos_sza = cos(angle_between(r_hat, tri.surfaceNormal))
    end
  end
end

function compute_rza(oct, r_hat)
  for cell in oct.cells
    for tri in cell.triangles
      tri.cos_rza = cos(angle_between(r_hat, tri.surfaceNormal))
    end
  end
end
