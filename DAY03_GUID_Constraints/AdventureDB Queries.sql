[Person].[Address]
[Person].[Person]



select top 15 * from [Person].[Person]
--Error
INSERT INTO [Person].[Person] (BusinessEntityID,PersonType,NameStyle,Title,FirstName,LastName)
Values (
20778,'EM',0,'Mr.','ASAD','ALI');

select top 15 BusinessEntityID, LastName from [Person].[Person]
union all
select top 15 BusinessEntityID, LastName from [Person].[Person] order by BusinessEntityID desc

select top 15 BusinessEntityID, LastName from [Person].[Person]
union 
select top 15 BusinessEntityID, LastName from [Person].[Person] order by BusinessEntityID desc