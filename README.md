`v1.1.2-STABLE`
# Processador RISC Multiciclo 32bits

Este repositório se trata de um projeto da disciplina Laboratório de Arquitetura e Organização de Computadores da UNIFESP SJC no ano de 2019, onde a proposta foi desenvolver a arquitetura e a organização de um processador, contando com conjunto de instruções, modos de endereçamento e caminho de dados do mesmo. O processador foi baseado no principio de processamento multiciclo, contendo um conjunto de instruções RISC e arquitetura Von Neumann, ou seja, apenas uma unidade de memória para manter tanto os dados quanto as instruções, usando como base a arquitetura MIPS (_Microprocessor without Interloked Pipeline Stages_). O projeto foi implementado na linguagem de descrição de _hardware_ Verilog e testado em um _kit_ FPGA.

## Sobre o Repospitório

Estão apresentados nesse repositório:
 
+ A programação Verilog
 
+ O caminho de dados (_Datapath_) do processador
 
+ Uma tabela com as instruções, seus códigos, representação assembly, organização de memória, registradores e formatos de instrução.
 
+ Manual da placa FPGA utilizada para testes
 
+ Uma arquivo compatível com o programa Visual Paradigm que contém os diagramas esquemáticos do processador
 
+ O relatório entregue no fim da UC explicando todo o funcionamento do processador

__Obs:__ O relatório pode não conter alguma informações sobre o processador ou estar com informações divergentes do código uma vez que mesmo após o término da matéria o processador seguiu sofrendo alterações. As informações mais atualizadas sobre o projeto encontram-se nesse arquivo README.md e nas imagens e códigos presentes no repositório.
 
## A Arquitetura 

 A abordagem multiciclo foi escolhida devido seu melhor desempenho e a possibilidade de uso de apenas um módulo de memória. O projeto foi baseado na arquitetura MIPS multiciclo presente no livro Organização e Projeto de Computadores: A Interface Hardware/Software de David A. Patterson e John L. Henessy. O _datapath_ detalhado do processador pode ser visto na figura __Datapath.png__.
 
Alguns módulos presentes nesse nesse projeto não são encontrados no _datapath_ original presente no livro do Patterson, isso porque por escolhas de projeto foram inseridos os módulos _Input_ e _Output_ para que pudesse haver uma interface entre o processador e o usuário. Além disso também foi incluída uma pilha de endereços que tem o intuito de tratar a existência de códigos com recursão de uma maneira mais ágil.
 
## Instruções
 
O conjunto de instruções escolhido para o projeto pode ser dividido em quatro formato de instruções sendo eles tipo R para instruções com operações que utilizam apenas operandos com seus valores guardados no banco de registradores, tipo I para instruções que utilizam além de valores presentes em registradores um valor imediato, tipo J para instruções de Jump e tipo SYS para instruções específicas para os módulos de E/S (entrada e saída) e a instrução _halt_, sendo o ultimo tipo uma adição não presente na arquitetura MIPS.

Foi optado por um conjunto de instruções do tipo RISC, com instruções não muito complexas e poucos formatos de instrução. O conjunto de instruções também foi baseado no conjunto presente no processador MIPS de Organização e Projeto de Computadores, com algumas alterações como novas instruções e novos formatos de instrução. Algumas instruções presentes no conjunto também contêm uma leve variação de seu formato em relação à sua categoria e tudo isso pode ser visto na figura __Conjunto de Instruções.png__.   

## Memória e Banco de Registradores

Como pode ser visto na figura __Datapath.png__, apenas um módulo de memória foi implementado no projeto desse processador, ou seja, foi adotado o princípio de arquitetura Von Neumann onde a memória de instruções se encontra junta com a memória de dados.

Para esse projeto optou-se por utilizar de apenas 5 modos de endereçamento, sendo eles endereçamento direto, utilizado nas instruções do tipo J, SYS e _branches_, endereçamento por registrador, utilizado nas instruções do tipo R, I e SYS, endereçamento imediato, utilizado nas instruções do tipo I, endereçamento por pilha, exclusivo das instruções _jst_ e _jal_ e endereçamento por deslocamento, exclusivo das instruções _ldr_ e _str_. Com isso tem-se uma limitação para o tamanho da memória, uma vez que o maior endereço que a instrução _jmp_ alcança é 67.108.863 por existirem apenas 26 bits direcionados para endereço, ou seja, existe um limite para o tamanho máximo de memória de aproximadamente 8 MB, porém essa limitação não afeta o projeto uma vez que, para simplificação de compilação e otimização do uso da memória da FPGA durante o teste foi utilizado uma memória com 512 posições, ou seja, são necessários apenas 9 bits de endereço para acessar toda a memória. A memória foi dividida em um bloco de aproximadamente 70\% e outro de 30\%, onde os endereços entre 0 e 360 foram atribuídos para instruções e os endereços entre 361 e 511 foram atribuídos para dados, sendo esse segundo divido entre varíaveis globais (poições entre 361 e 461) e variáveis locais (posições entre 461 e 511).

Assim como a memória, o banco de registradores também foi dividido. Os 32 registradores foram divididos em cinco categorias sendo elas Zero, Variáveis, Parâmetros, Retorno e Ponteiro, onde o primeiro registrador foi definido como categoria Zero, uma vez que o mesmo guarda apenas o valor zero e leva o nome $zero, os registradores entre 1 e 19 foram definidos como registradores para armazenamento de Variáveis durante operações, sendo nomeados com valores entre $r1 e $r19, os entre 20 e 29 são de categoria Parâmetros e são utilizados para a passagem de parâmetros entre funções e nomeados de $p1 à $p10, e os dois últimos registradores foram categorizados respectivamente como Retorno e Ponteiro, onde o primeiro nomeado como $ret carrega o valor de retorno de uma função e o segundo nomeado como $lp é utilizado para guardar endereços de memória de inicio de escopos.

## Entrada e Saída

O módulos de entrada e saída foram planejados para funcionar acoplados ao Registrador de Dados de Memória e ao Banco de Registradores respectivamente, de modo que o valor de entrada seja primeiramente carregado no Registrador de Dados de Memória para então ser carregado no Banco de Registradores, no endereço referente ao valor de RF na palavra de instrução _in_. Já quanto ao módulo de saída, a instrução _out_ carregará o dado armazenado no registrador RF presente em sua palavra de instrução no módulo _Output_ para que assim o valor possa ser tratado pela mesma e mostrado nos displays de 7 segmentos de placa.

A unidade de entrada trabalha com uma interrupção do processamento, onde o mesmo aguarda a ativação de uma chave de controle que indica que o dado já foi completamente inserido e está pronto para ser carregado.

## Configurações do Processador

Abaixo estão descritas algumas configurações de operação do processador.

+ Pinagem definida: FPGA DE10-Lite (10M5.0DAF.484C.7G)

+ Clock: 0.5 Hz (expansível até 50 Khz)

+ Número de instruções implementadas: 34 (expansível até 127)

+ Tamanho de memória: 128 Bytes (expansível até 8 MB)

+ Tratamento de números negativos: Não Trata

+ Linguagens suportadas: [C-](https://github.com/AndrewCampos/CompiladorC-)

## Resultados

O processador segue passando em todos testes, tendo garantido o funcionamento de todas as suas unidades e instruções. Os próximos passos de aprimoramento do processador contam com o tratamento de números negativos, o teste em conjunto com o compilador para a linguagem C- e a inserção de um método _reset_ para reiniciar o processamento de determinado código.



