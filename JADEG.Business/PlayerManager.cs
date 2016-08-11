using JADEG.Model;
using System.Linq;

namespace JADEG.Business
{
    public class PlayerManager
    {
        public PlayerModel GetPlayer(string name)
        {
            PlayerModel toReturn = new PlayerModel();

            using (var ctx = new Entities())
            {
                Player player = ctx.Player.Where(p => p.Name.Equals(name)).First();
                toReturn = player.ToDto();
            }

            return toReturn;
        }
    }
}
