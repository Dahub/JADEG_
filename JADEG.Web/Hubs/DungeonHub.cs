using System.Threading.Tasks;
using Microsoft.AspNet.SignalR;

namespace JADEG.Web.Hubs
{
    public class DungeonHub : Hub
    {
        private string groupNamePattern = "{0}#{1}#{2}";

        public override Task OnDisconnected(bool stopCalled)
        {
            string groupName = ClientStack.GetGroupNameByClientId(Context.ConnectionId);    
                   
            Clients.Group(groupName).playerQuit(ClientStack.Get(groupName)[Context.ConnectionId].Name);
            Groups.Remove(Context.ConnectionId, groupName);
            ClientStack.Remove(groupName, Context.ConnectionId);

            return base.OnDisconnected(stopCalled);
        }

        public void JoinTile(int dungeonId, int tileCoordX, int tileCoordY, string name, int posX, int posY, int dx, int dy)
        {
            string groupName = string.Format(groupNamePattern, dungeonId, tileCoordX, tileCoordY);
            Groups.Add(Context.ConnectionId, groupName);
            Clients.Group(groupName, Context.ConnectionId).newPlayerJoin(name, posX, posY);
            ClientStack.Add(groupName, Context.ConnectionId, new Model.PlayerModel()
            {
                DungeonId = dungeonId,
                IsInDungeon = true,
                Name = name,
                TileXCoord = tileCoordX,
                TileYCoord = tileCoordY,
                PosX = posX,
                PosY = posY
            });

            foreach (var p in ClientStack.Get(groupName))
            {
                Clients.Caller.newPlayerJoin(p.Value.Name, p.Value.PosX, p.Value.PosY, dx, dy);
            }
        }

        public void QuitTile(int dungeonId, int tileCoordX, int tileCoordY, string name)
        {
            string groupName = string.Format(groupNamePattern, dungeonId, tileCoordX, tileCoordY);

            Clients.Group(groupName, Context.ConnectionId).playerQuit(name);
            Groups.Remove(Context.ConnectionId, groupName);
            ClientStack.Remove(groupName, Context.ConnectionId);            
        }

        public void Move(int dungeonId, int tileCoordX, int tileCoordY, string name, int posX, int posY, int dx, int dy)
        {
            string groupName = string.Format(groupNamePattern, dungeonId, tileCoordX, tileCoordY);
            ClientStack.Update(groupName, Context.ConnectionId, new Model.PlayerModel()
            {
                DungeonId = dungeonId,
                IsInDungeon = true,
                Name = name,
                TileXCoord = tileCoordX,
                TileYCoord = tileCoordY,
                PosX = posX,
                PosY = posY
            });
            Clients.Group(groupName).movePlayer(name, posX, posY, dx, dy);
        }
    }
}