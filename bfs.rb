# Universidad Simón Bolívar 
# CI3661 - Laboratorio de Lenguajes de Programación 
 
# Dayana Rodrigues 10-10615
# Roberto Romero   10-10642

#Modulo BFS
module BFS

	def find(start,predicate)
		procfind = lambda do
			        |x| 
			        if (predicate.call x) == true
			        	puts x.value
			        	return x.value
					else
						find(x,predicate)
					end	

		end	       
		start.each(procfind)

	end

	def path(start,predicate)
		procpath = lambda do
			        |x| 
			        predicate.call x 
		end	       
		start.each(procpath)

	end	


	def walk(start,action)
		procwalk = lambda do
			        |x| 
			        action.call x
					walk(x,predicate)
		end	       
		start.each(procwalk)
	end

end	

#clase arbol binario
class BinTree 

	attr_accessor   :value, # Valor almacenado en el nodo 
					:left,  # Hijo (BinTree) izquierdo
					:right  # Hijo (BinTree) derecho

	include BFS				

	def initialize(v,l,r)
		self.value = v
		self.left = l
		self.right = r
	end

	def each(b)
		if not self.left == nil
			return b.call self.left
		end	
		if not self.right == nil
			return b.call self.right	
		end	

	end
	
	
end

#clase grafos arbitrarios
class GraphNode

	attr_accessor   :value,   # Valor alamacenado en el nodo
					:children # Arreglo de sucesores GraphNode

	include BFS				

	def initialize(v,c)
		self.value = v
		self.children = c
	end

	def each(b)
		if not self.children == nil
			return b.call self.children
		end	

	end

end

# Arboles implicitos
# Problema del Lobo, la Cabra y el Repollo
class LCR
	attr_reader     :value
	attr_accessor   :where,   # Lugar donde se encuentra el bote
					:left,    # lista de simbolos que se encuentran en la orilla izquierda
					:right    # lista de simbolos que se encuentran en la orilla derecha

	include BFS

	def initialize(v) 
		self.where = v[:where]
		self.left = v[:left]
		self.right = v[:right]

	end

	def each(p)

	end

	def solve

	end

end

##pruebas
def e
	e = BinTree.new(8,nil,nil)
	d = BinTree.new(3,nil,e)
	c = BinTree.new(5,d,nil)
	b = BinTree.new(3,c,nil)
	return a = BinTree.new(1,b,nil)
end




