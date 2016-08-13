use Jadeg
go

if not exists 
(
	select schema_name
	from information_schema.schemata
	where schema_name = 'jadeg'
) 
begin
	exec sp_executesql N'CREATE SCHEMA jadeg'
end
go

if exists (select * from  sys.objects where object_id = object_id(N'[Jadeg].[SELECT_POSSIBLES_TILES]') and type in ( N'P', N'PC' )) 
begin
	drop procedure [Jadeg].[SELECT_POSSIBLES_TILES]
end 


if exists (select * from dbo.sysobjects where id = object_id(N'[jadeg].[Player]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [jadeg].[Player]
go
if exists (select * from dbo.sysobjects where id = object_id(N'[jadeg].[LinkDungeonTile]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [jadeg].[LinkDungeonTile]
go
if exists (select * from dbo.sysobjects where id = object_id(N'[jadeg].[Wall]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [jadeg].[Wall]
go
if exists (select * from dbo.sysobjects where id = object_id(N'[jadeg].[Tile]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [jadeg].[Tile]
go
if exists (select * from dbo.sysobjects where id = object_id(N'[jadeg].[TypeTile]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [jadeg].[TypeTile]
go
if exists (select * from dbo.sysobjects where id = object_id(N'[jadeg].[Dungeon]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [jadeg].[Dungeon]
go


create table [jadeg].[Dungeon]
(
	Id integer not null primary key identity(1,1),
	Name nvarchar(256) not null,
	Size integer not null
)
go

create table [jadeg].[TypeTile]
(
	Id integer not null primary key identity(1,1),
	Name nvarchar(256) not null,
	Rate integer not null
)
go

create table [jadeg].[Tile]
(
	Id integer not null primary key identity(1,1),	
	FK_TypeTile integer not null constraint FK_TypeTile_Tile foreign key references [jadeg].[TypeTile](Id),	
	Pitch integer not null,
	Backgound nvarchar(256) not null,
	CanLinkNorth bit not null,
	CanLinkSouth bit not null,
	CanLinkEast bit not null,
	CanLinkWest bit not null,
	Rate integer not null
)
go

alter table [jadeg].[Tile] add constraint unique_tile_background unique(Backgound)
go

create table [jadeg].[Wall]
(
	Id integer not null primary key identity(1,1),
	FK_Tile integer not null constraint FK_Wall_Tile foreign key references [jadeg].[Tile](Id),
	StartXCoord integer not null,
	EndXCoord integer not null,
	StartYCoord integer not null,
	EndYCoord integer not null
)
go

create table [jadeg].[LinkDungeonTile]
(
	Id integer not null primary key identity(1,1),
	FK_Tile integer not null constraint FK_LinkDungeonTile_Tile foreign key references [jadeg].[Tile](Id),
	FK_Dungeon integer not null constraint FK_LinkDungeonTile_Dungeon foreign key references [jadeg].[Dungeon](Id),
	XCoord integer not null,
	YCoord integer not null
)
go

create table [jadeg].[Player]
(
	Id integer not null primary key identity(1,1),
	FK_LinkDungeonTile integer null constraint FK_Player_LinkDungeonTile foreign key references [jadeg].[LinkDungeonTile](Id),
	Name nvarchar(256) not null
)
go

create procedure [Jadeg].[SELECT_POSSIBLES_TILES]
(
	@x integer,
	@y integer,
	@dungeonId integer
)
as
begin	
	declare @mustLinkSouth bit
	declare @mustLinkNorth bit
	declare @mustLinkWest bit
	declare @mustLinkEast bit
	declare @size integer
	select @size = Size from [Jadeg].[Dungeon] where Id =  @dungeonId

	if(@y >= @size)			
		set @mustLinkNorth = 0
	else
		select @mustLinkNorth = CanLinkSouth 
		from [jadeg].[LinkDungeonTile] 
		inner join [jadeg].[Tile] t on FK_Tile = t.Id
		where FK_Dungeon = @dungeonId and XCoord = @x and YCoord = @y + 1	

	if(-1 * @y >= @size)
		set @mustLinkSouth = 0
	else
		select @mustLinkSouth = CanLinkNorth
		from [jadeg].[LinkDungeonTile] 
		inner join [jadeg].[Tile] t on FK_Tile = t.Id
		where FK_Dungeon = @dungeonId and XCoord = @x and YCoord = @y - 1

	if(-1 * @x >= @size)
		set @mustLinkWest = 0
	else
		select @mustLinkWest = CanLinkEast
		from [jadeg].[LinkDungeonTile] 
		inner join [jadeg].[Tile] t on FK_Tile = t.Id
		where FK_Dungeon = @dungeonId and XCoord = @x - 1 and YCoord = @y

	if( @x >= @size)
		set @mustLinkEast = 0
	else
		select @mustLinkEast = CanLinkWest
		from [jadeg].[LinkDungeonTile] 
		inner join [jadeg].[Tile] t on FK_Tile = t.Id
		where FK_Dungeon = @dungeonId and XCoord = @x + 1 and YCoord = @y

	select * from [Jadeg].[Tile]
	where 1 = 1
	and (@mustLinkSouth is null or CanLinkSouth = @mustLinkSouth)
	and (@mustLinkNorth is null or CanLinkNorth = @mustLinkNorth)
	and (@mustLinkEast is null or CanLinkEast = @mustLinkEast)
	and (@mustLinkWest is null or CanLinkWest = @mustLinkWest)
end
go


insert into [jadeg].[TypeTile] (Name, Rate) values ('Classic', 95)
insert into [jadeg].[TypeTile] (Name, Rate) values ('Entrance', 0)
insert into [jadeg].[TypeTile] (Name, Rate) values ('Exit', 5)

declare @idTile integer
-- nesw
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 600, 'nesw', 1, 1, 1, 1, 105)
set @idTile = @@IDENTITY  
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 200, 200)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 400, 0, 600, 200)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 400, 200, 600)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 400, 400, 600, 600)

-- e
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 600, 'e', 0, 0, 1, 0, 5)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 400, 80)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 400, 0, 600, 200)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 520, 400, 600)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 400, 400, 600, 600)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 80, 80, 520)

-- es
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 600, 'es', 0, 1, 1, 0, 25)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 400, 400, 600, 600)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 600, 200)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 200, 200, 600)

-- esw
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 600, 'esw', 0, 1, 1, 1, 75)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 400, 400, 600, 600)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 400, 200, 600)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 600, 200)

-- ew
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 600, 'ew', 0, 0, 1, 1, 25)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 600, 200)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 400, 600, 600)

-- n
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 600, 'n', 1, 0, 0, 0, 5)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 200, 200)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 400, 0, 600, 200)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 200, 80, 600)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 520, 200, 520, 600)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 80, 520, 520, 600)

--ne
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 600, 'ne', 1, 0, 1, 0, 25)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 400, 0, 600, 200)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 200, 600)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 200, 400, 600, 600)


--nes
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 600, 'nes', 1, 1, 1, 0, 75)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 400, 0, 600, 200)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 400, 400, 600, 600)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 200, 600)

-- new
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 600, 'new', 1, 0, 1, 1, 75)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 200, 200)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 400, 0, 600, 200)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 400, 600, 600)

-- ns
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 600, 'ns', 1, 1, 0, 0, 25)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 400, 0, 600, 600)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 200, 600)

-- nsw
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 600, 'nsw', 1, 1, 0, 1, 75)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 200, 200)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 400, 200, 600)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 400, 0, 600, 600)

-- s
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 600, 's', 0, 1, 0, 0, 5)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 400, 200, 600)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 400, 400, 600, 600)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 80, 400)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 520, 0, 600, 400)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 80, 0, 520, 80)

-- sw
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 600, 'sw', 0, 1, 0, 1, 25)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 600, 200)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 400, 200, 600)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 400, 200, 600, 600)

-- w
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 600, 'w', 0, 0, 0, 1, 5)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 200, 200)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 400, 200, 600)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 200, 0, 600, 80)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 200, 520, 600, 600)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 520, 80, 600, 520)

-- wn
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 600, 'wn', 1, 0, 0, 1, 25)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 200, 200)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 400, 0, 600, 400)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 400, 600, 600)
go

-- données de test
insert into [jadeg].[Dungeon] (Name, size) values ('Donjon de test', 2)
go

insert into [jadeg].[LinkDungeonTile] (FK_Tile, FK_Dungeon, XCoord, YCoord) values (1,1,0,0)
go

insert into [jadeg].[Player] (FK_LinkDungeonTile, name) values (1, 'A')
insert into [jadeg].[Player] (FK_LinkDungeonTile, name) values (1, 'B')
insert into [jadeg].[Player] (FK_LinkDungeonTile, name) values (1, 'C')

exec [Jadeg].[SELECT_POSSIBLES_TILES] 0,-1,1

select * from [Jadeg].[LinkDungeonTile] l
inner join [jadeg].[tile] t on l.FK_Tile = t.Id

declare @x integer
declare @y integer
set @x = 0
set @y = -1
select case when -1 * (@x - 1) > Size then 0 else CanLinkEast end
	from [jadeg].[Dungeon] d
	left join [jadeg].[LinkDungeonTile] dt on d.Id = dt.FK_Dungeon
	left join [jadeg].[Tile] t on FK_Tile = t.Id and XCoord = @x - 1 and YCoord = @y
	where FK_Dungeon = 1

select case when @y + 1 > Size then 0 else CanLinkSouth end 
	from [jadeg].[Dungeon] d
	left join [jadeg].[LinkDungeonTile] dt on d.Id = dt.FK_Dungeon
	left join [jadeg].[Tile] t on FK_Tile = t.Id and XCoord = @x and YCoord = @y + 1
	where d.Id = 1 
	

--select * from [jadeg].[tile]
--select * from [jadeg].[LinkDungeonTile]
--order by FK_Tile

--declare @x integer;
--declare @y integer;
--declare @dungeonId integer
--set @x = 0;
--set @y = 1;
--set @dungeonId = 1;

--declare @mustLinkSouth bit
--declare @mustLinkNorth bit
--declare @mustLinkWest bit
--declare @mustLinkEast bit

--select @mustLinkNorth = CanLinkSouth 
--from [jadeg].[LinkDungeonTile] 
--inner join [jadeg].[Tile] t on FK_Tile = t.Id
--where FK_Dungeon = @dungeonId and XCoord = @x and YCoord = @y + 1

--select @mustLinkSouth = CanLinkNorth
--from [jadeg].[LinkDungeonTile] 
--inner join [jadeg].[Tile] t on FK_Tile = t.Id
--where FK_Dungeon = @dungeonId and XCoord = @x and YCoord = @y - 1

--select @mustLinkWest = CanLinkEast
--from [jadeg].[LinkDungeonTile] 
--inner join [jadeg].[Tile] t on FK_Tile = t.Id
--where FK_Dungeon = @dungeonId and XCoord = @x - 1 and YCoord = @y

--select @mustLinkEast = CanLinkWest
--from [jadeg].[LinkDungeonTile] 
--inner join [jadeg].[Tile] t on FK_Tile = t.Id
--where FK_Dungeon = @dungeonId and XCoord = @x + 1 and YCoord = @y

--select * from [Jadeg].[Tile]
--where 1 = 1
--and (@mustLinkSouth is null or CanLinkSouth = @mustLinkSouth)
--and (@mustLinkNorth is null or CanLinkNorth = @mustLinkNorth)
--and (@mustLinkEast is null or CanLinkEast = @mustLinkEast)
--and (@mustLinkWest is null or CanLinkWest = @mustLinkWest)



	select case when(2 > 3) then 0 else CanLinkSouth end
	from [jadeg].[Dungeon] d
	left join [jadeg].[LinkDungeonTile] dt on d.Id = dt.FK_Dungeon
	left join [jadeg].[Tile] t on FK_Tile = t.Id and XCoord = 0 and YCoord = 2
	where d.Id = 1 
