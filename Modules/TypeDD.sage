import numpy as np

class TypeDD:
	# gens - a list of generators
    # edges_out - a dictionary keyed by source generators
    # edges_in - a dictionary keyed by target generators
    # deleted edge data...it is stored in the gens
    # dictionary values are lists of edges (each edge is a 5-tuple (source, target, a, b, m))
	def __init__(self, gens):
		self.gens = gens
		self.edges_out = edges_out
		self.edges_in = edges_in
	
	# other is a TypeAA (only option for TypeDD)
	def tensor(self, other):
		#assert self.rightalgebra = other.leftalgebra, #pseudo - where are the left and right algebras stored?
		#	"Error: Algebras not compatible"
		MNgens = np.zeros(length(self.gens),length(other.gens)) # I think a list will be more efficient than a matrix, since it will probably be quite sparse, but we should discuss
		listKey = 0
		for i in length(self.gens):
			for j in length(other.gens):
				if self.gens[i][1] == other.gens[j][0]: #this assumes generators are a tuple (eL, eR)
					MNgens[i][j] = [self.gens[i][0],other.gens[j][1],listKey] #(xeL, yeR)
					listKey += 1
		MNedgeDict = {}

		for j in length(other.gens):
			for yedge in other.edges_out[j]:
				for i in length(self.gens):
					if MNgens[i][j] != 0:
						if yedge.a_coefficient == []:
							futureIndex = MNgens[i][j][2]
							if futureIndex in MNedgeDict:
								MNedgeDict[futureIndex].append(Edge(futureIndex, MNgens[i][yedge.target][2], [], yedge.b_coefficient, yedge.m_coefficient))
							else:
								MNedgeDict[futureIndex] = [Edge(futureIndex, MNgens[i][yedge.target][2], [], yedge.b_coefficient, yedge.m_coefficient)]
						else: #if a_coeff is not empty
							for xedge in self.edges_out[i]:
								if xedge.b_coefficient == yedge.a_coefficient:
									futureIndex = MNgens[i][j][2]
									if futureIndex in MNedgeDict:
										MNedgeDict[futureIndex].append(Edge(futureIndex,MNgens[i][yedge.target][2], xedge.a_coefficient,yedge.b_coefficient, xedge.m_coefficient*yedge.m_coefficient))
									else:
										MNedgeDict[futureIndex] = [Edge(futureIndex,MNgens[i][yedge.target][2], xedge.a_coefficient,yedge.b_coefficient, xedge.m_coefficient*yedge.m_coefficient)]

		for i in length(self.gens):
			iedges = self.edges_out[i]
			for e in iedges:
				for j in length(other.gens):
					if MNgens[i][j] != 0:
						xedge = self.gens[i]
						if xedge.b_coefficient == []:
							futureIndex = MNgens[i][j][2]
							if futureIndex in MNedgeDict:
								MNedgeDict[futureIndex].append(Edge(futureIndex, MNgens[xedge.target][j][2],xedge.a_coefficient, [], xedge.m_coefficient))
							else:
								MNedgeDict[futureIndex] = [Edge(futureIndex, MNgens[xedge.target][j][2],xedge.a_coefficient, [], xedge.m_coefficient)]

		#put generators in list
		outGenList = []
		for i in length(self.gens):
			for j in length(other.gens):
				if MNgens[i][j] != 0:
					outGenList.append([MNgens[i][j][0],MNgens[i][j][1]])

		#TODO: make dictionary keyed by target generators

		
	def reduce(self):
		# TODO
		break

	# #creates a dictionary of the edges, keyed by source vertex. The values are a list of edges.
	# def dictEdges(self,edges): # matrix instead??
	# 	edgeDict = dict()
	# 	for e in edges:
	# 		if e.source in edgeDict:
	# 			edgeDict[e.source].append(e)
	# 			# I'm not convinced the above works as I intend - need to test small example
	# 		else:
	# 			edgeDict[e.source] = [e]
	# 	return edgeDict

		
    # test if edge is empty
    # maybe this should go somewhere else ?
    # input is an edge
    def is_empty_edge(self):
        assertion_1 = (self.source.idempotent_left == self.a_coefficient)
        assertion_2 = (self.source.idempotent_right == self.a_coefficient)
        assertion_3 = (self.m_coefficient == 1) # 1 in kk
        if assertion_1 and assertion_2 and assertion_3:
            return True
        else:
            return False

    # input is list of generators
	def get_reducible_edge(self):
        for x in self.gens:
            for e in x.edges_out:
                if is_empty_edge(e):
                    return [e]
        return []

    # input is a TypeDD
    # copy generators and update
    # or we could build a new TypeDD completely...
    def reduce(self):
        # first look for a reducible edge
        edge_list = get_reducible_edges(self.gens)
        if len(edge_list) == 0: # in this case self is reduced
            return self
        else: # in this case we have at least one edge to reduce
            old_gens = self.gens
            edge = edge_list[0]
            source = edge.source # x
            target = edge.target # y
            new_gens = self.gens
            for z in new_gens:
                if not (z in [source, target]):
                    # compute all targets of z
                    z_targets = [ edge[1] for edge in z.edges_out ]
                    for w in new_gens:
                        if not (w in [source, target]):
                            z_points_to_y = y in z_targets
                            # compute all sources of w
                            w_sources = [ edge[0] for edge in w.edges_in ]
                            x_points_to_w = x in w_sources
                            # if z points to y and x points to x then update edge from z to w
                            if z_points_to_y and x_points_to_w: # otherwise don't update anything
                                # TODO MATH
                                # new_gens are the generators that get updated to make new TypeDD
            # delete all x,y data
            # delete source and target generators of edge to be reduced
            new_gens.remove(source)
            new_gens.remove(target)
            # make new TypeDD
            break

    class Generator:
        # in/out edges
        # left/right idempotents
        def __init__(self, edges_in, edges_out, idempotent_left, idempotent_right):
            self.edges_in = edges_in
            self.edges_out = edges_out
            self.idempotent_left = idempotent_left
            self.idempotent_right = idempotent_right

	# represents the action of some delta_1 on some pair of generators
	class Edge:
		# source, target - elements of gens
		# a_coefficient - element of A
		# m_cofficient - element of k
		# b_coefficient - element of B
		# 
		# condition: delta_1(source) = a_coefficient (X) (m_coefficient * target) (X) b_coefficient
        def __init__(self, source, target, a_coefficient, b_coefficient, m_coefficient):
			self.source = source
			self.target = target
			self.a_coefficient = a_coefficient
			self.b_coefficient = b_coefficient
			self.m_coefficient = m_coefficient

# 03/01/19
# NOTES (tensor says)
# generators: list, we care about index
# edges: dictionary, keyed by index of source generator
