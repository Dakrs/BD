USE ecomboios;

-- -----------------------------------------------------
-- Tabela CLIENTE
-- -----------------------------------------------------
INSERT INTO cliente(nome, email, nif, password)
VALUES ('Alberto Caeiro', 'albertinho1@gmail.com', 111111111, 'heteronimo'),
	   ('Ricardo Reis', 'reidistotudo@hotmail.com', 222222222, 'souMedico'),
	   ('Álvaro de Campos', 'alvarinho@tinto.com', 333333333, 'EngenheiroSouEu'),
       ('Fernando Pessoa', 'fp@portugalmail.com', 102348201, 'oOriginal'),
       ('Pedro Moreira', 'pedrom@gmail.com', 238881920, 'qwerty123'),
       ('Pedro Ferreira', 'ferreirinha@gmail.com', 231772893, 'asdfg456'),
       ('Diogo Sobral', 'diogosobral@hotmail.com', 182992102, 'zxcvb789'),
       ('Henrique Pereira', 'palmeira@gmail.com', 231983210, 'qazwsx123');
        
-- SELECT * FROM cliente;
                  
                  
                  
-- -----------------------------------------------------
-- Tabela ESTACAO
-- -----------------------------------------------------
INSERT INTO estacao(nome)
VALUES ('Braga'), ('Porto'), ('Lisboa');

-- SELECT * FROM estacao;



-- -----------------------------------------------------
-- Tabela COMBOIO
-- -----------------------------------------------------
INSERT INTO comboio
VALUES (), (), (), (), (), ();

-- SELECT * FROM comboio;


-- -----------------------------------------------------
-- Tabela LUGAR
-- -----------------------------------------------------
CALL adiciona_lugares(1);
CALL adiciona_lugares(2);
CALL adiciona_lugares(3);
CALL adiciona_lugares(4);
CALL adiciona_lugares(5);
CALL adiciona_lugares(6);

-- SELECT * FROM lugar;



-- -----------------------------------------------------
-- Tabela VIAGEM
-- -----------------------------------------------------
CALL adiciona_workday('2018-12-01');

-- SELECT * FROM viagem;

/*
SELECT v.id_viagem, v.data_partida, v.data_chegada, v.duracao, eo.nome AS origem, ed.nome AS destino
FROM viagem AS v INNER JOIN estacao AS eo
				 ON v.origem = eo.id_estacao
                 INNER JOIN estacao AS ed
                 ON v.destino = ed.id_estacao; */
                 
                 
                 
-- -----------------------------------------------------
-- Tabela BILHETE
-- -----------------------------------------------------
INSERT INTO bilhete(data_aquisicao, classe, numero, cliente, viagem)
VALUES ('2018-11-15 10:02:34', 'P', 1, 1, 1),
		('2018-11-15 10:02:34', 'P', 20, 1, 28),
		('2018-11-16 21:10:54', 'E', 3, 2, 1),
		('2018-11-19 13:20:34', 'E', 20, 3, 1),
		('2018-11-21 15:43:21', 'E', 79, 4, 1),
		('2018-11-21 20:20:34', 'P', 19, 5, 1),
		('2018-11-25 23:56:12', 'E', 31, 6, 1),
		('2018-11-26 14:20:37', 'P', 22, 7, 3),
		('2018-11-26 15:24:14', 'P', 1, 8, 3);
       
-- SELECT * FROM bilhete;


/*
SELECT c.nome, eo.nome AS origem, ed.nome AS destino, v.duracao, b.preco, b.classe, b.numero, b.id_bilhete
FROM cliente AS c INNER JOIN bilhete AS b
				  ON c.id_cliente = b.cliente
					INNER JOIN viagem AS v
                    ON b.viagem = v.id_viagem
						INNER JOIN estacao AS eo
                        ON v.origem = eo.id_estacao
                        INNER JOIN estacao AS ed
                        ON v.destino = ed.id_estacao; */
				
				