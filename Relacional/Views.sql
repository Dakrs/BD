
CREATE VIEW proxima_viagens AS 
SELECT o.nome as 'Origem', v.data_partida as 'Data Partida', d.nome as 'Destino', v.data_chegada as 'Data Chegada' 
FROM viagem as v INNER JOIN estacao as o
				 ON v.origem = o.id_estacao
				 INNER JOIN Estacao as d
				 ON v.destino = d.id_estacao
WHERE v.data_partida >= now()
ORDER BY v.data_partida ASC;


CREATE VIEW numero_passagueiro_naviagem AS
SELECT v.id_viagem AS 'ID Viagem', count(v.id_viagem) AS 'Número de Bilhetes Vendidos', v.data_partida AS 'Data de Partida'
		FROM Viagem v , Bilhete b 
        WHERE v.id_viagem = b.viagem
        GROUP BY v.id_viagem
        ORDER BY v.data_partida;

CREATE VIEW numero_passagueiros_estacoes AS
SELECT O.nome AS Origem , D.nome AS Destino, COUNT(b.id_bilhete) AS 'Número de Passageiros'
FROM Bilhete AS B RIGHT JOIN Viagem AS V
					ON B.viagem = V.id_viagem
                    INNER JOIN Estacao AS O
                    ON V.origem = O.id_estacao
                    INNER JOIN Estacao AS D
                    ON V.destino = D.id_estacao
GROUP BY O.id_estacao , D.id_estacao
ORDER BY O.nome ASC;


CREATE VIEW estacoes_existentes AS
SELECT nome
FROM estacao;

-- SELECT * FROM estacoes_existentes;
