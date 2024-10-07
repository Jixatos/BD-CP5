SET SERVEROUTPUT ON;

/* 2TDSPF
RM551408 - Juan de Godoy
RM550548 - Gustavo de Oliveira Azevedo
*/

-- DROP's das tabelas
DROP TABLE pagamento CASCADE CONSTRAINTS;
DROP TABLE manutencao CASCADE CONSTRAINTS;
DROP TABLE reserva CASCADE CONSTRAINTS;
DROP TABLE quarto CASCADE CONSTRAINTS;
DROP TABLE colaborador CASCADE CONSTRAINTS;
DROP TABLE cliente CASCADE CONSTRAINTS;
DROP TABLE categoria CASCADE CONSTRAINTS;

-- CREATE's das tabelas
CREATE TABLE categoria (
    id_categoria INTEGER NOT NULL,
    nome         VARCHAR2(255) NOT NULL
);

ALTER TABLE categoria ADD CONSTRAINT categoria_pk PRIMARY KEY ( id_categoria );

CREATE TABLE cliente (
    cpf      VARCHAR2(100) NOT NULL,
    nome     VARCHAR2(255) NOT NULL,
    telefone VARCHAR2(100) NOT NULL
);

ALTER TABLE cliente ADD CONSTRAINT cliente_pk PRIMARY KEY ( cpf );

CREATE TABLE colaborador (
    id_colaborador INTEGER NOT NULL,
    nome           VARCHAR2(255) NOT NULL,
    cpf            VARCHAR2(100) NOT NULL,
    cargo          VARCHAR2(255) NOT NULL
);

ALTER TABLE colaborador ADD CONSTRAINT colaborador_pk PRIMARY KEY ( id_colaborador );

CREATE TABLE manutencao (
    id_manutencao  INTEGER NOT NULL,
    dt_manutencao  DATE NOT NULL,
    descricao      VARCHAR2(255) NOT NULL,
    id_colaborador INTEGER,
    quarto_numero  INTEGER NOT NULL
);

ALTER TABLE manutencao ADD CONSTRAINT manutencao_pk PRIMARY KEY ( id_manutencao );

CREATE TABLE pagamento (
    id_pagamento   INTEGER NOT NULL,
    dt_pagamento   DATE NOT NULL,
    tipo_pagamento VARCHAR2(100),
    valor          NUMBER(8,2) NOT NULL,
    id_reserva     INTEGER NOT NULL
);

ALTER TABLE pagamento ADD CONSTRAINT pagamento_pk PRIMARY KEY ( id_pagamento );

CREATE TABLE quarto (
    numero       INTEGER NOT NULL,
    status       VARCHAR2(100) NOT NULL,
    id_categoria INTEGER NOT NULL
);

ALTER TABLE quarto ADD CONSTRAINT quarto_pk PRIMARY KEY ( numero );

CREATE TABLE reserva (
    id_reserva    INTEGER NOT NULL,
    dt_reserva    DATE NOT NULL,
    dt_inicio     DATE NOT NULL,
    dt_fim        DATE,
    valor         NUMBER(8, 2) NOT NULL,
    status        VARCHAR2(100) NOT NULL,
    quarto_numero INTEGER NOT NULL,
    cliente_cpf   VARCHAR2(100) NOT NULL
);

ALTER TABLE reserva ADD CONSTRAINT reserva_pk PRIMARY KEY ( id_reserva );

ALTER TABLE manutencao
    ADD CONSTRAINT manutencao_colaborador_fk FOREIGN KEY ( id_colaborador )
        REFERENCES colaborador ( id_colaborador );

ALTER TABLE manutencao
    ADD CONSTRAINT manutencao_quarto_fk FOREIGN KEY ( quarto_numero )
        REFERENCES quarto ( numero );

ALTER TABLE pagamento
    ADD CONSTRAINT pagamento_reserva_fk FOREIGN KEY ( id_reserva )
        REFERENCES reserva ( id_reserva );

ALTER TABLE quarto
    ADD CONSTRAINT quarto_categoria_fk FOREIGN KEY ( id_categoria )
        REFERENCES categoria ( id_categoria );

ALTER TABLE reserva
    ADD CONSTRAINT reserva_cliente_fk FOREIGN KEY ( cliente_cpf )
        REFERENCES cliente ( cpf );

ALTER TABLE reserva
    ADD CONSTRAINT reserva_quarto_fk FOREIGN KEY ( quarto_numero )
        REFERENCES quarto ( numero );

-- INSERT's das tabelas
BEGIN
    INSERT INTO categoria (id_categoria, nome) VALUES (1, 'Luxo');
    INSERT INTO categoria (id_categoria, nome) VALUES (2, 'Econômico');
    INSERT INTO categoria (id_categoria, nome) VALUES (3, 'Executivo');
    INSERT INTO categoria (id_categoria, nome) VALUES (4, 'Presidencial');
    INSERT INTO categoria (id_categoria, nome) VALUES (5, 'Standard');
END;
/

BEGIN
    INSERT INTO cliente (cpf, nome, telefone) VALUES ('12345678900', 'João Silva', '11987654321');
    INSERT INTO cliente (cpf, nome, telefone) VALUES ('98765432100', 'Maria Oliveira', '11987651234');
    INSERT INTO cliente (cpf, nome, telefone) VALUES ('12312312300', 'Pedro Santos', '11999998888');
    INSERT INTO cliente (cpf, nome, telefone) VALUES ('32132132100', 'Ana Pereira', '11988887777');
    INSERT INTO cliente (cpf, nome, telefone) VALUES ('11122233300', 'Carlos Souza', '11977776666');
END;
/

BEGIN   
    INSERT INTO colaborador (id_colaborador, nome, cpf, cargo) VALUES (1, 'Lucas Almeida', '98798798700', 'Gerente de Manutenção');
    INSERT INTO colaborador (id_colaborador, nome, cpf, cargo) VALUES (2, 'Fernanda Costa', '65465465400', 'Recepcionista');
    INSERT INTO colaborador (id_colaborador, nome, cpf, cargo) VALUES (3, 'Roberto Nunes', '32132165400', 'Supervisor de Limpeza');
    INSERT INTO colaborador (id_colaborador, nome, cpf, cargo) VALUES (4, 'Juliana Santos', '45645678900', 'Atendente');
    INSERT INTO colaborador (id_colaborador, nome, cpf, cargo) VALUES (5, 'Paulo Rodrigues', '78978912300', 'Segurança');
END;
/

BEGIN
    INSERT INTO quarto (numero, status, id_categoria) VALUES (101, 'Disponível', 1);
    INSERT INTO quarto (numero, status, id_categoria) VALUES (102, 'Ocupado', 2);
    INSERT INTO quarto (numero, status, id_categoria) VALUES (103, 'Disponível', 3);
    INSERT INTO quarto (numero, status, id_categoria) VALUES (104, 'Manutenção', 4);
    INSERT INTO quarto (numero, status, id_categoria) VALUES (105, 'Ocupado', 5);
END;
/

BEGIN
    INSERT INTO manutencao (id_manutencao, dt_manutencao, descricao, id_colaborador, quarto_numero) 
    VALUES (1, TO_DATE('2023-10-01', 'YYYY-MM-DD'), 'Reparo no ar-condicionado', 1, 101);
    INSERT INTO manutencao (id_manutencao, dt_manutencao, descricao, id_colaborador, quarto_numero) 
    VALUES (2, TO_DATE('2023-10-02', 'YYYY-MM-DD'), 'Pintura de paredes', 3, 104);
    INSERT INTO manutencao (id_manutencao, dt_manutencao, descricao, id_colaborador, quarto_numero) 
    VALUES (3, TO_DATE('2023-10-03', 'YYYY-MM-DD'), 'Troca de lâmpadas', 1, 105);
    INSERT INTO manutencao (id_manutencao, dt_manutencao, descricao, id_colaborador, quarto_numero) 
    VALUES (4, TO_DATE('2023-10-04', 'YYYY-MM-DD'), 'Limpeza profunda', 3, 102);
    INSERT INTO manutencao (id_manutencao, dt_manutencao, descricao, id_colaborador, quarto_numero) 
    VALUES (5, TO_DATE('2023-10-05', 'YYYY-MM-DD'), 'Reparo de porta', 1, 103);
END;
/

BEGIN
    INSERT INTO reserva (id_reserva, dt_reserva, dt_inicio, dt_fim, valor, status, quarto_numero, cliente_cpf)
    VALUES (1, TO_DATE('2023-09-20', 'YYYY-MM-DD'), TO_DATE('2023-09-22', 'YYYY-MM-DD'), TO_DATE('2023-09-25', 'YYYY-MM-DD'), 1200.00, 'Confirmada', 101, '12345678900');
    INSERT INTO reserva (id_reserva, dt_reserva, dt_inicio, dt_fim, valor, status, quarto_numero, cliente_cpf)
    VALUES (2, TO_DATE('2023-09-21', 'YYYY-MM-DD'), TO_DATE('2023-09-23', 'YYYY-MM-DD'), TO_DATE('2023-09-26', 'YYYY-MM-DD'), 850.00, 'Confirmada', 102, '98765432100');
    INSERT INTO reserva (id_reserva, dt_reserva, dt_inicio, dt_fim, valor, status, quarto_numero, cliente_cpf)
    VALUES (3, TO_DATE('2023-09-22', 'YYYY-MM-DD'), TO_DATE('2023-09-24', 'YYYY-MM-DD'), TO_DATE('2023-09-27', 'YYYY-MM-DD'), 1000.00, 'Cancelada', 103, '12312312300');
    INSERT INTO reserva (id_reserva, dt_reserva, dt_inicio, dt_fim, valor, status, quarto_numero, cliente_cpf)
    VALUES (4, TO_DATE('2023-09-23', 'YYYY-MM-DD'), TO_DATE('2023-09-25', 'YYYY-MM-DD'), NULL, 950.00, 'Confirmada', 104, '32132132100');
    INSERT INTO reserva (id_reserva, dt_reserva, dt_inicio, dt_fim, valor, status, quarto_numero, cliente_cpf)
    VALUES (5, TO_DATE('2023-09-24', 'YYYY-MM-DD'), TO_DATE('2023-09-26', 'YYYY-MM-DD'), TO_DATE('2023-09-29', 'YYYY-MM-DD'), 1300.00, 'Em andamento', 105, '11122233300');
END;
/

BEGIN
    INSERT INTO pagamento (id_pagamento, dt_pagamento, tipo_pagamento, valor, id_reserva)
    VALUES (1, TO_DATE('2023-09-20', 'YYYY-MM-DD'), 'Cartão de Crédito', 1200.00, 1);
    INSERT INTO pagamento (id_pagamento, dt_pagamento, tipo_pagamento, valor, id_reserva)
    VALUES (2, TO_DATE('2023-09-21', 'YYYY-MM-DD'), 'Cartão de Débito', 850.00, 2);
    INSERT INTO pagamento (id_pagamento, dt_pagamento, tipo_pagamento, valor, id_reserva)
    VALUES (3, TO_DATE('2023-09-22', 'YYYY-MM-DD'), 'Boleto', 1000.00, 3);
    INSERT INTO pagamento (id_pagamento, dt_pagamento, tipo_pagamento, valor, id_reserva)
    VALUES (4, TO_DATE('2023-09-23', 'YYYY-MM-DD'), 'Pix', 950.00, 4);
    INSERT INTO pagamento (id_pagamento, dt_pagamento, tipo_pagamento, valor, id_reserva)
    VALUES (5, TO_DATE('2023-09-24', 'YYYY-MM-DD'), 'Cartão de Crédito', 1300.00, 5);
END;
/

-- Trigger
CREATE OR REPLACE TRIGGER manutencao_quartos AFTER
    INSERT ON manutencao
    FOR EACH ROW
BEGIN
    UPDATE quarto
    SET quarto.status = 'EM MANUTENÇÃO'
    WHERE quarto.numero = :NEW.quarto_numero;
END;
/

-- Function
CREATE OR REPLACE FUNCTION aplicar_desconto(p_id NUMBER, p_desconto NUMBER)
RETURN NUMBER
IS 
    v_valor_descontado NUMBER := 0;
BEGIN
   SELECT valor INTO v_valor_descontado FROM reserva WHERE id_reserva = p_id;
   v_valor_descontado := v_valor_descontado * (1 - (p_desconto/100));
    RETURN v_valor_descontado;
END;
/

-- Procedure
CREATE OR REPLACE PROCEDURE gerar_relatorio_ocupacao AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Relatório de Ocupação de Quartos');
    DBMS_OUTPUT.PUT_LINE('----------------------------------');

    FOR rec IN (
        SELECT r.id_reserva,
               c.nome AS nome_cliente,
               q.numero AS numero_quarto,
               TO_CHAR(r.dt_inicio, 'DD/MM/YYYY') AS data_inicio,
               TO_CHAR(r.dt_fim, 'DD/MM/YYYY') AS data_fim,
               r.status
        FROM reserva r
        JOIN cliente c ON r.cliente_cpf = c.cpf
        JOIN quarto q ON r.quarto_numero = q.numero
        WHERE r.status IN ('Confirmada', 'Em andamento')
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.id_reserva || ' | ' || 
                             rec.nome_cliente || ' | ' || 
                             rec.numero_quarto || ' | ' || 
                             rec.data_inicio || ' | ' || 
                             rec.data_fim || ' | ' || 
                             rec.status);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('----------------------------------');
    DBMS_OUTPUT.PUT_LINE('Relatório gerado com sucesso!');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
END gerar_relatorio_ocupacao;
/

-- Teste TRIGGER
BEGIN
    INSERT INTO manutencao (id_manutencao, dt_manutencao, descricao, id_colaborador, quarto_numero) 
    VALUES (6, TO_DATE('2023-10-06', 'YYYY-MM-DD'), 'Limpeza', 2, 101);
END;
/

SELECT * FROM quarto WHERE numero = 101;

-- Teste FUNCTION 
DECLARE
    v_valor NUMBER;
BEGIN
    v_valor := aplicar_desconto(1, 10);
    DBMS_OUTPUT.PUT_LINE('Valor final descontado: ' || v_valor);
END;
/

-- Teste PROCEDURE
BEGIN
    gerar_relatorio_ocupacao;
END;
/
