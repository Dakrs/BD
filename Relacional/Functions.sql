
DELIMITER $$
CREATE FUNCTION total_gasto(id_cliente INT, data_inicio DATETIME, data_fim DATETIME)
	   RETURNS FLOAT DETERMINISTIC
BEGIN
	RETURN (SELECT sum(b.preco)
			FROM bilhete as b 
			WHERE b.cliente = id_cliente AND b.data_aquisicao >= data_inicio AND b.data_aquisicao <= data_fim);

END $$

-- SELECT total_gasto(1, '2018-11-01', '2018-12-31');


DELIMITER $$
CREATE FUNCTION total_bilhetes_vendidos(d_inicio DATETIME, d_fim DATETIME)
	   RETURNS FLOAT DETERMINISTIC
BEGIN
	RETURN (SELECT count(b.id_bilhete)
			FROM bilhete as b
			WHERE b.data_aquisicao >= d_inicio
				  AND b.data_aquisicao <= d_fim);
END $$


DELIMITER $$
CREATE FUNCTION total_faturado(d_inicio DATETIME, d_fim DATETIME)
	   RETURNS FLOAT DETERMINISTIC
BEGIN
	RETURN (SELECT sum(b.preco)
			FROM bilhete as b
			WHERE b.data_aquisicao >= d_inicio
				  AND b.data_aquisicao <= d_fim);
END $$


DELIMITER $$ 
CREATE FUNCTION lugar_livre(classe CHAR(1), numero SMALLINT, id_viagem INT)
				RETURNS BOOLEAN DETERMINISTIC
BEGIN
	IF (SELECT b.id_bilhete 
			FROM bilhete AS b
            WHERE b.viagem = id_viagem AND b.classe = classe AND b.numero = numero) > 0
	THEN RETURN 0;
    ELSE RETURN 1;
    END IF;
END $$
-- DROP FUNCTION lugar_livre;


