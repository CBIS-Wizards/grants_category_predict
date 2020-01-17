/* Data for KMeans */
Select g.GID,
	g.Opportunity_Title as 'Grant Title',
	g.Description, 

	g.ProgramPurpose as 'Program Purpose', 
	g.Information_on_Eligibility,
	(SELECT STUFF((ISNULL((SELECT ISNULL(', ' + ea.Eligible_Applicants,'') 
		from link_Grants_EligibleApplicant ea
		where ea.gid = g.gid --this line is how you are "linking" the STUFF with tables from main query
		FOR XML PATH('')),'')),1,2,'')) as 'Eligibility Code(s)',
	(SELECT STUFF((ISNULL((SELECT ISNULL(', ' + gc.Category_of_Funding_Activity,'') 
		from link_Grants_Category gc
		where gc.gid = g.gid --this line is how you are "linking" the STUFF with tables from main query
		FOR XML PATH('')),'')),1,2,'')) as 'Grant Category',
	gt.Grantor_Type as 'Grantor Type'


from grants g
	left join [dbo].[link_Grants_Category] gc on g.GID = gc.GID
	left join grantor gt on g.Grantor_ID = gt.Grantor_ID
Where gc.Category_of_Funding_Activity = 'T'

 Order By G.GID

 /*Names of Categories */
 select * from [dbo].[lkup_Grants_Category]


/* Count of Categories*/

Select lct.Description, lct.ActivityCode, count(Category_of_Funding_Activity) as 'CatCount'
From lkup_Grants_Category lct inner join link_Grants_Category as lt on lct.ActivityCode = lt.Category_of_Funding_Activity
Group By ActivityCode, Description
Having count(Category_of_Funding_Activity) > 500
Order by ActivityCode 