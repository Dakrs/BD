

DELIMITER $$
CREATE TRIGGER duracao BEFORE INSERT ON viagem
FOR EACH ROW
BEGIN
	SET new.duracao = TIMEDIFF(new.data_chegada, new.data_partida);
END $$

-- DROP TRIGGER duracao;




DELIMITER $$
CREATE TRIGGER preco_bilhete BEFORE INSERT ON bilhete
FOR EACH ROW
BEGIN
	DECLARE preco FLOAT(5, 2);
	SET preco = (SELECT preco_base FROM viagem WHERE id_viagem = new.viagem);
    -- Verifica se é Premium
	IF new.classe = 'P' 
	THEN 
		SET preco = preco * 1.5;
	END IF;
	
    -- Verifica se adquiriu uma semana antes da partida
	IF new.data_aquisicao < date_sub((SELECT data_partida FROM viagem WHERE id_viagem = new.viagem), INTERVAL 1 WEEK)
	THEN 
		SET preco = preco * 0.75;
	END IF;
	
    -- Regista preco
    SET new.preco = preco;
    
END $$

-- DROP TRIGGER preco_bilhete;