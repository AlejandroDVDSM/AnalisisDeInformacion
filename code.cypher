// CREATION OF THE PROJECTION
CALL gds.graph.create(
    'LoLGraph',
    ['Champion', 'Position', 'Role', 'Item', 'Spell'],
    {
        POPULAR_POSITION: {
            type: 'HAS_POPULAR_POSITION'
        },

        HAS_ROLE: {
            type: 'HAS_ROLE'
        },

        HAS_STARTER_ITEM: {
            type: 'HAS_STARTER_ITEM'
        },

 
        HAS_POPULAR_SPELL: {
            type: 'HAS_POPULAR_SPELL'
        },

        HAS_COUNTER: {
            type: 'HAS_COUNTER'
        }
    }
);

// AlGORITHM COST
CALL gds.nodeSimilarity.write.estimate(
    'LoLGraph', {
        writeRelationshipType: 'SIMILAR',
        writeProperty: 'score'
    })
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory, treeView

// GRAPH COST
CALL gds.graph.create.estimate('*', '*', {
  nodeCount: 46,
  relationshipCount: 131,
  nodeProperties: 'name'
})
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory, treeView

// SIMILARITY BETWEEN ALL CHAMPIONS IN ALPHABETICAL ORDER
CALL gds.nodeSimilarity.stream('LoLGraph', {topK: 19})  
YIELD node1, node2, similarity
RETURN gds.util.asNode(node1).name AS Champion1, gds.util.asNode(node2).name AS Champion2, similarity
ORDER BY node1 ASCENDING, Champion1, Champion2

// SIMILARITY BETWEEN ALL CHAMPIONS ORDERED BY DESCENDING SIMILARITY
CALL gds.nodeSimilarity.stream('LoLGraph', {topK: 19})  
YIELD node1, node2, similarity
RETURN gds.util.asNode(node1).name AS Champion1, gds.util.asNode(node2).name AS Champion2, similarity
ORDER BY similarity DESCENDING, Champion1, Champion2

// CHAMPION AND HIS OTHER MOST SIMILAR CHAMPION
CALL gds.nodeSimilarity.stream('LoLGraph', {topK: 1})  
YIELD node1, node2, similarity
RETURN gds.util.asNode(node1).name AS Champion1, gds.util.asNode(node2).name AS Champion2, similarity
ORDER BY similarity DESCENDING, Champion1, Champion2

// CHAMPION AND HIS OTHER LESS SIMILAR CHAMPION
CALL gds.nodeSimilarity.stream('LoLGraph', {bottomK: 1})  
YIELD node1, node2, similarity
RETURN gds.util.asNode(node1).name AS Champion1, gds.util.asNode(node2).name AS Champion2, similarity
ORDER BY similarity DESCENDING, Champion1, Champion2
