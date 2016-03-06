# Universidad Simón Bolívar 
# CI3661 - Laboratorio de Lenguajes de Programación 
 
# Dayana Rodrigues 10-10615
# Roberto Romero   10-10642

class Movement
	def to_s
		self.class.name
	end		
end

class Rock < Movement
	def score m
		m.scoreRock(self)
	end
	def scoreRock m
		[0,0] # empate
	end
	def scorePaper m
		[1,0] # gana el invocante
	end
	def scoreScissors m
		[0,1] # gana rock
	end
end

class Paper < Movement
	def score m
		m.scorePaper(self)
	end
	def scoreRock m
		[0,1] # gana paper
	end
	def scorePaper m
		[0,0] # empate
	end
	def scoreScissors m
		[1,0] # gana el invocante
	end
end

class Scissors < Movement
	def score m
		m.scoreScissors(self)
	end
	def scoreRock m
		[1,0] # gana el invocante
	end
	def scorePaper m
		[0,1] # gana scissors
	end
	def scoreScissors m
		[0,0] # empate
	end
end

##### clase jugador
class Strategy
	SEED = 42
	def initialize
		# raise lanza el mensaje de error :D 
		raise 'Strategy is an abstract class'
	end
	# SERA QUE PONGO ERROR EN CADA METODO? 
end

class Uniform < Strategy

	# constructor de la clase
	def initialize list
	# si la lista está vacía muestra error
		if list.empty?
			raise 'Empty list'
		else	
			# uniq elimina los elementos repetidos
			# compact elimina los nil del array
           	@list = list.compact.uniq
		end
	end
	
	# para poder trabajar con la lista, MOSCA falta el atrr_algo
	def list
		@list
	end

	# devuelve el proximo movimiento
	def next(m)
		# gen es el generador de aleatoriedad
		gen 	= Random.new(SEED)
		# posicion del elemento a seleccionar
		index 	= gen.rand(self.list.size)
		# movimiento resultante
		move	= self.list[index]
		return move 
	end

	# muestra el nombre de la estragia y sus atributos
	def to_s
		self.class.name + " " + self.list.to_s
	end

	# vuelve la estrategia al estado inicial
	def reset
		# si vamos a seetear el estado inicial, aqui lo seteamos de nuevo
	end

end

class Biased < Strategy

	# constructor de la clase
	def initialize hash
		# si el has esta vacio
		if hash.empty?
			raise 'Empty hash'
		else
			# uniq puede recibir un bloque y así elimina claves repetidas
			@hash = hash.uniq { |x| x.key}
		end
	end

	# devuelve el proximo movimiento
	def next(m)
	end
	def to_s
	end
	def reset
	end
	# la clave son objetos de clase Movement, y los valores son 
    # enteros que representan las probabilidades de cada clave
end

class Mirror < Strategy

	# ATRR TAMBIEN
	# constructor de la clase
	def initialize (constructor, other_moves = [])
		@constructor = constructor
		# movimientos anteriores del contrincante
		@other_moves = other_moves		
	end

	# devuelve el proximo elemento
	def next(m)
		if other_moves.empty?
			mov = self.constructor
		else
			mov = other_moves.last
		end
		other_moves.insert(m)
		return mov
	end
	def to_s
	end
	def reset
	end
	#la primera jugada se setea al construirse, las demas son la
	# jugada anterior del contrincante
end


class Smart < Strategy
	def initialize x
		super x
	end
	def next(m)
	end
	def to_s
	end
	def reset
	end

        #analiza las frecuencias de las jugadas del oponente
        #debe recordad las jugadas aneriores y decidir segun:
                # P,R,S la cantidad de rock, paper, scissors
                # generar un numero al azar n entre 0 y P+R+S-1
                #sera scissors  si n e [0,p), paper si n e [p,p+r)
                # y rock si n e [p+r, p+r+s)
end


#### clase juego
class Match
	def initialize(args)	
	end
end

