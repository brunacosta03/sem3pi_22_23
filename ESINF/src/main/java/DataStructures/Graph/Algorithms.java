package DataStructures.Graph;

import DataStructures.Graph.map.MapGraph;
import Domain.Member;

import java.util.*;
import java.util.function.BinaryOperator;

/**
 *
 * @author DEI-ISEP
 *
 */
public class Algorithms {

    /** Performs breadth-first search of a Graph starting in a vertex
     *
     * @param g Graph instance
     * @param vert vertex that will be the source of the search
     * @return a LinkedList with the vertices of breadth-first search
     */
    public static <V, E> LinkedList<V> BreadthFirstSearch(Graph<V, E> g, V vert) {

        if (!g.validVertex(vert))
            return null;

        LinkedList<V> qbfs = new LinkedList<>();
        LinkedList<V> qaux = new LinkedList<>();
        boolean[] visited = new boolean[g.numVertices()];  //default initializ.: false

        qbfs.add(vert);
        qaux.add(vert);
        int vKey = g.key(vert);
        visited[vKey] = true;

        while (!qaux.isEmpty()) {
            vert = qaux.remove();
            for (V vAdj : g.adjVertices(vert)) {
                vKey = g.key(vAdj);
                if (!visited[vKey]) {
                    qbfs.add(vAdj);
                    qaux.add(vAdj);
                    visited[vKey] = true;
                    }
                }
            }
        return qbfs;
    }

    /** Performs depth-first search starting in a vertex
     *
     * @param g Graph instance
     * @param vOrig vertex of graph g that will be the source of the search
     * @param visited set of previously visited vertices
     * @param qdfs return LinkedList with vertices of depth-first search
     */
    private static <V, E> void DepthFirstSearch(Graph<V, E> g, V vOrig, boolean[] visited, LinkedList<V> qdfs) {

        int vKey = g.key(vOrig);
        if (visited[vKey]) return;

        qdfs.add(vOrig);
        visited[vKey] = true;

        for (V vAdj : g.adjVertices(vOrig)) {
            DepthFirstSearch(g, vAdj, visited, qdfs);
        }

    }

    /** Performs depth-first search starting in a vertex
     *
     * @param g Graph instance
     * @param vert vertex of graph g that will be the source of the search

     * @return a LinkedList with the vertices of depth-first search
     */
    public static <V, E> LinkedList<V> DepthFirstSearch(Graph<V, E> g, V vert) {
        if (!g.validVertex(vert))
            return null;

        LinkedList<V> qdfs = new LinkedList<>();
        boolean[] visited = new boolean[g.numVertices()];

        DepthFirstSearch(g, vert, visited, qdfs);

        return qdfs;
    }

    /** Returns all paths from vOrig to vDest
     *
     * @param g       Graph instance
     * @param vOrig   Vertex that will be the source of the path
     * @param vDest   Vertex that will be the end of the path
     * @param visited set of discovered vertices
     * @param path    stack with vertices of the current path (the path is in reverse order)
     * @param paths   ArrayList with all the paths (in correct order)
     */
    private static <V, E> void allPaths(Graph<V, E> g, V vOrig, V vDest, boolean[] visited,
                                        LinkedList<V> path, ArrayList<LinkedList<V>> paths) {

        int vKey = g.key(vOrig);
        if (visited[vKey]) return;

        if (vOrig.equals(vDest)) {
            LinkedList<V> pathcopy = new LinkedList<>(path);
            pathcopy.addFirst(vDest);
            Collections.reverse(pathcopy);
            paths.add(new LinkedList<>(pathcopy));
            return;
        }

        path.push(vOrig);
        visited[vKey] = true;

        for (V vAdj : g.adjVertices(vOrig)) {
            allPaths(g, vAdj, vDest, visited, path, paths);
        }

        path.pop();
        visited[vKey] = false;
    }

    /** Returns all paths from vOrig to vDest
     *
     * @param g     Graph instance
     * @param vOrig information of the Vertex origin
     * @param vDest information of the Vertex destination
     * @return paths ArrayList with all paths from vOrig to vDest
     */
    public static <V, E> ArrayList<LinkedList<V>> allPaths(Graph<V, E> g, V vOrig, V vDest) {

        LinkedList<V> path = new LinkedList<>();
        ArrayList<LinkedList<V>> paths = new ArrayList<>();
        boolean[] visited = new boolean[g.numVertices()];

        if (g.validVertex(vOrig) && g.validVertex(vDest))
            allPaths(g, vOrig, vDest, visited, path, paths);

        return paths;
    }

    /**
     * Computes shortest-path distance from a source vertex to all reachable
     * vertices of a graph g with non-negative edge weights
     * This implementation uses Dijkstra's algorithm
     *
     * @param g        Graph instance
     * @param vOrig    Vertex that will be the source of the path
     * @param visited  set of previously visited vertices
     * @param pathKeys minimum path vertices keys
     * @param dist     minimum distances
     */
    private static <V, E> void shortestPathDijkstra(Graph<V, E> g, V vOrig,
                                                    Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                                    boolean[] visited, V [] pathKeys, E [] dist) {


        int vkey = g.key(vOrig);
        dist[vkey] = zero;
        pathKeys[vkey] = vOrig;
        while (vOrig != null) {
            vkey = g.key(vOrig);
            visited[vkey] = true;
            for (Edge<V, E> edge : g.outgoingEdges(vOrig)) {
                int vkeyAdj = g.key(edge.getVDest());
                if (!visited[vkeyAdj]) {
                    E s = sum.apply(dist[vkey], edge.getWeight());
                    if (dist[vkeyAdj] == null || ce.compare(dist[vkeyAdj], s) > 0) {
                        dist[vkeyAdj] = s;
                        pathKeys[vkeyAdj] = vOrig;
                    }
                }
            }
            E minDist = null;
            vOrig = null;
            for (V vert : g.vertices()) {
                int i = g.key(vert);
                if (!visited[i] && (dist[i] != null) && ((minDist == null) || ce.compare(dist[i], minDist) < 0)) {
                    minDist = dist[i];
                    vOrig = vert;
                }
            }
        }

    }



    /**
     * Computes shortest-path distance from a source vertex to all reachable
     * vertices of a graph g with non-negative edge weights
     * This implementation uses Dijkstra's algorithm
     *
     * @param g     Graph instance
     * @param vOrig information of the Vertex origin
     * @return pathKeys minimum path vertices keys
     * @return dist minimum distances
     */
    public static <V, E> void shortestPathDijkstra(Graph<V, E> g, V vOrig,
                                                   Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                                   V[] pathKeys, E[] dist) {
        if (g.validVertex(vOrig)) {
            boolean[] visited = new boolean[g.numVertices()];
            shortestPathDijkstra(g, vOrig, ce, sum, zero, visited, pathKeys, dist);
        }
    }

    /**
     * Computes shortest-path distance from a source vertex to all reachable
     * vertices of a graph g with non-negative edge weights
     * This implementation uses Dijkstra's algorithm
     *
     * @param g     Graph instance
     * @param vOrig information of the Vertex origin
     * @return pathKeys minimum path vertices keys
     * @return dist minimum distances
     */
    public static <V, E> void shortestPathDijkstra(Graph<V, E> g, V vOrig,
                                                   Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                                   V[] pathKeys, E[] dist, int[] numPaths) {
        if (g.validVertex(vOrig)) {
            boolean[] visited = new boolean[g.numVertices()];
            shortestPathDijkstra(g, vOrig, ce, sum, zero, visited, pathKeys, dist);
        }

    }


    /** Shortest-path between two vertices
     *
     * @param g graph
     * @param vOrig origin vertex
     * @param vDest destination vertex
     * @param ce comparator between elements of type E
     * @param sum sum two elements of type E
     * @param zero neutral element of the sum in elements of type E
     * @param shortPath returns the vertices which make the shortest path
     * @return if vertices exist in the graph and are connected, true, false otherwise
     */
    public static <V, E> E shortestPath(Graph<V, E> g, V vOrig, V vDest,
                                        Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                        LinkedList<V> shortPath) {

        if (!g.validVertex(vOrig) || !g.validVertex(vDest))
            return null;

        shortPath.clear();
        int numVerts = g.numVertices();
        boolean[] visited = new boolean[numVerts]; //default value: false
        @SuppressWarnings("unchecked")
        V[] pathKeys = (V[]) new Object [numVerts];
        @SuppressWarnings("unchecked")
        E[] dist = (E[]) new Object [numVerts];
        initializePathDist(numVerts, pathKeys, dist);

        shortestPathDijkstra(g, vOrig, ce, sum, zero, visited, pathKeys, dist);

        E lengthPath = dist[g.key(vDest)];

        if (lengthPath != null) {
            getPath(g, vOrig, vDest, pathKeys, shortPath);
            return lengthPath;
        }
        return null;
    }

    /** Shortest-path between a vertex and all other vertices
     *
     * @param g graph
     * @param vOrig start vertex
     * @param ce comparator between elements of type E
     * @param sum sum two elements of type E
     * @param zero neutral element of the sum in elements of type E
     * @param paths returns all the minimum paths
     * @param dists returns the corresponding minimum distances
     * @return if vOrig exists in the graph true, false otherwise
     */
    public static <V, E> boolean shortestPaths(Graph<V, E> g, V vOrig,
                                               Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                               ArrayList<LinkedList<V>> paths, ArrayList<E> dists) {

        if (!g.validVertex(vOrig)) return false;

        paths.clear(); dists.clear();
        int numVerts = g.numVertices();
        boolean[] visited = new boolean[numVerts]; //default value: false
        @SuppressWarnings("unchecked")
        V[] pathKeys = (V[]) new Object [numVerts];
        @SuppressWarnings("unchecked")
        E[] dist = (E[]) new Object [numVerts];
        initializePathDist(numVerts, pathKeys, dist);

        shortestPathDijkstra(g, vOrig, ce, sum, zero, visited, pathKeys, dist);

        dists.clear();
        paths.clear();
        for (int i = 0; i < numVerts; i++) {
            paths.add(null);
            dists.add(null);
        }
        for (V vDst : g.vertices()) {
            int i = g.key(vDst);
            if (dist[i] != null) {
                LinkedList<V> shortPath = new LinkedList<>();
                getPath(g, vOrig, vDst, pathKeys, shortPath);
                paths.set(i, shortPath);
                dists.set(i, dist[i]);
            }
        }
        return true;
    }

    private static <V, E> void initializePathDist(int nVerts, V [] pathKeys, E[] dist) {
        for (int i = 0; i < nVerts; i++) {
            dist[i] = null;
            pathKeys[i] = null;
        }
    }

    /**
     * Extracts from pathKeys the minimum path between voInf and vdInf
     * The path is constructed from the end to the beginning
     *
     * @param g        Graph instance
     * @param vOrig    information of the Vertex origin
     * @param vDest    information of the Vertex destination
     * @param pathKeys minimum path vertices keys
     * @param path     stack with the minimum path (correct order)
     */
    private static <V, E> void getPath(Graph<V, E> g, V vOrig, V vDest,
                                       V [] pathKeys, LinkedList<V> path) {

        if (vOrig.equals(vDest))
            path.push(vOrig);
        else {
            path.push(vDest);
            int vKey = g.key(vDest);
            vDest = pathKeys[vKey];
            getPath(g, vOrig, vDest, pathKeys, path);
        }
    }

    /**
     * Minimum spanning tree - Kruskall Algorithm
     * @param graphMST MST graph with all vertices
     * @param edgesList order list of edges by Weight
     */
    public static void kruskallAlgorithm(Graph<Member, Double> graphMST, ArrayList<Edge<Member, Double>> edgesList){
        for (Edge<Member, Double> edge: edgesList) {
            LinkedList<Member> connectedVets = Algorithms.DepthFirstSearch(graphMST, edge.getVOrig());

            if(!connectedVets.contains(edge.getVDest())){
                graphMST.addEdge(edge.getVOrig(), edge.getVDest(), edge.getWeight());
            }
        }
    }



	public static <V, E> int GraphDiameter(MapGraph<V, E> membersLocationGraph) {
        int currDiameter = 0;
        for (V v1 : membersLocationGraph.vertices()) {
            for (V v2 : membersLocationGraph.vertices()) {
                if (v1 != v2) {



                }
            }
        }
        return currDiameter;
	}
}
