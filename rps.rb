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
	def initialize x
                @x = x
        end
        def to_s
                self.class.name
        end	
end

class Rock < Movement
	def initialize x
                super x
        end
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
	def initialize x
                super x
        end
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
	def initialize x
                super x
        end
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
	def initialize x
                @x = x
        end
        def next(m)
                # genera el proxio elemeno
        end
        def to_s
                self.class.name
                # debe estar especializada para mostar los 
                # parametros de configuracios de cada estrategia
        end
        def reset
                # lleva la estrategia al estado inicial
        end
end

class Uniform < Strategy
        def initialize x
                super x
                # debe eliminar duplicados y la lista no debe estar
                # vacia
        end
        # debe seleccionar elemento usando una distribucion uniforme
        # preguntar que coño significa eso
end

class Biased < Strategy
        def initialize x
                super x
                #eliminar duplicados y verificar que el hash no este vacio
        end
        # la clave son objetos de clase Movement, y los valores son 
        # enteros que representan las probabilidades de cada clave
end

class Mirror < Strategy
        def initialize x
                super x
        end
        #la primera jugada se setea al construirse, las demas son la
        # jugada anterior del contrincante
end

class Smart < Strategy
        def initialize x
                super x
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

