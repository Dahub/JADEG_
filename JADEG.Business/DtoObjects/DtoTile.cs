using System.Collections.Generic;

namespace JADEG.Business
{
    public class DtoTile
    {
        public DtoTile()
        {
            Walls = new List<DtoWall>();
        }

        public int XCoord { get; set; }
        public int YCoord { get; set; }
        public string Background { get; set; }
        public IList<DtoWall> Walls { get; set; }
    }
}
