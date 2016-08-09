using System.Linq;

namespace JADEG.Business
{
    public class TileManager
    {
        public DtoTile GetTile(int dungeonId, int xCoord, int yCoord)
        {
            DtoTile toReturn = new DtoTile();

            using (var ctx = new Entities())
            {
                var myTile = ctx.LinkDungeonTile.Where(t => t.FK_Dungeon.Equals(dungeonId) && t.XCoord.Equals(xCoord) && t.YCoord.Equals(yCoord)).FirstOrDefault();
                if(myTile != null)
                {
                    toReturn = myTile.ToDto();
                }
            }

            return toReturn;
        }
    }
}
