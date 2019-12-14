# nasa-project

**Qual o objetivo do comando cache​ ​em Spark?**

Em um job Spark, muitas vezes reutilizamos o mesmo objeto (Dataframe, tabela ou RDD) para diferentes transformações. O cache do spark é utilizado para otimizar o processamento. Ele coloca o objeto em um armazenamento temporário (memória ou disco) dos executors, tornando as releituras mais rápidas. 
Sabendo que o Spark possui o comportamento lazy evalution, onde ele executa as transformações apenas depois de uma instrução de ação, manter o status do objeto que deseja ser reutilizado outras vezes em cache, evitaria a repetição de transformações.

**O mesmo código implementado em Spark é normalmente mais rápido que a implementação equivalente em
MapReduce. Por quê?**

O spark consegue ser mais rápido que o MapReduce, porque ele faz o processamento na memória principal dos executors e evita as operações de entrada e saída de dados desnecessárias com os discos.

**Qual é a função do SparkContext​?**

Na arquitetura Spark, o SparkContext representa a conexão com o cluster Spark. Ele é o ponto de entrada da sessão Spark. Por meio de um SparkContext, pode criar RDDs, acumulators e variáveis de broadcast e executar código no cluster.


**Explique com suas palavras o que é Resilient​ ​Distributed​ ​Datasets​ (RDD)**  

RDDs são estruturas de dados imutáveis, particionadas que permite o processamento paralelo. Diferente do Dataframe, o RDD é uma estrutura que não possui schema sql friendly, são na verdade conjuntos de objetos da linguagem onde o Spark foi programado. RDDs, são estruturas que muitas vezes exigem um tratamento manual.

**GroupByKey​ ​é menos eficiente que reduceByKey​ ​em grandes dataset. Por quê?**
