# dążenie do nieskończoności sprawdzamy ustawiająć maksymalną liczbę iteracji i sprawdzając
# czy kolejne wyrazy ciągu nie przekroczą zadanego progu (tutaj 2) w tej (bądź mniejszej)
# liczbie iteracji

using Distributed
using SharedArrays

# funkcja sprawdzająca, czy punkt z należy do zbioru Julii o parametrze c
@everywhere function generate_julia(z; c=2, maxiter=200)
    for i=1:maxiter
        if abs(z) > 2
            return i-1
        end
        z = z^2 + c
    end
    maxiter
end

# obliczamy zbiór Julii na płaszczyźnie punktów od-do.

@everywhere function calc_julia_parallel!(julia_set, xrange, yrange; maxiter=2000, height=400, width_start=1, width_end=400)
  
  for x=width_start:width_end
        @sync @distributed for y=1:height
            z = xrange[x] + 1im*yrange[y]
            julia_set[x, y] = generate_julia(z, c=-0.70176-0.3842im, maxiter=maxiter)
        end
  end

 end

# główna funkcja 

 function calc_julia_parallel(h,w)
  # ustawiamy płaszczyznę
   xmin, xmax = -0.5,0.5
   ymin, ymax = -0.5,0.5
   xrange = xmin:(xmax-xmin)/(w-1):xmax  
   yrange = ymin:(ymax-ymin)/(h-1):ymax
    
   julia_set = SharedArray{Int64,2}(w, h)
   # wywołujemy w celu kompilacji na jednym wierszu:
    calc_julia_parallel!(julia_set, xrange, yrange, height=h,width_start=1, width_end=1)
  
   # obliczamy
   @time calc_julia_parallel!(julia_set, xrange, yrange, height=h,width_start=1, width_end=w)
    
end


calc_julia_parallel(2000,2000)
