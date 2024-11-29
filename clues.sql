-- Clue #1: We recently got word that someone fitting Carmen Sandiego's description has been traveling through Southern Europe. She's most likely traveling someplace where she won't be noticed, so find the least populated country in Southern Europe, and we'll start looking for her there.
 
-- Write SQL query here
--Find base on value from a field--
SELECT name, population
FROM countries
WHERE region = 'Southern Europe'
ORDER BY population ASC
LIMIT 1;

-- Clue #2: Now that we're here, we have insight that Carmen was seen attending language classes in this country's officially recognized language. Check our databases and find out what language is spoken in this country, so we can call in a translator to work with you.

-- Write SQL query here
--Find lenguage value of a country using a INNER JOIN--
SELECT language
FROM countrylanguages
JOIN countries ON code = countrycode
WHERE name = 'Holy See (Vatican City State)' AND isofficial = TRUE;

-- An inner join is a type of SQL join that combines rows from two or more tables based on a condition. It only includes rows where the condition matches in both tables.
-- If a row in one table doesn’t have a corresponding match in the other table, it is excluded from the result.

--Find lenguage value without using any join--
SELECT language
FROM countrylanguages
WHERE countrycode = (
    SELECT code
    FROM countries
    WHERE name = 'Portugal'
) AND isofficial = TRUE;



-- Clue #3: We have new news on the classes Carmen attended – our gumshoes tell us she's moved on to a different country, a country where people speak only the language she was learning. Find out which nearby country speaks nothing but that language.

-- Write SQL query here
-- Find countries whom speak a lenguage using INNER JOIN
SELECT countries.name
FROM countries
JOIN countrylanguages ON countries.code = countrylanguages.countrycode
WHERE countries.region = 'Southern Europe'
AND countrylanguages.language = 'Italian'
AND countrylanguages.isofficial = TRUE;

--Find countries whom speak a lenguage without using any join--
SELECT countries.name
FROM countries, countrylanguages
WHERE countries.code = countrylanguages.countrycode
  AND countries.region = 'Southern Europe'
  AND countrylanguages.language = 'Italian'
  AND countrylanguages.isofficial = TRUE;



-- Clue #4: We're booking the first flight out – maybe we've actually got a chance to catch her this time. There are only two cities she could be flying to in the country. One is named the same as the country – that would be too obvious. We're following our gut on this one; find out what other city in that country she might be flying to.

-- Write SQL query here
SELECT countries.name
FROM countries
JOIN countrylanguages ON countries.code = countrylanguages.countrycode
JOIN cities ON countries.code = cities.countrycode
WHERE countries.region = 'Southern Europe'
  AND countrylanguages.language = 'Italian'
  AND countrylanguages.isofficial = TRUE
GROUP BY countries.name
HAVING COUNT(cities.id) = 2 
   AND SUM(CASE WHEN cities.name = countries.name THEN 1 ELSE 0 END) > 0;

-- Clue #5: Oh no, she pulled a switch – there are two cities with very similar names, but in totally different parts of the globe! She's headed to South America as we speak; go find a city whose name is like the one we were headed to, but doesn't end the same. Find out the city, and do another search for what country it's in. Hurry!

-- Write SQL query here
SELECT name, countrycode
FROM cities
WHERE name LIKE 'San M%'
  AND name NOT LIKE '%Marino'
  AND countrycode IN (
    SELECT code
    FROM countries
    WHERE continent = 'South America'
  );

-- Clue #6: We're close! Our South American agent says she just got a taxi at the airport, and is headed towards
-- the capital! Look up the country's capital, and get there pronto! Send us the name of where you're headed and we'll
-- follow right behind you!

-- Write SQL query here
SELECT cities.name
FROM countries
JOIN cities ON countries.capital = cities.id
WHERE countries.code = 'ARG';

-- Clue #7: She knows we're on to her – her taxi dropped her off at the international airport, and she beat us to the boarding gates. We have one chance to catch her, we just have to know where she's heading and beat her to the landing dock. Lucky for us, she's getting cocky. She left us a note (below), and I'm sure she thinks she's very clever, but if we can crack it, we can finally put her where she belongs – behind bars.


--               Our playdate of late has been unusually fun –
--               As an agent, I'll say, you've been a joy to outrun.
--               And while the food here is great, and the people – so nice!
--               I need a little more sunshine with my slice of life.
--               So I'm off to add one to the population I find
--               In a city of ninety-one thousand and now, eighty five.


-- We're counting on you, gumshoe. Find out where she's headed, send us the info, and we'll be sure to meet her at the gates with bells on.
SELECT name, countrycode
FROM cities
WHERE population = 91000;

-- This select 2 cities Najran in SAU & Krasnogorsk in RUS, I guess is the Sudis cause she mentions she needs more sunshine :)