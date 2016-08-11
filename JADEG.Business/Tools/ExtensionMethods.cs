using JADEG.Model;

namespace JADEG.Business
{
    internal static class ExtensionMethods
    {
        internal static PlayerModel ToDto(this Player toConvert)
        {
            PlayerModel toReturn = new PlayerModel()
            {
                Name = toConvert.Name,
                IsInDungeon = toConvert.FK_LinkDungeonTile.HasValue
            };
            if(toReturn.IsInDungeon)
            {
                toReturn.DungeonId = toConvert.LinkDungeonTile.FK_Dungeon;
                toReturn.XCoord = toConvert.LinkDungeonTile.XCoord;
                toReturn.YCoord = toConvert.LinkDungeonTile.XCoord;
            }

            return toReturn;
        }

        internal static TileModel ToDto(this LinkDungeonTile toConvert)
        {
            TileModel toReturn = new TileModel()
            {
                XCoord = toConvert.XCoord,
                YCoord = toConvert.YCoord,
                Background = toConvert.Tile.Backgound,
                DungeonId = toConvert.FK_Dungeon
            };
            foreach(var w in toConvert.Tile.Walls)
            {
                toReturn.Walls.Add(new WallModel()
                {
                    StartX = w.StartXCoord,
                    EndX = w.EndXCoord,
                    StartY = w.StartYCoord,
                    EndY = w.EndYCoord
                });
            }

            return toReturn;
        }
    }
}
