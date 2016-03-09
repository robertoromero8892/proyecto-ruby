# Universidad Simón Bolívar 
# CI3661 - Laboratorio de Lenguajes de Programación 
# 
# El programa simula el juego "Piedra, Papel o Tijeras"
# entre dos jugadores virtuales, cada uno aplicando una
# estrategia de juego específica y jugado por rondas o
# hasta que alguno de los jugadores alcance una
# puntuación específica 
#
# Autores: 	Dayana Rodrigues 10-10615
# 			Roberto Romero   10-10642
#

# Esta clase representa la noción de movimiento
# para el juego los movimientos son piedra,
# papel o tijeras

class Movement

	# Muestra en pantalla el nombre de la clase
	# del movimiento como un string
	
	def to_s
		self.class.name
	end
	
	# Devuelve una excepción

	def score m
		raise "Error: Movement has no method score()"
	end

end

# Esta clase representa el movimiento piedra

class Rock < Movement
	
	# Determina el resultado de enfrentar dos movimientos
	# 
	# * se pasa el control a la función que determina el
	# * resultado de enfrentar el movimiento m con un
	# * movimiento piedra

	def score m
		m.scoreRock(self)
	end

	# Devuelve el resultado de enfrentar una movimiento
	# piedra con otro movimientro piedra
	#
	# * resulta en un empate

	def scoreRock m
		[0,0]
	end
	
	# Devuelve el resultado de enfrentar una movimiento
	# piedra con un movimiento papel
	#
	# * resulta el movimiento papel (invocante) como ganador

	def scorePaper m
		[1,0] 
	end

	# Devuelve el resultado de enfrentar una movimiento
	# piedra con un movimiento tijeras
	#
	# * resulta el movimiento piedra como ganador

	def scoreScissors m
		[0,1] 
	end

end

# Esta clase representa el movimiento papel

class Paper < Movement
	
	# Determina el resultado de enfrentar dos movimientos
	# 
	# * se pasa el control a la función que determina el
	# * resultado de enfrentar el movimiento m con un
	# * movimiento papel

	def score m
		m.scorePaper(self)
	end

	# Devuelve el resultado de enfrentar una movimiento
	# papel con un movimientro piedra
	#
	# * resulta el movimiento papel como ganador

	def scoreRock m
		[0,1] 
	end

	# Devuelve el resultado de enfrentar una movimiento
	# papel con otro movimientro papel
	#
	# * resulta en un empate

	def scorePaper m
		[0,0]
	end

	# Devuelve el resultado de enfrentar una movimiento
	# papel con un movimientro tijeras
	#
	# * resulta ganador el movimiento tijeras (invocante)

	def scoreScissors m
		[1,0]
	end

end

# Esta clase representa el movimiento tijeras

class Scissors < Movement

	# Determina el resultado de enfrentar dos movimientos
	# 
	# * se pasa el control a la función que determina el
	# * resultado de enfrentar el movimiento m con un
	# * movimiento tijeras

	def score m
		m.scoreScissors(self)
	end

	# Devuelve el resultado de enfrentar una movimiento
	# tijeras con un movimientro piedra
	#
	# * resulta ganador el movimiento piedra (invocante)

	def scoreRock m
		[1,0]
	end

	# Devuelve el resultado de enfrentar una movimiento
	# tijeras con un movimientro papel
	#
	# * resulta ganador el movimiento tijeras

	def scorePaper m
		[0,1]
	end

	# Devuelve el resultado de enfrentar una movimiento
	# tijeras con otro movimientro tijeras
	#
	# * resulta en un empate

	def scoreScissors m
		[0,0]
	end

end

# Esta clase representa a cada jugador, que
# son modelados como una estategia de juego
# que determina sus movimientos

class Strategy

	# Semilla para el generador de aleatoriedad 
	SEED = 42

	# Genera una excepción
	#
	# * Strategy es una clase abstarcta por lo 
	# * no puede ser inicializada

	def initialize
		raise 'Error: Strategy is an abstract class'
	end
	
	# Genera una excepción
	#
	# * los movimientos siguientes son generados 
	# * segun la estrategia,la clase abstracta no
	# * puede generarlos

	def next(m)
		raise 'Error: The class Strategy have no method "next"'
	end 

	# Muestra en pantalla el nombre del invocante
	
	def to_s
		self.class.name
	end

end

# Esta clase representa la estrategia uniform
# que selecciona el proximo movimiento siguiendo
# una distribución uniforme de la lista de los
# movimientos posibles

class Uniform < Strategy

	# lista de movimientos posibles
	attr_accessor 	:list
	
	# generador de aleatoriedad de la estrategia
	attr_reader 	:gen

	# Inicializa el generador de aleatoriedad y
	# la lista de movimientos posibles
	#
	# * si la lista está vacía se genera una excepción
	# * si no, se eliminan los elementos duplicados

	def initialize list
		@gen = Random.new(SEED)
		if list.empty?
			raise 'Error: Empty list'
		else	
           	@list = list.uniq
		end
	end

	# Determina el próximo movimiento del jugador
	# 
	# * se genera un numero aleatorio entre 0 y la
	# * cantidad de elementos en la lista de movimientos
	# * posibles, y se devuelve el movimiento asociado
	# * a la posicion dada por el numero aleatorio 

	def next(m)
		ran 	= self.gen.rand(self.list.size)
		move 	= Object.const_get(self.list[ran]).new 
	end

	# Muestra en pantalla el nombre simbólico de la 
	# estrategia y sus parámetros de configuración

	def to_s
		super + "    " + "Movimientos posibles: " +  self.list.to_s
	end

	# Devuelve la estategia a su estado inicial
	#
	# * se inicializa el generador de aleatoriedad con
	# * la semilla incial
	
	def reset
		self.gen = Random.new(SEED)
	end

end

# Esta clase representa la estartegia biased
# que determina el próximo movimiento según
# las probabilidades asociadas a cada uno de
# los movimientos posibles

class Biased < Strategy

	# hash : Diccionario de los movimientos con su
	# probabilidad asociada
	# gen : Generador de aleatoriedad
	attr_reader :hash, :gen

	# Inicializa el generador de aleatoriedad
	# y el diccionario de movimientos con sus
	# probabilidades
	#
	# * si el diccionario está vacío, devuelve una
	# * excepción, de lo contrario elimina los
	# * elementos duplicados

	def initialize hash
		@gen = Random.new(SEED)
		if hash.empty?
			raise 'Error: Empty hash'
		else
			@hash = hash.to_h
		end
	end

	# Devuelve el próximo movimiento del jugador
	#
	# * se calcula la suma de las probabilidades de
	# * los movimientos y se genera un numero 
	# * aleatorio entre cero y esta suma, luego se
	# * genera un arreglo con los movimientos posibles
	# * donde cada uno aparece tantas veces como su 
	# * probabilidad, se barajea este arreglo y se
	# * selecciona el elemento asociado a la posición
	# * del número aleatorio

	def next(m)
		sum = 0
		self.hash.values.each {|v| sum = sum +v}
		ran = self.gen.rand(sum)
		aux = []
		self.hash.each {|k,v| aux = (aux << k)*v}
		aux = aux.shuffle
		move = Object.const_get(aux[ran]).new
	end

	# Muestra en pantalla el nombre simbólico de la 
	# estrategia y sus parámetros de configuración
	
	def to_s
		super + "    Movimientos y probabilidades asociadas: " 
		+ self.hash.to_s 
	end

	# Devuelve la estrategia a su estado inicial
	#
	# * Inicializa de nuevo el generador de aleatoriedad
	# * con la semila inicial

	def reset
		self.gen = Random.new(SEED)
	end

end

# Esta clase representa la estategia mirror
# que determina el próximo movimiento del jugador
# devolviendo el movimiento anterior del jugador
# contrincante

class Mirror < Strategy
	
	# lista de moviemientos del jugador contrincante
	attr_accessor 	:other_moves

	# primer movimiento de la estrategia
	attr_reader 	:constructor
	
	# Inicializa la lista de movimientos del
	# contrincante y la jugada inicial
	#
	# * al inicializar, la lista de movimientos
	# * del contrincante es una lista vacía

	def initialize (constructor)
		@constructor = constructor
		@other_moves = []		
	end

	# Devuelve el próximo movimiento del jugador
	#
	# * selecciona el último elemento de la lista de
	# * movimientos del contrincante, agragando el nuevo
	# * movimiento a la lista, si al lista está vacía, 
	# * devuelve el movimiento inicial

	def next(m)
		if self.other_moves.empty?
			mov = self.constructor
		else
			mov = self.other_moves.last
		end
		puts m
		self.other_moves << m
		return Object.const_get(mov.to_s.to_sym).new
	end
	
	# Muestra en pantalla el nombre simbólico de la estrategia
	# y sus parámetros de configuración

	def to_s
		super + "    Movimiento inicial: " + self.constructor.to_s 
	end
	
	# Devuelve la estrategia a su estado inicial
	#
	# * asigna a la lista de jugadas del contrincante una lista
	# * vacía

	def reset
		self.other_moves = []
	end

end

# Esta clase representa la estrategia smart
# que determina el próximo movimiento del jugador
# según la frecuencia de movimientos jugados por
# el contrincante

class Smart < Strategy

	# rs: cantidad de movimientos piedra jugados
	# por el contrincante
	# ss: cantidad de movimientos tijeras jugados
	# por el contrincante
	# ps: cantidad de movimientos papel jugados 
	# por el contrincante	
	attr_accessor 	:rs, :ss, :ps

	# generadod de aleatoriedad
	attr_reader 	:gen	
	
	# Inicializa el generador de aleatoridad y
	# los acumuladores de movimientos del jugador
	# contrincante

	def initialize(r = 0, p = 0, s = 0)
		@rs	= r
		@ss 	= s
		@ps	= p
		@gen 	= Random.new(SEED)
	end
	
	# Determina el próximo movimiento del jugador
	#
	# * suma todos los acumuladores de movimientos del
	# * contrincante y si es distinto de cero se genera
	# * un número aleatorio entre cero y la suma,
	# * se aumenta el acumulador correspondiente al movimiento
	# * del contrincante, se determina el rango al que pertenece 
	# * el número, y se selecciona el movimiento según
	# * el rango asociado

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

	# Determina el movimiento según el rango que corresponda
	
	def move_ranges ran
         case
            when (0..self.ps).member?(ran)
                then move = :Scissors
            when (self.ps..(self.ps + self.rs)).member?(ran)
                then move = :Paper
            when ((self.ps + self.rs)..(self.ps + self.rs + self.ss)).member?(ran)
                then move = :Rock
        end
        return move
    end

    # Aumenta el contador de movimientos del contrincante

    def insert_move(m)
        aux = m.to_s
        case
            when aux == "Rock"      then self.rs = self.rs + 1
            when aux == "Paper"     then self.ps = self.ps + 1
            when aux == "Scissors"  then self.ss = self.ss + 1
        end
    end

	# Muestra en pantalla el nombre de la estrategia y sus
	# parámetros de configuración

	def to_s
		super + "    Frecuencia de movimientos del contrincante: "
		+ " Rocks = " + self.rs + " Papers = " + self.ps +
		" Scissors = " + self.ss
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

# Esta clase representa el juego en sí
# determinando el flujo de las partidas
# bien sea por rondas o hasta un puntaje

class Match

	# :hash : diccionario con los nombres de los
	# dos jugadores y sus estrategias
	# :p1 : jugador 1
	# :p2 : jugador 2
	attr_reader :hash, :s1, :s2
	
	# cantidad de partidas jugadas
	attr_accessor :rp, :scores
	
	# Verifica que los valores del diccionario sean estategias
	# y que la cantidad de jugadores sea exactamente dos e
	# inicializa los jugadores con sus atributos correspondientes,
	# de lo contrario emite una excepción
	
	def initialize hash
		hash.delete_if {|k,v| v.class.superclass!= Strategy}
		if hash.size != 2  
			raise "Error: Need just two players and strategies"
		else
			@hash 	= hash
			@s1	= hash.values[0]
			@s2 	= hash.values[1]
			@rp	= 0
			@scores = [0,0]
		end
	end
	

	# Realiza el ciclo de juego hasta completar las n
	# rondas y devuelve el resultado final
	#
	# * se determina el primer movimiento del jugador 1,
	# * con este movimiento se genera el del jugador 2,
	# * se determina el resultado de enfrentar los 
	# * movimientos, se suman los puntos obtenidos a cada
	# * jugador, se aumenta el contador de rondas y se elige 
	# el proximo movimiento del jugador 1.

	def rounds(n)
		m1 = self.s1.next(self)
		n.times do
			m2 = self.s2.next(m1)
			self.scores = sum_array(self.scores, m1.score(m2))
			self.rp = self.rp + 1
			m1 = self.s1.next(m2)
		end
		# imprime el resultado en pantalla
		numbers = self.scores << self.rp
		names = self.hash.keys << :Rounds
		return Hash[names.zip(numbers)] 
	end

    # Realiza el ciclo de juego hasta que algún jugador
    # alcance los n puntos y devuelve el resultado final
    #
    # * se determina el primer movimiento del jugador 1,
    # * con este movimiento se genera el del jugador 2,
    # * se determina el resultado de enfrentar los 
    # * movimientos, se suman los puntos obtenidos a cada
    # * jugador, se aumenta el contador de rondas y se elige 
    # el proximo movimiento del jugador 1.
	
	def upto(n)
		m1 = self.s1.next(self)
		while (self.scores[0] < n && self.scores[1] < n) do
			m2 = self.s2.next(m1)
			self.scores = sum_array(self.scores, m1.score(m2))
			self.rp = self.rp + 1
			m1 = self.s1.next(m2)
		end
		numbers = self.scores << self.rp
		names = self.hash.keys << :Rounds
		return Hash[names.zip(numbers)]
	end
	
	# Devuelve la suma de dos arreglos de dos elementos

	def sum_array(a1,a2)
		a3_0 = a1[0] + a2[0]
		a3_1 = a1[1] + a2[1]
		return [a3_0, a3_1]
    end

	# Devuelve el juego al estado inicial
	#
	# * los puntajes de los jugadores se inician a cero
	# * así como las partidas jugadas

	def reset
		self.scores 	= [0,0]
		self.rp 	= 0
	end

end
