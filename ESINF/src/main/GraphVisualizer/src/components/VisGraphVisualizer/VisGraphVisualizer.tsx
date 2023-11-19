import React, { FC, useRef, useState, useEffect } from "react";
import styles from "./VisGraphVisualizer.module.css";

import { Network, Data, Options } from "vis-network";
import Graph from "../../interfaces/Graph";

interface VisGraphVisualizerProps {}

const VisGraphVisualizer: FC<VisGraphVisualizerProps> = () => {
    const jsonAreaRef = useRef(HTMLTextAreaElement);
    const graphRef = useRef<HTMLDivElement>();

    const [graph, setGraph] = useState<Graph>({
        kind: true,
        nodes: [],
        edges: [],
    });

    const getFileData = () => {
        let text = jsonAreaRef.current.value;
        let js: Graph = JSON.parse(jsonAreaRef.current.value);
        console.log(js);
        setGraph(js);
    };

    const options: Options = {
        edges: {
            smooth: false,
            arrows: {
                to: false,
                middle: false,
                from: false,
            },
            length: 350,
            scaling: {
                min: 1,
                max: 10,
                label: {
                    enabled: true,
                },
            },
        },
        physics: {
            enabled: true,
        },
        interaction: {
            hoverConnectedEdges: true,
            hover: true,
        },
        layout: {
            improvedLayout: true,
        },
    };

    useEffect(() => {
        let data: Data = {
            nodes: graph.nodes,
            edges: graph.edges,
        };
        const network =
            graphRef.current && new Network(graphRef.current, data, options);
    }, [graph]);

    return (
        <div className={styles.VisGraphVisualizer}>
            <div id="Graph" ref={graphRef}></div>
            <div id="json" className={styles.dataInput}>
                <textarea
                    ref={jsonAreaRef}
                    className={styles.dataTextArea}
                    cols={30}
                    rows={10}
                    placeholder="Paste JSON data here"
                ></textarea>
                <div>
                    <button onClick={getFileData} className={styles.LoadButton}>
                        Load
                    </button>
                </div>
            </div>
        </div>
    );
};

export default VisGraphVisualizer;
