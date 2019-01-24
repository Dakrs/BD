USE ECOmboios

-- CLIENTE

DELIMITER $$
CREATE PROCEDURE historico_viagens(IN id_cliente INT, data_inicio DATETIME, data_fim DATETIME)
BEGIN
	SELECT v.data_partida AS 'Data de Partida', eo.nome AS 'Origem', v.data_chegada  AS 'Data de Chegada', ed.nome AS 'Destino'
    FROM bilhete AS b INNER JOIN viagem AS v
					  ON b.viagem = v.id_viagem
							INNER JOIN estacao AS eo
                            ON v.origem = eo.id_estacao
                            INNER JOIN estacao AS ed
                            ON v.destino = ed.id_estacao
	WHERE b.cliente = id_cliente AND v.data_partida >= data_inicio AND v.data_chegada <= data_fim
    ORDER BY v.data_partida ASC;
END $$

-- CALL historico_viagens(1, '2018-11-01', '2018-12-10');



DELIMITER $$
CREATE PROCEDURE detalhes_viagem(IN id_bilhete INT)
BEGIN
	SELECT v.data_partida AS 'Data de Partida', eo.nome AS 'Origem', v.data_chegada AS 'Data de Chegada', ed.nome AS 'Destino', v.duracao AS 'Duração', b.preco AS 'Preço', b.classe AS 'Classe', b.numero AS 'Lugar'
    FROM bilhete AS b INNER JOIN viagem AS v
					  ON b.viagem = v.id_viagem
							INNER JOIN estacao AS eo
                            ON v.origem = eo.id_estacao
                            INNER JOIN estacao AS ed
                            ON v.destino = ed.id_estacao
	WHERE b.id_bilhete = id_bilhete;
END $$

-- CALL detalhes_viagem(1);



DELIMITER $$
CREATE PROCEDURE viagens_between(IN id_estacao_o INT, id_estacao_d INT, data_inicio DATETIME, data_fim DATETIME)
BEGIN
	SELECT v.id_viagem AS 'ID', v.data_partida AS 'Data de Partida', v.data_chegada AS 'Data de Chegada', v.duracao AS 'Duração'
    FROM viagem AS v
	WHERE v.data_partida >= data_inicio AND v.data_chegada <= data_fim
		  AND v.origem = id_estacao_o AND v.destino = id_estacao_d
	ORDER BY v.data_partida ASC;
END $$

-- CALL viagens_between(1, 2, '2018-01-01 00:00:00', '2018-12-03 00:00:00'); 



DELIMITER $$
CREATE PROCEDURE lugares_livres(IN id_viagem INT)
BEGIN
	SELECT l.classe AS 'Classe', l.numero AS 'Lugar'
	FROM Viagem AS v INNER JOIN Comboio AS c
					 ON v.comboio = c.id_comboio
						INNER JOIN Lugar AS l
						ON c.id_comboio = l.comboio 
	WHERE (l.classe, l.numero) NOT IN (
		SELECT l.classe, l.numero
		FROM Viagem AS v
				INNER JOIN Bilhete as b
				ON v.id_viagem = viagem
					INNER JOIN lugar AS l
					ON (b.numero = l.numero AND b.classe = l.classe))
		  AND v.id_viagem = id_viagem;
END $$

-- CALL lugares_livres(1);


-- Devia ser v.data_partida > NOW()
DELIMITER $$
CREATE PROCEDURE horario_partida_estacao(IN id_estacao INT)
BEGIN
	SELECT v.data_partida AS 'Data de Partida', d.nome AS 'Destino'
    FROM estacao AS e INNER JOIN viagem AS v
					  ON e.id_estacao = v.origem
                      INNER JOIN Estacao AS D
                      ON v.destino = d.id_estacao
	WHERE e.id_estacao = id_estacao
		AND v.data_partida > NOW()
	ORDER BY v.data_partida ASC;
END $$

-- CALL horario_partida_estacao(1);


-- Devia ser v.data_chegada > NOW()
DELIMITER $$
CREATE PROCEDURE horario_chegada_estacao(IN id_estacao INT)
BEGIN
	SELECT v.data_chegada AS 'Data de Chegada', d.nome AS 'Origem'
    FROM estacao AS e INNER JOIN viagem AS v
					  ON e.id_estacao = v.destino
                      INNER JOIN Estacao AS D
                      ON v.destino = d.id_estacao
	WHERE e.id_estacao = id_estacao
		AND v.data_chegada > NOW()
	ORDER BY v.data_chegada ASC;
END $$

-- CALL horario_chegada_estacao(2);






-- ADMIN
DELIMITER $$
CREATE PROCEDURE adiciona_lugares(IN id_comboio INT)
BEGIN
	DECLARE i INT DEFAULT 1;
    
    WHILE (i <= 50) DO
		INSERT INTO lugar(classe, numero, comboio)
		VALUES ('P', i, id_comboio), ('E', i, id_comboio);
        SET i = i+1;
	END WHILE;
	
    WHILE (i <= 200) DO
		INSERT INTO lugar(classe, numero, comboio)
		VALUES ('E', i, id_comboio);
        SET i = i+1;
	END WHILE;
END $$


DELIMITER $$
CREATE PROCEDURE adiciona_workday(IN dia DATE)
BEGIN
	DECLARE i INT DEFAULT 7;
    WHILE (i < 24) DO
		INSERT INTO viagem(data_partida, data_chegada, preco_base, comboio, origem, destino)
		VALUES -- BRAGA -> PORTO
			   (date_add(dia, INTERVAL i HOUR), date_add(date_add(dia, INTERVAL i HOUR),  INTERVAL 20 MINUTE), 10.00, 1, 1, 2),
			   (date_add(dia, INTERVAL i+1 HOUR), date_Add(date_add(dia, INTERVAL i+1 HOUR),  INTERVAL 20 MINUTE), 10.00, 2, 1, 2),
               -- PORTO -> BRAGA
               (date_add(date_add(dia, INTERVAL i HOUR), INTERVAL 10 MINUTE), date_Add(date_add(dia, INTERVAL i HOUR),  INTERVAL 30 MINUTE), 10.00, 2, 2, 1),
			   (date_add(date_add(dia, INTERVAL i+1 HOUR), INTERVAL 10 MINUTE), date_Add(date_add(dia, INTERVAL i+1 HOUR),  INTERVAL 30 MINUTE), 10.00, 1, 2, 1);
		SET i = i + 2;
    END WHILE;
    
    SET i = 7;
    WHILE (i < 24) DO
		INSERT INTO viagem(data_partida, data_chegada, preco_base, comboio, origem, destino)
		VALUES -- PORTO -> LISBOA
			   (date_add(dia, INTERVAL i HOUR), date_add(date_add(dia, INTERVAL i+1 HOUR),  INTERVAL 25 MINUTE), 25.00, 3, 2, 3),
			   (date_add(dia, INTERVAL i+2 HOUR), date_Add(date_add(dia, INTERVAL i+3 HOUR),  INTERVAL 25 MINUTE), 25.00, 4, 2, 3),
               -- LISBOA -> PORTO
               (date_add(date_add(dia, INTERVAL i HOUR), INTERVAL 10 MINUTE), date_Add(date_add(dia, INTERVAL i+1 HOUR),  INTERVAL 55 MINUTE), 25.00, 4, 3, 2),
			   (date_add(date_add(dia, INTERVAL i+2 HOUR), INTERVAL 10 MINUTE), date_Add(date_add(dia, INTERVAL i+3 HOUR),  INTERVAL 55 MINUTE), 25.00, 3, 3, 2);
		SET i = i + 4;
    END WHILE;
    
    SET i = 8;
    WHILE (i < 24) DO
		INSERT INTO viagem(data_partida, data_chegada, preco_base, comboio, origem, destino)
		VALUES -- BRAGA -> LISBOA
			   (date_add(dia, INTERVAL i HOUR), date_add(date_add(dia, INTERVAL i+1 HOUR),  INTERVAL 45 MINUTE), 35.00, 5, 1, 3),
			   (date_add(dia, INTERVAL i+2 HOUR), date_Add(date_add(dia, INTERVAL i+3 HOUR),  INTERVAL 45 MINUTE), 35.00, 6, 1, 3),
               -- LISBOA -> BRAGA
               (date_add(date_add(dia, INTERVAL i HOUR), INTERVAL 10 MINUTE), date_Add(date_add(dia, INTERVAL i+1 HOUR),  INTERVAL 55 MINUTE), 35.00, 6, 3, 1),
			   (date_add(date_add(dia, INTERVAL i+2 HOUR), INTERVAL 10 MINUTE), date_Add(date_add(dia, INTERVAL i+3 HOUR),  INTERVAL 55 MINUTE), 35.00, 5, 3, 1);
		SET i = i + 4;
    END WHILE;
END $$



DELIMITER $$
CREATE PROCEDURE adiciona_bilhete(IN id_cliente INT, classe CHAR(1), numero INT, id_viagem INT)
BEGIN
	DECLARE r INT;
    SET AUTOCOMMIT = OFF;
    
	START TRANSACTION READ WRITE;
		SET r = lugar_livre(classe, numero, id_viagem);
        IF (r = 1)
        THEN
			INSERT INTO bilhete(data_aquisicao, classe, numero, cliente, viagem)
			VALUES (now(), classe, numero, id_cliente, id_viagem);
		END IF;
    COMMIT;
END $$



DELIMITER $$
CREATE PROCEDURE viagens_comboio_between(IN id_comboio INT, data_inicio DATETIME, data_fim DATETIME)
BEGIN
	SELECT eo.nome AS 'Origem', v.data_partida AS 'Data de Partida', ed.nome AS 'Destino', v.data_chegada AS 'Data de Chegada'
    FROM viagem AS v INNER JOIN comboio AS c
					 ON v.comboio = c.id_comboio
                     INNER JOIN estacao AS eo
                     ON v.origem = eo.id_estacao
                     INNER JOIN estacao AS ed
                     ON v.destino = ed.id_estacao
	WHERE (v.data_partida >= data_inicio AND v.data_chegada <= data_fim AND c.id_comboio = id_comboio)
    ORDER BY v.data_partida ASC;
    
END $$

-- CALL viagens_comboio_between(1, '2018-01-01 00:00:00', '2018-12-01 00:00:00');



DELIMITER $$
CREATE PROCEDURE clientes_between_estacoes(IN id_estacao_o INT, id_estacao_d INT, data_inicio DATETIME, data_fim DATETIME)
BEGIN
	SELECT c.id_cliente, c.nome, count(c.id_cliente) AS 'Número de bilhetes'
    FROM cliente AS c INNER JOIN bilhete AS b
					  ON c.id_cliente = b.cliente
						INNER JOIN viagem AS v
                        ON b.viagem = v.id_viagem
	WHERE v.data_partida >= data_inicio AND v.data_chegada <= data_fim
		  AND v.origem = id_estacao_o AND v.destino = id_estacao_d
	GROUP BY c.id_cliente;
END $$

-- CALL clientes_between_estacoes(1, 2, '2018-11-30 00:00:00', '2018-12-02 00:00:00');


DELIMITER $$
CREATE PROCEDURE clientes_na_viagem(IN id_viagem INT)
BEGIN
	SELECT c.nome AS Nome, c.id_cliente AS ID
		FROM Bilhete b, Cliente c
        WHERE b.viagem = id_viagem
			AND b.cliente = c.id_cliente;
END $$

-- CALL clientes_na_viagem(1);


DELIMITER $$
CREATE PROCEDURE adiciona_cliente(IN nome VARCHAR(50), email VARCHAR(30), nif INT, password VARCHAR(18))
BEGIN
	INSERT INTO cliente(nome, email, nif, password)
    VALUES (nome, email, nif, password);
END $$
