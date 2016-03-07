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

	attr_accessor 	:list
	attr_reader 	:gen
	# constructor de la clase
	def initialize list
		@gen = Random.new(SEED)
	# si la lista está vacía muestra error
		if list.empty?
			raise 'Empty list'
		else	
			# uniq elimina los elementos repetidos
			# compact elimina los nil del array
           	@list = list.compact.uniq
		end
	end

	# devuelve el proximo movimiento
	def next(m)
		# posicion del elemento a seleccionar
		ran 	= self.gen.rand(self.list.size)
		# si la lista debe mantenerse igual
		list_aux = self.list.shuffle
		# nuevo movimiento
		move = list_aux[ran] 
	end

	# muestra el nombre de la estrategia y su lista de 
	# movimientos posibles
	def to_s
		aux = ""
		self.list.each {|e| aux = aux + e.to_s + " "}
		self.class.name + " [ " + aux + "] "
	end

	# vuelve la estrategia al estado inicial
	# no tiene accion para esta estrategia
	def reset
	end

end

class Biased < Strategy
	# le pongo el generador como atributo???
	attr_reader :hash, :gen
	# constructor de la clase
	def initialize hash
		@gen = Random.new(SEED)
		# si el has esta vacio
		if hash.empty?
			raise 'Empty hash'
		else
			# to_h vuelve el constructor un hash y elimina
			# duplicados
			@hash = hash.to_h
		end
	end

	# devuelve el proximo movimiento
	# como usar range aqui?
	def next(m)
		sum = 0
		# calcula la suma de las probabilidades
		self.hash.values.each {|v| sum = sum +v}
		# genera un numero aleatorio entre 0 y sum
		ran = self.gen.rand(sum)
		aux = []
		# genera un arreglo con los movimientos posibles
		# repetidos segun su probabilidad asociada
		self.hash.each {|k,v| aux = (aux << k)*v}
		# se barajea el arreglo
		aux = aux.shuflle
		# se escoge el nuevo movimiento
		move = aux[ran]
	end
	
	# funcion auxiliar para to_s
	private
	def make_string(k,v)
		k.to_s + " => " + v.to_s
	end

	# muestra el nombre d ela estrategia y el hash con los
	# movimientos y sus probabilidades		
	def to_s
		aux = ""
		self.hash.each {|k,v| aux = aux + make_string(k,v) + " "}
		self.class.name + " { " + aux + "}" 
	end

	# vuelve la estrategia a su estado inicial
	# no tiene accion en esta estrategia
	def reset
	end

end

class Mirror < Strategy
	
	attr_accessor 	:other_moves
	attr_reader 	:constructor
	
	# constructor de la clase
	def initialize (constructor, other_moves = [])
		@constructor = constructor
		# movimientos anteriores del contrincante
		@other_moves = other_moves		
	end

	# devuelve el proximo elemento
	def next(m)
		if self.other_moves.empty?
			mov = self.constructor
		else
			mov = self.other_moves.last
		end
		# agrega el movimiento del contrincante a la lista de
		# movimientos anteriores
		self.other_moves << m
		return mov
	end
	
	# muestra el nombre de la estrategia y su constructor
	def to_s
		self.class.name + " (" + self.constructor.class.name + ")" 
	end
	
	# vuelve la estrategia al estado inicial
	def reset
		self.other_moves = []
	end

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

