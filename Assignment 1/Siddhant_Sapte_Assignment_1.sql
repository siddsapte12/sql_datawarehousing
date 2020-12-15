use recipes;

--  Q1
select * from categories;
insert into categories (category_id,category_name) values ('3', 'Veg'),('4','Non-Veg');

select * from ingredients order by ingredient_id;
insert into ingredients (ingredient_id,ingred_name) values ('20', 'onions, cottage chesse'),('21','chicken'),('22','oil'),('23','olive oil');

select * from rec_ingredients;
insert into rec_ingredients (rec_ingredient_id,recipe_id,amount,ingredient_id) 
values ('17', '3','0.33','20'),('18','4','0.33','21'),('19','3','0.12','22'),('20','4','0.22','23');

select * from recipe_main;
insert into recipe_main (recipe_id,rec_title,category_id,recipe_desc,prep_time,cook_time,servings,difficulty,directions) 
values ('3', 'Panner Burji','3','cottage chesse,onions','20','30','4','2','Cook cottage chesse with onions, tomatoes, garam masala, red masala and fried onions and garnish with fried onions and corriander'),
('4', 'Chicken Korma','4','chicken,onions','20','30','4','2','Cook chicken with onions, tomatoes, garam masala, red masala and fried onions and garnish with fried onions and corriander');

-- Q2
select c.category_id, c.category_name,i.ingredient_id,i.ingred_name, r.rec_ingredient_id, r.recipe_id, r.amount, 
r.ingredient_id, m.rec_title,m.recipe_desc,m.prep_time,m.cook_time,m.servings,m.difficulty,m.directions from 
(((recipe_main as m
join categories as c on c.category_id = m.category_id)
join rec_ingredients as r on r.recipe_id = m.recipe_id)
join ingredients as i on i.ingredient_id = r.ingredient_id)
where c.category_id = '3' or c.category_id = '4';

-- Q3
select m.rec_title, c.category_name,i.ingred_name, r.amount from
(((recipe_main as m 
join categories as c on c.category_id = m.category_id)
join rec_ingredients as r on r.recipe_id = m.recipe_id)
join ingredients as i on i.ingredient_id = r.ingredient_id)
where c.category_id = '3' or c.category_id = '4'
order by c.category_name desc,i.ingred_name desc;


