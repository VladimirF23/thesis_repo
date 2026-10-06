\set account_id random(1, 100000)

-- Ovde  se menja nivo izolacije za svaki ciklus testova
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT balance 
FROM accounts 
WHERE id = :account_id;

COMMIT;