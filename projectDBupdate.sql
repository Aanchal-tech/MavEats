-- Place a new order from restaurant 1000000001 -- Query 7 
INSERT INTO Spring25_S003_T7_ORDERS 
VALUES(500000007, 35.5, 1002160021, 1000000001, 9000000001, TO_DATE('2025-01-14', 'YYYY-MM-DD'), '08:00:00', '08:35:00'); 

-- Update, dowgrade a rating of delivery agent(Sarah Williams) 9000000026 to 1 - Query 2
UPDATE Spring25_S003_T7_RATES 
SET RATING = 1
WHERE DELIVERY_AGENT_ID = 9000000021 ; 

-- Delete a call from 9am - 10am slot for agent 1000000002 -- Query 8
DELETE FROM Spring25_S003_T7_CALLS WHERE AGENT_ID = 1000000002; 

