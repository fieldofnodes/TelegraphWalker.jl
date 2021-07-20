
function random_walk_telegraph(data,T,Δt,domain,λ₁,λ₂,rate,state)
	states = []
	push!(states,state)

	Data = []
	push!(Data,T,Δt,rate,λ₁,λ₂)

	λ₁Δt = λ₁*Δt
	λ₂Δt = λ₂*Δt
	time = range(Δt,T,step=Δt)

	rΔt = Δt*rate
	s() = stepping(rΔt)


	p₀() = rand(1:domain)

	Walk = []
	w = Walker2D(p₀(),p₀())
	push!(Walk,w)



	#d(w) = taxicabdistance(DisplacementPositions(w[1],w[end]),domain)





	for i in 2:size(time,1)
		 
		 # Create states
		 state = update(state,λ₁Δt,λ₂Δt)
		 push!(states,state)
		 
		 

		 if states[i-1] == 1 && states[i] == 1
			  continue
		 elseif states[i-1] == 1 && states[i] == 0
			  # first step
			  w = updateperiod(w, s(),domain,domain)
			  push!(Walk,w)
			  i₁ = i
			  t₁ = time[i]
			  push!(Data,i₁,t₁)
		 elseif states[i-1] == 0 && states[i] == 1
			  # last step
			  iₙ = i-1
			  tₙ = time[i-1]
			  W = Walk
			  w_tup = [(i.x,i.y) for i in W]
			  Walk = []
			  #dist = d(W).d
			  push!(Data,iₙ,tₙ,w_tup)
			  if size(Data,1) != 10
				   error("Length to push to dataframe is $(size(Data,1)) not 11")
			  end
			  push!(data,Data)
			  Data = []
			  push!(Data,T,Δt,rate,λ₁,λ₂)
		 elseif states[i-1] == 0 && states[i] == 0
			  if size(states,1) == 2
				   # keep walking
				   i₁ = i-1
				   t₁ = time[i-1]
				   push!(Data,i₁,t₁)
				   w = updateperiod(w, s(),domain,domain)
				   push!(Walk,w)  
			  elseif size(states,1) > 2
				   w = updateperiod(w, s(),domain,domain)
				   push!(Walk,w)
			  else
				   error("States is either size 0 or size negative")
			  end
		 else
			  error("What state are you meant to be in?")       
		 end
	end
	return data
end


function random_walk_telegraph_no_df(T,Δt,domain,λ₁,λ₂,rate,state)
	states = []
	push!(states,state)

	

	λ₁Δt = λ₁*Δt
	λ₂Δt = λ₂*Δt
	time = range(Δt,T,step=Δt)

	rΔt = Δt*rate
	s() = stepping(rΔt)


	p₀() = rand(1:domain)

	Walk = []
	W_tup = []
	w = Walker2D(p₀(),p₀())
	push!(Walk,w)



	#d(w) = taxicabdistance(DisplacementPositions(w[1],w[end]),domain)





	for i in 2:size(time,1)
		 
		 # Create states
		 state = update(state,λ₁Δt,λ₂Δt)
		 push!(states,state)
		 
		 
		 
		 if states[i-1] == 1 && states[i] == 1
			  continue
		 elseif states[i-1] == 1 && states[i] == 0
			  # first step
			  w = updateperiod(w, s(),domain,domain)
			  push!(Walk,w)
			
		 elseif states[i-1] == 0 && states[i] == 1
		 	
			  W = Walk
			  w_tup = [(i.x,i.y) for i in W]
			  push!(W_tup,w_tup)
			  #dist = d(W).d
			 
		 elseif states[i-1] == 0 && states[i] == 0
			  if size(states,1) == 2
			
				   w = updateperiod(w, s(),domain,domain)
				   push!(Walk,w)  
			  elseif size(states,1) > 2
				   w = updateperiod(w, s(),domain,domain)
				   push!(Walk,w)
			  else
				   error("States is either size 0 or size negative")
			  end
		 else
			  error("What state are you meant to be in?")       
		 end
	end
	distance = [dₜ(w,domain) for w in W_tup]
    d̂ = mean(distance[2:end])
            
	return d̂
end

function tele_rw_inf_domain(
	λ₁::Float64,
	λ₂::Float64,
	r::Float64,
	Δt::Float64,
	T::Int,
	s::Int
	)

	# Set up λ
	λ₁Δt = λ₁*Δt
	λ₂Δt = λ₂*Δt

	# Set up r
	rΔt = r*Δt

	# Set up time 
	time = range(Δt,T,step=Δt)

	# Push s to state
	state = []
	push!(state,s)

	## Set up Random walk
	st() = stepping(rΔt)
	p₀() = 0 #rand(1:domain)
	Walk = []
	w = Walker2D(p₀(),p₀())
	push!(Walk,w)


	# Time evolution
	for i in 2:size(time,1)
	    s = update(s,λ₁Δt,λ₂Δt)
	    push!(state,s)

	    if s == 0
	    	w = RandomWalker.update(w,st())
	    	push!(Walk,w)
	    elseif s == 1
	    	continue
	    else
	    	error("What state are you in? You are in state $(s)")
	    end
	end

	[[state] [Walk]]
end


