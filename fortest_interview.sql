create database fortest;
/*
--面試人員資料表
create table interview(
	i_id serial primary key,
	i_name text not null,
	i_phone varchar,
	i_job_title text not null,
	i_from_time timestamp default null,
	i_end_time timestamp default null
)

insert into interview(i_name, i_phone, i_job_title)
	values('jay', '+886998877665', '企劃專員');

insert into interview(i_name, i_phone, i_job_title)
	values('henry', '+886912811945', '工程師');
*/

--新人面試性向測驗
create table aptitude_test(
	at_id serial primary key,
	at_name text not null,
	at_w1 smallint not null,
	at_w2 smallint not null,
	at_w3 smallint not null,
	at_w4 smallint not null,
	at_w5 smallint not null,
	at_x1 smallint not null,
	at_x2 smallint not null,
	at_x3 smallint not null,
	at_x4 smallint not null,
	at_x5 smallint not null,
	at_y1 smallint not null,
	at_y2 smallint not null,
	at_y3 smallint not null,
	at_y4 smallint not null,
	at_y5 smallint not null,
	at_z1 smallint not null,
	at_z2 smallint not null,
	at_z3 smallint not null,
	at_z4 smallint not null,
	at_z5 smallint not null,
	at_time timestamp default null
);

--增加備註表
create or replace view v_interview as select * from interview;
create or replace view v_aptitude_test as select * from aptitude_test;

--各欄位備註
comment on view v_aptitude_test is '性向測驗資料表備註';
comment on column v_aptitude_test.at_id is '流水號，為自動增加serial';
comment on column v_aptitude_test.at_name is '姓名，text';
comment on column v_aptitude_test.at_w1 is '堅定固執，smallint';
comment on column v_aptitude_test.at_w2 is '喜歡冒險膽子很大，smallint';
comment on column v_aptitude_test.at_w3 is '有決心的有決斷力，smallint';
comment on column v_aptitude_test.at_w4 is '有進取心有成就心，smallint';
comment on column v_aptitude_test.at_w5 is '有魅力的有威嚴的，smallint';
comment on column v_aptitude_test.at_x1 is '有說服力善表達，smallint';
comment on column v_aptitude_test.at_x2 is '團隊中活力的來源，smallint';
comment on column v_aptitude_test.at_x3 is '使人心服善於說服，smallint';
comment on column v_aptitude_test.at_x4 is '俏皮變化性情開朗，smallint';
comment on column v_aptitude_test.at_x5 is '個性樂觀有趣好玩，smallint';
comment on column v_aptitude_test.at_y1 is '溫和文雅，smallint';
comment on column v_aptitude_test.at_y2 is '自我節制個性穩健，smallint';
comment on column v_aptitude_test.at_y3 is '個性善良追求和諧，smallint';
comment on column v_aptitude_test.at_y4 is '待人親切做事誠懇，smallint';
comment on column v_aptitude_test.at_y5 is '寬大為懷仁慈友善，smallint';
comment on column v_aptitude_test.at_z1 is '做人謙虛善於容忍，smallint';
comment on column v_aptitude_test.at_z2 is '嚴格仔細詳細考究，smallint';
comment on column v_aptitude_test.at_z3 is '處事謹慎小心翼翼，smallint';
comment on column v_aptitude_test.at_z4 is '個性順從善於思考，smallint';
comment on column v_aptitude_test.at_z5 is '追求正確準備充足，smallint';
comment on column v_aptitude_test.at_time is '儲存時間，timestamp';

--新增一筆資料
--每行答案只能填一個7、一個5、一個3、一個1，此檢查可能是前端做檢查
insert into aptitude_test (at_name, 
						   at_w1, at_w2, at_w3, at_w4, at_w5,
						   at_x1, at_x2, at_x3, at_x4, at_x5,
						   at_y1, at_y2, at_y3, at_y4, at_y5,
						   at_z1, at_z2, at_z3, at_z4, at_z5,
						   at_time
						  ) values (
							  'henry', 1, 1, 3, 3, 1,
									 3, 3, 1, 1, 5,
									 7, 7, 7, 7, 7,
									 5, 5, 5, 5, 3, now()
						  );

--function
create or replace function get_aptitude_type_result(
	job_seeker_name text	
)
returns table(result_score smallint, result_type text)
language plpgsql
as $$
declare
	w_total aptitude_test.at_w1%type;
	x_total aptitude_test.at_x1%type;
	y_total aptitude_test.at_y1%type;
	z_total aptitude_test.at_z1%type;
begin
	select (at_w1 + at_w2 + at_w3 + at_w4 + at_w5) as w_total
	into w_total from aptitude_test where at_name = job_seeker_name;
	select (at_x1 + at_x2 + at_x3 + at_x4 + at_x5) as x_total
	into x_total from aptitude_test where at_name = job_seeker_name;
	select (at_y1 + at_y2 + at_y3 + at_y4 + at_y5) as y_total
	into y_total from aptitude_test where at_name = job_seeker_name;
	select (at_z1 + at_z2 + at_z3 + at_z4 + at_z5) as z_total
	into z_total from aptitude_test where at_name = job_seeker_name;
	
	if w_total > x_total and w_total > y_total and w_total > z_total
	then return query select w_total, 'w_type';
										 
	elsif x_total > w_total and x_total > y_total and x_total > z_total
	then return query select x_total, 'x_type';
		
	elsif y_total > w_total and y_total > x_total and y_total > z_total
	then return query select y_total, 'y_type';
		
	elsif z_total > w_total and z_total > y_total and z_total > x_total
	then return query select z_total, 'z_type';
	end if;
end;
$$;

select * from get_aptitude_type_result('henry');


--------------------------------------------------------------------------------------
--練習用json出，
create or replace function get_aptitude_type_result_test(
	job_seeker_name text	
)
returns table(result_array json)
language plpgsql
as $$
declare
	w_total aptitude_test.at_w1%type;
	x_total aptitude_test.at_x1%type;
	y_total aptitude_test.at_y1%type;
	z_total aptitude_test.at_z1%type;
	result_array smallint[];
begin
	select (at_w1 + at_w2 + at_w3 + at_w4 + at_w5) as w_total
	into w_total from aptitude_test where at_name = job_seeker_name;
	select (at_x1 + at_x2 + at_x3 + at_x4 + at_x5) as x_total
	into x_total from aptitude_test where at_name = job_seeker_name;
	select (at_y1 + at_y2 + at_y3 + at_y4 + at_y5) as y_total
	into y_total from aptitude_test where at_name = job_seeker_name;
	select (at_z1 + at_z2 + at_z3 + at_z4 + at_z5) as z_total
	into z_total from aptitude_test where at_name = job_seeker_name;
	
	if w_total > x_total and w_total > y_total and w_total > z_total
	then return query select array_to_json(array[w_total, 1]);
										 
	elsif x_total > w_total and x_total > y_total and x_total > z_total
	then return query select array_to_json(array[x_total, 2]);
		
	elsif y_total > w_total and y_total > x_total and y_total > z_total
	then return query select array_to_json(array[y_total, 3]);
		
	elsif z_total > w_total and z_total > y_total and z_total > x_total
	then return query select array_to_json(array[z_total, 4]);
	end if;
end;
$$;
								  
--
select * from get_aptitude_type_result_test('henry');
