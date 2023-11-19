export interface Graph{
    kind: true,
    nodes: Node[],
    edges: Edge[]
}

interface Node {
    id: string,
    label: string,
    color?: string,
}

interface Edge {
    from: string,
    to: string
}

export default Graph;