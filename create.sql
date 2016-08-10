use [Perso]
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
	Name nvarchar(256) not null
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


insert into [jadeg].[TypeTile] (Name, Rate) values ('Classic', 95)
insert into [jadeg].[TypeTile] (Name, Rate) values ('Entrance', 0)
insert into [jadeg].[TypeTile] (Name, Rate) values ('Exit', 5)

-- données de test
insert into [jadeg].[Dungeon] (Name) values ('Donjon de test')
go

declare @idTile integer
-- nesw
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 120, 'nesw', 1, 1, 1, 1, 20)
set @idTile = @@IDENTITY  
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 40, 40)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 80, 0, 120, 40)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 80, 40, 120)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 80, 80, 120, 120)

-- e
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 120, 'e', 0, 0, 1, 0, 2)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 80, 10)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 80, 0, 120, 40)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 120, 80, 110)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 80, 80, 120, 120)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 10, 10, 110)

-- es
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 120, 'es', 0, 1, 1, 0, 4)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 80, 80, 120, 120)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 120, 40)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 40, 40, 120)

-- esw
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 120, 'esw', 0, 1, 1, 1, 5)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 80, 80, 120, 120)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 80, 40, 120)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 120, 40)

-- ew
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 120, 'ew', 0, 1, 0, 1, 4)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 120, 40)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 80, 120, 120)

-- n
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 120, 'n', 1, 0, 0, 0, 2)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 40, 40)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 80, 0, 120, 40)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 40, 10, 120)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 110, 40, 110, 120)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 10, 110, 110, 120)

--ne
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 120, 'ne', 1, 0, 1, 0, 4)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 80, 0, 120, 40)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 40, 120)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 40, 80, 120, 120)


--nes
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 120, 'nes', 1, 1, 1, 0, 5)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 80, 0, 120, 40)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 80, 80, 120, 120)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 40, 120)

-- new
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 120, 'new', 1, 0, 1, 1, 5)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 40, 40)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 80, 0, 120, 40)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 80, 120, 120)

-- ns
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 120, 'ns', 1, 1, 0, 0, 4)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 80, 0, 120, 120)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 40, 120)

-- nsw
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 120, 'nsw', 1, 1, 0, 1, 5)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 40, 40)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 80, 40, 120)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 80, 0, 120, 120)

-- s
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 120, 's', 0, 1, 0, 0, 2)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 80, 40, 120)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 80, 80, 120, 120)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 10, 80)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 110, 0, 120, 80)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 10, 0, 110, 10)

-- sw
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 120, 'sw', 0, 1, 0, 1, 4)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 120, 40)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 80, 40, 120)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 80, 40, 120, 120)

-- w
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 120, 'w', 0, 0, 0, 1, 2)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 40, 40)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 80, 40, 120)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 40, 0, 120, 10)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 40, 110, 120, 120)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 110, 10, 120, 110)

-- wn
insert into [jadeg].[Tile] (FK_TypeTile, Pitch, Backgound, CanLinkNorth, CanLinkSouth, CanLinkEast, CanLinkWest, Rate) values (1, 120, 'wn', 1, 0, 0, 1, 4)
set @idTile = @@IDENTITY 
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 0, 40, 40)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 80, 0, 120, 80)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (@idTile, 0, 80, 120, 120)
go

insert into [jadeg].[LinkDungeonTile] (FK_Tile, FK_Dungeon, XCoord, YCoord) values (1,1,0,0)
insert into [jadeg].[LinkDungeonTile] (FK_Tile, FK_Dungeon, XCoord, YCoord) values (15,1,1,0)
insert into [jadeg].[LinkDungeonTile] (FK_Tile, FK_Dungeon, XCoord, YCoord) values (10,1,1,1)
go


--select * from [jadeg].[tile]


declare @x integer;
declare @y integer;
declare @dungeonId integer
set @x = 0;
set @y = 1;
set @dungeonId = 1;

select 
max(mustBeOpenNorth) as north,
max(mustBeOpenSouth) as south,
max(mustBeOpenWest) as west,
max(mustBeOpenEast) as east
from
(	
	select -- NORTH
	CanLinkSouth as mustBeOpenNorth,
	null as mustBeOpenSouth,
	null as mustBeOpenEast,
	null as mustBeOpenWest
	from [jadeg].[LinkDungeonTile] ldt 
	inner join [jadeg].[Tile] t on ldt.FK_Tile = t.Id
	where ldt.FK_Dungeon = @dungeonId and ldt.XCoord = @x and ldt.YCoord = @y + 1
	union
	select -- SOUTH
	null as mustBeOpenNorth,
	CanLinkNorth as mustBeOpenSouth,
	null as mustBeOpenEast,
	null as mustBeOpenWest
	from [jadeg].[LinkDungeonTile] ldt 
	inner join [jadeg].[Tile] t on ldt.FK_Tile = t.Id
	where ldt.FK_Dungeon = @dungeonId and ldt.XCoord = @x and ldt.YCoord = @y - 1
	union
	select -- EAST
	null as mustBeOpenNorth,
	null as mustBeOpenSouth,
	CanLinkWest as mustBeOpenEast,
	null as mustBeOpenWest
	from [jadeg].[LinkDungeonTile] ldt 
	inner join [jadeg].[Tile] t on ldt.FK_Tile = t.Id
	where ldt.FK_Dungeon = @dungeonId and ldt.XCoord = @x + 1 and ldt.YCoord = @y
	union
	select -- WEST
	null as mustBeOpenNorth,
	null as mustBeOpenSouth,
	null as mustBeOpenEast,
	CanLinkEast as mustBeOpenWest
	from [jadeg].[LinkDungeonTile] ldt 
	inner join [jadeg].[Tile] t on ldt.FK_Tile = t.Id
	where ldt.FK_Dungeon = @dungeonId and ldt.XCoord = @x - 1 and ldt.YCoord = @y
)u



inner join [jadeg].[Tile] 
on 
(mustBeOpenSouth is null or CanLinkSouth = mustBeOpenSouth)
and (mustBeOpenNorth is null or CanLinkNorth = mustBeOpenNorth)
and (mustBeOpenEast is null or CanLinkEast = mustBeOpenEast)
and (mustBeOpenWest is null or CanLinkWest = mustBeOpenWest)