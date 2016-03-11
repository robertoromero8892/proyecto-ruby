# Universidad Simón Bolívar 
# CI3661 - Laboratorio de Lenguajes de Programación 
 
# Dayana Rodrigues 10-10615
# Roberto Romero   10-10642

#Modulo BFS
#utilizado para hacer mixin
module BFS

	#funcion que mediante recursion encuentra un elemento en una estructura
	def find(start,predicate)
		procfind = lambda do
			        |x| 
			        if (predicate.call x) 
			        	return x.value
					else
						find(x,predicate)
					end	

		end	       
		start.each(procfind)

	end

	#funcion que mediante recursion encuentra un elemento en una estructura
	#y devuelve el camino tomado
	def path(start,predicate)
		start.recursorPath([],start,predicate)
	end	

	#funcion que recursivamente recorre todos los hijos de una estructura 
	#y retorna la estructura modificada y un arreglo con los nodos visitados
	def walk(start,action)
		start.recursorWalk([],start,action)
	end

end	

#clase arbol binario
class BinTree 

	#atributos del arbol binario
	attr_accessor   :value, # Valor almacenado en el nodo 
					:left,  # Hijo (BinTree) izquierdo
					:right  # Hijo (BinTree) derecho

	include BFS				

	#constructor del arbol binario
	def initialize(v,l,r)
		self.value = v
		self.left = l
		self.right = r
	end

	#metodo para recorrer los hijos del arbol binario
	#mediate iteracion
	def each(b)
		if not self.left == nil
			return b.call self.left
		end	
		if not self.right == nil
			return b.call self.right	
		end	

	end

	#metodo auxiliar recursivo de la funcion path
	#verifica si secumple la condicion
	#de ser asi retorna
	#de caso recorre los hijos del nodo
	def recursorPath(pila,nodo,predicate)
		if nodo == nil
			nil
		else	
			if (predicate.call nodo)
				pila << nodo.value
				return pila
			else
				pila << nodo.value
				if not nodo.left == nil
					return nodo.recursorPath(pila,nodo.left,predicate)
				end	
				if not nodo.right == nil
					return nodo.recursorPath(pila,nodo.right,predicate)
				end	

			end		

		end	
	end


	#metodo auxiliar de la funcion Walk
	#recorre los hijos del nodo
	#aplicandoles un predicado
	def recursorWalk(pila,nodo,predicate)
		if nodo == nil
			nil
		else	
			nodo = predicate.call nodo
			pila << nodo.value
			if not nodo.left == nil
				return nodo.recursorWalk(pila,nodo.left,predicate)
			end	
			if not nodo.right == nil
				return nodo.recursorWalk(pila,nodo.right,predicate)
			end	
		end	
	end
	
	
end

#clase grafos arbitrarios
class GraphNode

	#atributos del grafo
	attr_accessor   :value,   # Valor alamacenado en el nodo
					:children # Arreglo de sucesores GraphNode

	include BFS				

	#constructor del grafo
	def initialize(v,c)
		self.value = v
		self.children = c
	end

	#metodo para recorrer los hijos del grafo
	#mediate iteracion
	def each(b)
		for i in self.children
			return b.call i
		end
				
	end

	#metodo auxiliar recursivo de la funcion path
	#verifica si secumple la condicion
	#de ser asi retorna
	#de caso recorre los hijos del nodo
	def recursorPath(pila,nodo,predicate)
		if nodo == nil
			nil
		else	
			if (predicate.call nodo)
				pila << nodo.value
				return pila
			else
				pila << nodo.value
				for i in self.children
					return i.recursorPath(pila,i,predicate)
				end
			end		

		end	
	end

	#metodo auxiliar de la funcion Walk
	#recorre los hijos del nodo
	#aplicandoles un predicado
	def recursorWalk(pila,nodo,predicate)
		if nodo == nil
			nil
		else	
			nodo = predicate.call nodo
			pila << nodo.value
			for i in self.children
				return i.recursorWalk(pila,i,predicate)
			end		

		end	
	end


end

#varibales globales utilizadas para la generacion de hijos de un LCR
$iniciales = [[[:L,:C,:R],[]],[[:R,:C,:L],[]],[[:C,:R,:L],[]],[[:C,:L,:R],[]],[[:R,:L,:C],[]],[[:L,:R,:C],[]]]
$invizq    = [[[:L,:C],[:R]],[[:C,:L],[:R]],[[:C,:R],[:L]],[[:R,:C],[:L]]]
$invder    = [[[:R],[:L,:C]],[[:R],[:C,:L]],[[:L],[:C,:R]],[[:L],[:R,:C]]]
$finales   = [[[],[:L,:C,:R]],[[],[:R,:C,:L]],[[],[:C,:R,:L]],[[],[:C,:L,:R]],[[],[:R,:L,:C]],[[],[:L,:R,:C]]]
$visitados = []
$proc      = lambda { |x| ($finales.include? [x.left,x.right]) }

# Arboles implicitos
# Problema del Lobo, la Cabra y el Repollo
class LCR
	attr_reader     :value
	attr_accessor   :where,   # Lugar donde se encuentra el bote
					:left,    # lista de simbolos que se encuentran en la orilla izquierda
					:right,   # lista de simbolos que se encuentran en la orilla derecha
					:hash,     # Hash donde se guarda el self del nodo
					:children

	include BFS
	
	#constructor de un LCR
	def initialize(v) 
		self.hash = v
		self.where = v[:where]
		self.left = v[:left]
		self.right = v[:right]
		self.children = []
	end


	#funcion que dado un LCR genera los hijos
	#iterando sobre cada uno de sus lados
	#genera todos los posibles hijos
	#y luego descarta los estados invalidos o ya visitados
	def child_generator
		children = []
		if self.where == "Right"
			if not $invder.include? [self.left,self.right] and not $finales.include? [self.left,self.right]
				if not $visitados.include? [self.left,self.right,"Left"] and not $iniciales.include? [self.left,self.right]
					$visitados << [self.left,self.right,"Left"] 
					nuevohijo = LCR.new({:where => "Left", :left => self.left , :right => self.right})
					children << nuevohijo
				end	
			end	
		else
			if not $invizq.include? [self.left,self.right]	
				if not $visitados.include? [self.left,self.right,"Right"] and not $iniciales.include? [self.left,self.right]
					$visitados << [self.left,self.right,"Right"]
					nuevohijo = LCR.new({:where => "Right", :left => self.left , :right => self.right})
					children << nuevohijo
				end	
			end	
		end	
		for i in self.left
			auxizq = self.left.clone
			auxder = self.right.clone
			auxder << i
			auxizq.delete(i)
			if self.where == "Right"
				if not $invder.include? [auxizq,auxder] and not $finales.include? [auxizq,auxder]
					if not $visitados.include? [auxizq,auxder] and not $iniciales.include? [auxizq,auxder]
						$visitados << [auxizq,auxder]
						nuevohijo = LCR.new({:where => "Left", :left => auxizq , :right => auxder})
						children << nuevohijo
					end	
				end
			else
				if not $invizq.include? [auxizq,auxder]
					if not $visitados.include? [auxizq,auxder] and not $iniciales.include? [auxizq,auxder]
						$visitados << [auxizq,auxder]
						nuevohijo = LCR.new({:where => "Right", :left => auxizq , :right => auxder})
						children << nuevohijo
					end	
				end
			end		
		end	
		for j in self.right
			auxizq = self.left.clone
			auxder = self.right.clone
			auxizq << j	
			auxder.delete(j)
			if self.where == "Right"
				if not $invder.include? [auxizq,auxder] and not $finales.include? [auxizq,auxder]
					if not $visitados.include? [auxizq,auxder] and not $iniciales.include? [auxizq,auxder]
						$visitados << [auxizq,auxder]
						nuevohijo = LCR.new({:where => "Left", :left => auxizq , :right => auxder})
						children << nuevohijo
					end	
				end
			else
				if not $invizq.include? [auxizq,auxder]
					if not $visitados.include? [auxizq,auxder] and not $iniciales.include? [auxizq,auxder]
						$visitados << [auxizq,auxder]
						nuevohijo = LCR.new({:where => "Right", :left => auxizq , :right => auxder})
						children << nuevohijo
					end	
				end
			end
		end
		self.children = children

	end	

	#metodo auxiliar recursivo de la funcion path
	#verifica si secumple la condicion
	#de ser asi retorna
	#de caso recorre los hijos del nodo
	def recursorPath(pila,nodo,predicate)
		if nodo == nil
			nil
		else	
			if (predicate.call nodo)
				pila << nodo.hash
				return pila
			else
				pila << nodo.hash
				for i in self.children
					return i.recursorPath(pila,i,predicate)
				end
			end		

		end	
	end


	#funcion para recorer los hijos del arbol implicito
	#de manera iterativa
	def each(p)
		for i in self.children
			return p.call i
		end
	end

	#funcion que resuleve el problema LCR
	#generando los hijos de cada nodo
	#y verificando si se lleg a una respuesta correcta
	#para luego generar el camino
	def solve
		self.child_generator
		if self.find(self,$proc)
			return self.path(self,$proc)
		else
			for i in self.children
				puts i
				i.solve
			end
		end			
	end

end
