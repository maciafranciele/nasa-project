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

O GroypByKey obriga cada executor conter todos os valores de uma determinada chave na memória antes de aplicar a função de agrupamento a eles. Se tiver uma grande quantidade de dados, algumas partições poderão estar completamente sobrecarregadas com uma tonelada de valores para uma determinada chave e poderá obter OutOfMemoryErrors. No reduceByKey, a redução por chave acontece dentro de cada partição e assim não é preciso juntar tudo na memória.

**Explique o que o código Scala abaixo faz.**
val textFile = sc.textFile("hdfs://...")
val counts = textFile.flatMap(line => line.split(" "))
.map(word => (word, 1))
.reduceByKey(_ + _)
counts.saveAsTextFile("hdfs://...")

o código está lendo um arquivo do HDFS e jogando na variável textFile
depois está definindo que as linhas dos arquivos são divididas com espaço, gerando assim um objeto que tem 1 palavra por linhas. Em seguida está criando um mapa com a chave contendo a palavra e o valor 1 para cada uma, reduzindo(agrupando) por palavras similates e contando-as. No final salva o resultado no HDFS.

**Desafio:HTTP​ ​requests​ ​to​ ​the​ ​NASA​ ​Kennedy​ ​Space​ ​Center​ ​WWW​ ​server**

Questão1: Número de hosts únicos.

| qty_host_unicos 	|
|-----------------	|
| 137933          	|

Questão2: O total de erros 404.
R: 20899

Questão3:Os 5 URLs que mais causaram erro 404.

| endpoint             	| count 	|
|----------------------	|-------	|
| /pub/winvn/readme... 	| 2004  	|
| /pub/winvn/releas... 	| 1732  	|
| /shuttle/missions... 	| 683   	|
| /shuttle/missions... 	| 428   	|
| /history/apollo/a... 	| 384   	|

Questão4:Quantidade de erros 404 por dia.

| timestamp            	| count 	|
|----------------------	|-------	|
| 04/Aug/1995:14:53... 	| 1     	|
| 06/Aug/1995:02:38... 	| 1     	|
| 07/Aug/1995:01:57... 	| 1     	|
| 07/Aug/1995:09:25... 	| 1     	|
| 07/Aug/1995:09:58... 	| 1     	|
| 07/Aug/1995:13:12... 	| 1     	|
| 08/Aug/1995:02:40... 	| 1     	|
| 08/Aug/1995:16:06... 	| 1     	|
| 09/Aug/1995:09:02... 	| 1     	|
| 09/Aug/1995:15:24... 	| 2     	|
| 09/Aug/1995:16:12... 	| 1     	|
| 10/Aug/1995:13:55... 	| 1     	|
| 11/Aug/1995:07:28... 	| 1     	|
| 11/Aug/1995:15:53... 	| 1     	|
only showing top 20 rows

Questão5:O total de bytes retornados.

| sum(content_size) 	|
|-------------------	|
| 65524314915       	|

**Script Pyspark:**
/spark/nasa_project.py
from pyspark.sql.functions import regexp_extract (biblioteca regex para identificar padrões do arquivo de log)

**Shell:**
/shell/nasa_project.sh
Contém spark-submit para execução do .py e adiciona dependencias de dados no hdfs

