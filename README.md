# aes-encryption-vhdl

* **Repositório GitHub:** [aes-encryption-vhdl](https://github.com/thalescazevedo/aes-encryption-vhdl.git)
* **Código do Grupo:** AP3-05235A — Grupo A
    ### Group: 
        * Artur de Faria Rodrigo;
        * João Pedro Floriano;
        * Nicolas de Brito Mafra;
        * Pedro Zumstein Bilac;
        * Thales Campos de Azevedo;
        * Thasio Santos Silva.
    
* **Alerta**
    O projeto demora entre 20 a 30 minutos para compilar no Quartus Prime. O motivo para tal será apresentado no relatório,
    mas em suma se refere a uma matriz, que se fosse um vetor, teria 1920 bits. Ela faz parte do processo de criptografia
    e é acessada diversas vezes. Ela também é a responsável por fazer-nos atingir mais de 30 mil funções combinacionais.

    Todavia, a criptografia é perfeita em cada etapa, sendo comprovada pelos testbenchs.
    
* **About**
    Este trabalho visa implementar o **algoritmo de criptografia AES**

    Tecnologia de uso militar e globalmente reconhecida como uma das principais soluções para criptografia de dados,
    a AES possui três versões: AES-128, AES-192 e AES-256. A diferença fundamental é o tamanho da chave(senha) do usuário (16, 24 ou 32 bytes).

* **Updates**
    28-05:
    1. Até o presente momento (entrega 1), o projeto já está em desenvolvimento, e todas as entidades já estão declaradas, como é possível ver na pasta.
    2. Atualização antes da entrega 1: diagramas já estão feitos, toplevel, bo e bc tambem

    15-06:
    1. Estamos implementando o algoritmo para os três tipos de AES, com um seletor em tempo de execução.
    2. Até o momento da entrega 2, a princípio, o código já está completo, faltando testá-lo em um compilador e 
    criar os Testbenchs.

    25-06:
    1. Estava repleto de erros. Isso fez com que voltássemos a concepção de gerar as chaves de rodada todas de uma vez só.
    2. Agora, o datapath é dividido em dois blocos operativos, um para cálculo do valor da rodada e outro para as chaves.
