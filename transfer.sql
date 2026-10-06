\set account_from random(1, 100000)
\set account_to random(1, 100000)

-- Ovde se menja nivo izolacije
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- 1. Faza zaključavanja: Zakljucavamo ciljane redove sortirane po ID-ju.
-- Ovo sprecava  Deadlock-ove pod visokim opterecenjem.
SELECT id FROM accounts
WHERE id IN (:account_from, :account_to)
ORDER BY id
FOR UPDATE;

-- 2. Faza izmene podataka: Sada kada su oba reda bezbedno zakljucana, radimo transfer.
-- Ako se slučajno dogodi da je account_from == account_to, SQL će oduzeti i dodati 100 istom redu.
UPDATE accounts 
SET balance = balance - 100 
WHERE id = :account_from;

UPDATE accounts 
SET balance = balance + 100 
WHERE id = :account_to;

COMMIT;