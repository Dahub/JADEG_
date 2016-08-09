namespace JADEG.Business
{
    internal static class ExtensionMethods
    {
        internal static DtoTile ToDto(this Tile toConvert)
        {
            DtoTile toReturn = new DtoTile()
            {
                XCoord = toConvert.XCoord,
                YCoord = toConvert.YCoord,
                Background = toConvert.Backgound,
            };
            foreach(var w in toConvert.Walls)
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
