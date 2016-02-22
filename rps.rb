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

Usted debe implantar al menos las siguientes especializaciones de Strategy:
1Uniform, construida recibiendo una lista de movimientos posibles y seleccionando cada
movimiento usando una distribuci ́on uniforme sobre los movimientos posibles, i.e.
r = Uniform.new( [ :Rock, :Scissors, :Paper ] )
Al construir una instancia de esta estrategia, es necesario eliminar duplicados y verifi-
car que haya al menos una estrategia en la lista, en caso contrario emitir una excepci ́on
describiendo el error.
Biased, construida recibiendo un mapa de movimientos posibles y sus probabilidades
asociadas, de modo que cada movimiento use una distribuci ́on sesgada de esa forma. Al
construir una instancia de esta estrategia, es necesario eliminar duplicados y verificar
que haya al menos una estrategia en el mapa, en caso contrario emitir una excepci ́on
describiendo el error. Las probabilidades asociadas a cada tipo de movimiento ser ́an
n ́
umeros enteros, i.e.
b = Biased.new( { :Rock => 1, :Scissors => 3, :Paper => 2 } )
Resultando en probabilidades 1/6, 1/2 y 1/3 respectivamente.
Mirror, cuya primera jugada es definida al construirse, pero a partir de la segunda
ronda siempre jugar ́
a lo mismo que jug ́o el contrincante en la ronda anterior.
Smart, cuya jugada depende de analizar las frecuencias de las jugadas hechas por el
oponente hasta ahora. La estrategia debe recordar las jugadas previas del oponente, y
luego decidir de la siguiente forma:
• Sean p, r y s la cantidad de veces que el oponente ha jugado Paper, Rock o
Scissors, respectivamente.
• Se genera un n ́
umero entero al azar n entre 0 y p + r + s − 1.
• Se jugar ́
a Scissors si n ∈ [0, p), Paper si n ∈ [p, p+r) o Rock si n ∈ [p+r, p+r+s)
Notar ́
a que varias de las estrategias requieren el uso de n ́
umeros al azar. La librer ́ıa Random
provista por Ruby tiene toda la infraestructura necesaria. Con el prop ́osito de poder evaluar
de manera semiautom ́
atica sus soluciones, es necesario que todos los generadores de n ́
umeros
al azar tengan exactamente la misma semilla, para ello declare una constante de clase en
Strategy con el valor 42, a ser utilizada cada vez que necesite una semilla.