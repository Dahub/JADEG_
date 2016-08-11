using System.Threading.Tasks;
using Microsoft.AspNet.SignalR;

namespace JADEG.Web.Hubs
{
    public class DungeonHub : Hub
    {
        private string groupNamePattern = "{0}#{1}#{2}";

        public void JoinTile(int dungeonId, int coordX, int coordY)
        {
            Groups.Add(Context.ConnectionId, string.Format(groupNamePattern, dungeonId, coordX, coordY));
        }

        public void QuitTile(int dungeonId, int coordX, int coordY)
        {
            Groups.Remove(Context.ConnectionId, string.Format(groupNamePattern, dungeonId, coordX, coordY));
        }

        public void Move(string playerName, double posX, double posY, int dungeonId, int coordX, int coordY)
        {
            Clients.Group(string.Format(groupNamePattern, dungeonId, coordX, coordY)).movePlayer(playerName, posX, posY);
        }
    }
}