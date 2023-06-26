-- MANDATORY PROJECT BY RAUSHAN KUMAR CHAURASIYA --


/* 
Q.2 We want to reward the user who has been around the longest, Find the 5 oldest users.
*/
SELECT id,username,created_at,
(SELECT DATEDIFF(NOW(),created_at)) as NoOfDays
FROM users
ORDER BY created_at asc
LIMIT 5;

/*
Q.3 To understand when to run the ad campaign, figure out the day of the week most users register on? 
*/
SELECT dayname(created_at) as RegisteredOn
,count(id) AS NoOfUsers
FROM users
GROUP BY RegisteredOn
ORDER BY COUNT(ID) DESC;

/*
Q.4 To target inactive users in an email ad campaign, find the users who have never posted a photo.
*/
SELECT u.ID,u.USERNAME 
FROM USERS u
left JOIN PHOTOS p
 ON 
u.id=p.user_id
WHERE p.id is null;


/*
Q 5.Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?
*/
WITH LIKESCOUNT AS            						 /*I have created a Common Table expression consist of photoId and No. of likes on that photo*/
(
SELECT l.photo_id,COUNT(L.PHOTO_ID) AS NoOfLikes 
FROM PHOTOS P
INNER JOIN LIKES L ON P.ID=L.PHOTO_ID
GROUP BY L.PHOTO_ID
)
							/*Then I joined that likescount table with users and photos table to get the username of user who posted that photo*/
SELECT lc.photo_id,lc.NoOfLikes
,u.username as UserName
,u.id as User_id 
FROM LIKESCOUNT lc
INNER JOIN photos p
ON 
p.ID=lc.photo_ID
INNER JOIN users u
ON
p.user_id=u.id
GROUP BY lc.photo_id
ORDER BY lc.NoOfLikes DESC
LIMIT 1;

/*
Q 6.The investors want to know how many times does the average user post.
*/

SELECT ROUND((SELECT COUNT(*) FROM PHOTOS)/(SELECT COUNT(*) FROM USERS),2) AS AVGPOST;

/*
Q 7.A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.
*/
SELECT pt.tag_id,t.tag_name
,count(pt.photo_id) as NoOfTimesUsed
FROM tags t
INNER JOIN photo_tags pt
on
pt.tag_id=t.id
GROUP BY pt.tag_id
ORDER BY NoOfTimesUsed DESC
LIMIT 5;

/*
Q8. To find out if there are bots, find users who have liked every single photo on the site.
*/

SELECT u.id as UserID
,u.username as UserName
,count(l.photo_id) as TotalLikesByUser
FROM users u
INNER JOIN likes l
ON
l.user_id=u.id
GROUP BY UserName
HAVING TotalLikesByUser = (SELECT COUNT(*) FROM photos);					

/*
Q 9.To know who the celebrities are, find users who have never commented on a photo.
*/

CREATE VIEW V_NeverCommented AS						/*I have created here a view of Users who have never commented on a photo*/
SELECT u.id,u.username
FROM users u
LEFT JOIN comments c
ON
c.user_id=u.id
WHERE c.id IS NULL;

SELECT * FROM V_NeverCommented;

/*
Q10. Now it's time to find both of them together, find the users who have never commented on any photo or have commented on every photo.
*/

CREATE VIEW V_CommEveryPic AS									/*I have created here a view which shows users who have commented on every photo*/
SELECT u.id as UserID
,u.username as UserName
,count(c.id) as TotalCommentsByUser
FROM users u
INNER JOIN comments c
ON
c.user_id=u.id
GROUP BY UserName
HAVING TotalCommentsByUser = (SELECT COUNT(*) FROM photos);

SELECT * FROM V_CommEveryPic;

/*HERE I HAVE DONE UNION BETWEEN BOTH VIEWS TO GET THE DISTINCT USERS FROM BOTH THE VIEWS.*/
SELECT id,username from V_NeverCommented		/*USERS WHO NEVER COMMENTED*/		
UNION
SELECT UserID,UserName from V_CommEveryPic;		/*USERS WHO COMMENTED ON EVERY PHOTO*/




