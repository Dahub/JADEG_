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
	Name nvarchar(256) not null,
	Skin nvarchar(256) not null
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
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 40, 'nesw', 1, 1, 1, 1, 80)
set @idTile = @@IDENTITY  
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 5, 5)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 10, 0, 15, 5)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 10, 5, 15)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 10, 10, 15, 15)

-- e
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 40, 'e', 0, 0, 1, 0, 5)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 10, 2)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 10, 0, 15, 5)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 13, 10, 15)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 10, 10, 15, 15)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 2, 2, 13)

-- es
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 40, 'es', 0, 1, 1, 0, 25)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 10, 10, 15, 15)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 15, 5)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 5, 5, 15)

-- esw
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 40, 'esw', 0, 1, 1, 1, 75)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 10, 10, 15, 15)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 10, 5, 15)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 15, 5)

-- ew
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 40, 'ew', 0, 0, 1, 1, 25)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 15, 5)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 10, 15, 15)

-- n
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 40, 'n', 1, 0, 0, 0, 5)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 5, 5)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 10, 0, 15, 5)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 5, 2, 15)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 13, 5, 15, 15)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 2, 13, 13, 15)

--ne
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 40, 'ne', 1, 0, 1, 0, 25)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 10, 0, 15, 5)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 5, 15)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 5, 10, 15, 15)

--nes
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 40, 'nes', 1, 1, 1, 0, 75)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 10, 0, 15, 5)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 10, 10, 15, 15)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 5, 15)

-- new
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 40, 'new', 1, 0, 1, 1, 75)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 5, 5)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 10, 0, 15, 5)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 10, 15, 15)

-- ns
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 40, 'ns', 1, 1, 0, 0, 25)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 10, 0, 15, 15)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 5, 15)

-- nsw
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 40, 'nsw', 1, 1, 0, 1, 75)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 5, 5)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 10, 5, 15)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 10, 0, 15, 15)

-- s
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 40, 's', 0, 1, 0, 0, 5)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 10, 5, 15)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 10, 10, 15, 15)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 2, 10)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 13, 0, 15, 10)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 2, 0, 13, 2)

-- sw
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 40, 'sw', 0, 1, 0, 1, 25)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 15, 5)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 10, 5, 15)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 10, 5, 15, 15)

-- w
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 40, 'w', 0, 0, 0, 1, 5)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 5, 5)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 10, 5, 15)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 5, 0, 15, 2)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 5, 13, 15, 15)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 13, 2, 15, 13)

-- wn
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 40, 'wn', 1, 0, 0, 1, 25)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 5, 5)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 10, 0, 15, 10)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 10, 15, 15)
go

-- données de test
insert into [jadeg].[Dungeon] (Name, size) values ('Donjon de test', 3)
go

insert into [jadeg].[LinkDungeonTile] (FK_Tile, FK_Dungeon, XCoord, YCoord) values (1,1,0,0)
go

insert into [jadeg].[Player] (FK_LinkDungeonTile, name, Skin) values (1, 'A', 's_witch')
insert into [jadeg].[Player] (FK_LinkDungeonTile, name, Skin) values (1, 'B', 's_gobelin')
insert into [jadeg].[Player] (FK_LinkDungeonTile, name, Skin) values (1, 'C', 's_human')

--exec [Jadeg].[SELECT_POSSIBLES_TILES] 0,-1,1

select * from [Jadeg].[LinkDungeonTile] l
inner join [jadeg].[tile] t on l.FK_Tile = t.Id

--declare @x integer
--declare @y integer
--set @x = 0
--set @y = -1
--select case when -1 * (@x - 1) > Size then 0 else CanLinkEast end
--	from [jadeg].[Dungeon] d
--	left join [jadeg].[LinkDungeonTile] dt on d.Id = dt.FK_Dungeon
--	left join [jadeg].[Tile] t on FK_Tile = t.Id and XCoord = @x - 1 and YCoord = @y
--	where FK_Dungeon = 1

--select case when @y + 1 > Size then 0 else CanLinkSouth end 
--	from [jadeg].[Dungeon] d
--	left join [jadeg].[LinkDungeonTile] dt on d.Id = dt.FK_Dungeon
--	left join [jadeg].[Tile] t on FK_Tile = t.Id and XCoord = @x and YCoord = @y + 1
--	where d.Id = 1 
	

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
