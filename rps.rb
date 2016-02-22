# Universidad Simón Bolívar 
# CI3661 - Laboratorio de Lenguajes de Programación 
 
# Dayana Rodrigues 10-10615
# Roberto Romero   10-10642


# to_s muestra el invocante como un String.
# score(m) determina el resultado de la jugada entre el invocante y el movimiento
#m, correspondiente al contrincante, que es recibido como argumento. 
#El resultado de score debe ser una tupla que representa la ganancia en puntos resultado de la jugada:
#el primer elemento de la tupla representa la ganancia del invocante, mientras que el
#segundo elemento representa la ganancia del contrincante. As ́ı, la tupla resultante debe
#ser [1,0], [0,1] o [0,0] dependiendo de los movimientos involucrados.

class Movement
	def initialize(args)
		
	end	
end

class Rock < Movement
	def initialize(args)
		
	end
end

class Paper < Movement
	def initialize(args)
		
	end
end

class Scissors < Movement
	def initialize(args)
		
	end
end

##### clase jugador
class Strategy 

	def initialize(args)
		
	end

	def next (m)
		#retorna un movement
	end	

	def reset
		#lleva la estrategia a su estado inicial
		#cuando esto tenga sentido ????
	end
	
end

#### clase juego
class Match
	def initialize(args)
		
	end
	
	
end

