use [Jadeg]
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
	FK_Dungeon integer not null constraint FK_Tile_Dungeon foreign key references [jadeg].[Dungeon](Id),
	FK_TypeTile integer not null constraint FK_TypeTile_Tile foreign key references [jadeg].[TypeTile](Id),
	XCoord integer not null,
	YCoord integer not null,
	Pitch integer not null,
	Backgound nvarchar(256) not null,
	Content nvarchar(max)
)
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

alter table [jadeg].[Tile] add constraint unique_tile_for_dungeon unique(FK_Dungeon, XCoord, YCoord)
go

insert into [jadeg].[TypeTile] (Name, Rate) values ('Classic', 95)
insert into [jadeg].[TypeTile] (Name, Rate) values ('Entrance', 0)
insert into [jadeg].[TypeTile] (Name, Rate) values ('Exit', 5)

-- données de test
insert into [jadeg].[Dungeon] (Name) values ('Donjon de test')
go
insert into [jadeg].[Tile] (FK_Dungeon, FK_TypeTile, Pitch, XCoord, YCoord, Content, Backgound) values (1, 1, 120, 0, 0, '', 'nesw')
go
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (1, 0, 0, 40, 40)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (1, 80, 0, 120, 40)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (1, 0, 80, 40, 120)
insert into [jadeg].[Wall] (FK_Tile, StartXCoord, StartYCoord, EndXCoord, EndYCoord) values (1, 80, 80, 120, 120)
go