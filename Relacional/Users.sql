
-- SELECT * FROM mysql.user;
-- DESC mysql.user;


-- ADMIN
-- DROP USER 'admin'@'localhost';
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON ecomboios.* TO 'admin'@'localhost';


-- GESTOR
-- DROP USER 'gestor'@'localhost';
CREATE USER 'gestor'@'localhost' IDENTIFIED BY 'gestor';
GRANT SELECT (id_cliente, nome, email, nif) ON ecomboios.cliente TO 'gestor'@'localhost';
GRANT SELECT ON ecomboios.bilhete TO 'gestor'@'localhost';
GRANT SELECT, INSERT, UPDATE ON ecomboios.viagem TO 'gestor'@'localhost';
GRANT SELECT, INSERT, UPDATE ON ecomboios.estacao TO 'gestor'@'localhost';
GRANT SELECT, INSERT, UPDATE ON ecomboios.comboio TO 'gestor'@'localhost';
GRANT SELECT, INSERT, UPDATE ON ecomboios.lugar TO 'gestor'@'localhost';


-- UTILIZADOR
-- DROP USER 'utilizador'@'localhost';
CREATE USER 'utilizador'@'localhost' IDENTIFIED BY 'utilizador';
GRANT INSERT, UPDATE ON ecomboios.cliente TO 'utilizador'@'localhost';
GRANT SELECT, INSERT ON ecomboios.bilhete TO 'utilizador'@'localhost';
GRANT SELECT ON ecomboios.viagem TO 'utilizador'@'localhost';
GRANT SELECT ON ecomboios.estacao TO 'utilizador'@'localhost';
GRANT SELECT ON ecomboios.lugar TO 'utilizador'@'localhost';



FLUSH PRIVILEGES;