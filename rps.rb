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
		move = Object.const_get(list_aux[ran]).new 
	end

	# muestra el nombre de la estrategia y su lista de 
	# movimientos posibles
	def to_s
		self.class.name.to_sym + " " + self.list.to_s
	end

	# vuelve la estrategia al estado inicial
	# no tiene accion para esta estrategia
	def reset
		self.gen = Random.new(SEED)
	end

end

class Biased < Strategy

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
		aux = aux.shuffle
		# se escoge el nuevo movimiento
		move = Object.const_get(aux[ran]).new
	end

	# muestra el nombre d ela estrategia y el hash con los
	# movimientos y sus probabilidades		
	def to_s
		self.class.name.to_sym + " " + self.hash.to_s 
	end

	# vuelve la estrategia a su estado inicial
	# no tiene accion en esta estrategia
	def reset
		self.gen = Random.new(SEED)
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
		return Object.const_get(mov.to_s).new
	end
	
	# muestra el nombre de la estrategia y su constructor
	def to_s
		self.class.name.to_sym  + " (" + self.constructor.to_s + ")" 
	end
	
	# vuelve la estrategia al estado inicial
	def reset
		self.other_moves = []
	end

end


class Smart < Strategy
	
	attr_accessor 	:rs, :ss, :ps
	attr_reader 	:gen	
	
	# cosntructor de la clase
	def initialize(r = 0, p = 0, s = 0)
		@rs		= r
		@ss 	= s
		@ps		= p
		@gen 	= Random.new(SEED)
	end
	

	def move_ranges ran
		 case
            when in_r(0, self.ps, ran)
                then move = :Scissors
            when in_r(self.ps, self.ps + self.rs, ran)
                then move = :Paper
            when in_r(self.ps + self.rs, self.ps + self.rs + self.ss, ran)
                then move = :Rock
        end 
		return move
	end

	# metodo auxiliar para la funcion next	
	def in_r(u,l,e)
		(u..l).member?(e)
	end

	def insert_move(m)
		aux = m.to_s
		case 
			when aux == "Rock"		then self.rs = self.rs + 1
			when aux == "Paper" 	then self.ps = self.ps + 1
			when aux == "Scissors"	then self.ss = self.ss + 1
		end
	end

	#devuelve el proximo movimiento
	def next(m)
		aux = self.rs + self.ss + self.ps
		if aux == 0
			ran = 0
		else 
			ran = self.gen.rand(aux)
		end
		insert_move(m)
		move = move_ranges(ran)
		return Object.const_get(move.to_s).new
	end

	# muestra el nombre de la estrategia y los contadores de las
	# jugadas del contrincante
	def to_s
		self.class.name.to_sym + " (Rocks: " + self.rs.to_s + " Papers: " + 
		self.ps.to_s + " Scissors: " + self.ss.to_s + ")" 
	end
	
	# vuelve el juego a su estado inicial
	# en este caso vuelve a cero los contadores de movimientos
	def reset
		self.rs 	= 0
		self.ps 	= 0
		self.ss 	= 0
		self.gen 	= Random.new(SEED)
	end

end

class Player

	attr_reader :name, :s
	attr_accessor :score, :move

	def initialize (name, s)
		@name	= name	# nombre del jugador
		@s		= s		# estrategia del jugador
		@score	= 0		# puntos del jugador
		@move	= self.first_move
	end
	
	def first_move
		self.s.next(self)
	end
end

#### clase juego
class Match

	attr_reader :hash, :p1, :p2
	attr_accessor :rp # partidas jugadas
	
	#verificar que sean solo dos elementos, verificar que 
	# values sean estategias
	def initialize hash
		hash.delete_if {|k,v| v.class.superclass!= Strategy}
		if hash.size != 2  
			raise "error, incorrect hash"
		else
			@hash = hash
			@p1 = Player.new(hash.keys[0], hash.values[0])
			@p2 = Player.new(hash.keys[1], hash.values[1])
			@rp	= 0
		end
	end
	
	# mejorar el puts
	# crear un hash de los resultado e imprimir ese hash
	def rounds(n)
		# se elije el primer movimiento del jugador 1
		m1 = self.p1.s.next(self)
		# se juega n veces
		n.times do
			#game
			m2 = self.p2.s.next(m1)
        # se comparan los resultados y se guarda en t
	        t = m1.score(m2)
        # se asignan los resultados
    	    self.p1.score = self.p1.score + t[0]
        	self.p2.score = self.p2.score + t[1]
        # se aumenta el numero de rondas jugadas
     		self.rp = self.rp + 1
        # se genera un nuevo movimiento del jugador 2
      		m1 = self.p1.s.next(m2)

		end
		# imprime el resultado en pantalla
		return "{ :" + self.p1.name.to_s + " => " + self.p1.score.to_s + ", :" +
			self.p2.name.to_s + " => " + self.p2.score.to_s + ", " +
			":Rounds => " + self.rp.to_s + " }"
	end
	
	def upto(n)
		# se elige el primer movimiento del jugador 1
		m1 = self.p1.s.next(self)
		# se juega hasta que algun jugador tenga n puntos
		while (self.p1.score < n && self.p2.score < n) do
			#game(m)
			m2 = self.p2.s.next(m1)
        # se comparan los resultados y se guarda en t
	        t = m1.score(m2)
        # se asignan los resultados
    	    self.p1.score = self.p1.score + t[0]
        	self.p2.score = self.p2.score + t[1]
        # se aumenta el numero de rondas jugadas
        	self.rp = self.rp + 1
        # se genera un nuevo movimiento del jugador 2
        	m1 = self.p1.s.next(m2)

		end
		return "{ :" + self.p1.name.to_s + " => " + self.p1.score.to_s + ", :" +
            self.p2.name.to_s + " => " + self.p2.score.to_s + ", " +
            ":Rounds => " + self.rp.to_s + " }"
		# hasta que el puntaje llegue a n
	end

	def reset
		self.p1.score = 0
		self.p2.score = 0
		self.rp = 0
	end
end




