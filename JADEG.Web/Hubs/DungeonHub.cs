using Microsoft.AspNet.SignalR;

namespace JADEG.Web.Hubs
{
    public class DungeonHub : Hub
    {
        private string groupNamePattern = "{0}#{1}#{2}";

        public void JoinTile(int dungeonId, int coordX, int coordY, string name, double posX, double posY)
        {
            string groupName = string.Format(groupNamePattern, dungeonId, coordX, coordY);
            Groups.Add(Context.ConnectionId, groupName);
            //ClientStack.Add(Context.ConnectionId, new Model.PlayerModel()
            //{
            //    DungeonId = dungeonId,
            //    IsInDungeon = true,
            //    Name = name,
            //    XCoord = coordX,
            //    YCoord = coordY
            //});
            Clients.Group(groupName, Context.ConnectionId).newPlayerJoin(name, posX, posY);
        }

        public void QuitTile(int dungeonId, int coordX, int coordY, string name)
        {
            string groupName = string.Format(groupNamePattern, dungeonId, coordX, coordY);
            Groups.Remove(Context.ConnectionId, groupName);
            // ClientStack.Remove(Context.ConnectionId);
            Clients.Group(groupName, Context.ConnectionId).playerQuit(name);
        }

        public void Move(string playerName, double posX, double posY, int dungeonId, int coordX, int coordY)
        {
            Clients.Group(string.Format(groupNamePattern, dungeonId, coordX, coordY), Context.ConnectionId).movePlayer(playerName, posX, posY);
        }
    }
}