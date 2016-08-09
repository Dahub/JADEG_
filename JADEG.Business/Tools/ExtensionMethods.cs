namespace JADEG.Business
{
    internal static class ExtensionMethods
    {
        internal static DtoTile ToDto(this LinkDungeonTile toConvert)
        {
            DtoTile toReturn = new DtoTile()
            {
                XCoord = toConvert.XCoord,
                YCoord = toConvert.YCoord,
                Background = toConvert.Tile.Backgound,
            };
            foreach(var w in toConvert.Tile.Walls)
            {
                toReturn.Walls.Add(new DtoWall()
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
