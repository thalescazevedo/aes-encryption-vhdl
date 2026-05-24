# aes-encryption-vhdl
AES encryption in hardware - VHDL implementation
    AP3-05235A-Grupo-A
    Group: 
        Artur de Faria Rodrigo;
        João Pedro Floriano;
        Nicolas de Brito Mafra;
        Pedro Zumstein Bilac;
        Thales Campos de Azevedo;
        Thasio Santos Silva.
    
    Este trabalho visa implementar o algoritmo de criptografia AES-128.
    Tecnologia de uso militar e globalmente reconhecida como uma das principais soluções para criptografia de dados,
    a AES possui três versões: AES-128, AES-192 e AES-256.
    Em uma primeira abordagem, buscaremos a implementação apenas do algoritmo AES-128.
    Todavia, é possível que extendamos para os outros tipos de AES por meio do uso de GENERICS e uma adição no TOPLEVEL: um seletor
    para o tipo de AES. A diferença fundamental é o tamanho da chave(senha) do usuário (16, 24 ou 32 bytes).
    Se o prazo nos permitir, buscaremos implementar também o algoritmo de descriptografia.

    Até o presente momento (entrega 1), o projeto já está em desenvolvimento, e todas as entidades já estão declaradas, como é possível ver na pasta.
    - Atualização antes da entrega 1: diagramas já estão feitos, toplevel, bo e bc tambem
