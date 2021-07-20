
function taxicabdistanceXY(d::DisplacementPositions)
    return TaxiCabDistanceXY(
        abs(d.p.x - d.q.x),
        abs(d.p.y - d.q.y))
end

function taxicabdistance(d::DisplacementPositions)
    TaxiCabDistance(abs(d.p.x - d.q.x) + abs(d.p.y - d.q.y))
end


function periodicdomainshift(distance,domain)
     return (distance > domain/2 ? domain - distance : distance)
end

function taxicabdistance(d::DisplacementPositions,domain)
     TaxiCabDistance(
          periodicdomainshift(abs(d.p.x - d.q.x),domain) + 
               periodicdomainshift(abs(d.p.y - d.q.y),domain)
     )
end



function taxicabdistanceXY(d::TaxiCabDistanceXY,domain)
   dx = abs(periodicdomainshift(d.dₓ,domain))
   dy = abs(periodicdomainshift(d.dy,domain))
   return dx + dy
end


walker_distance(w) = taxicabdistance(DisplacementPositions(w[1],w[end]),domain)



function dₜ(w,domain)
     d = DisplacementPositions(
          Walker2D(w[1][1],w[1][2]), 
          Walker2D(w[end][1],w[end][2])
     )
     D = taxicabdistanceXY(
          taxicabdistanceXY(d),domain
          )
     return D
end

