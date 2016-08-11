using JADEG.Model;
using System.Collections.Generic;

namespace JADEG.Web.Hubs
{
    public static class ClientStack
    {
        private readonly static IDictionary<string, PlayerModel> _clients =
            new Dictionary<string, PlayerModel>();

        public static void Add(string connectionId, PlayerModel model)
        {
            lock (_clients)
            {
                if (!_clients.ContainsKey(connectionId))
                {
                    _clients.Add(connectionId, model);
                }
            }
        }

        public static void Update(string connectionId, PlayerModel model)
        {
            lock (_clients)
            {
                if (!_clients.ContainsKey(connectionId))
                {
                    _clients.Add(connectionId, model);
                }
                else
                {
                    _clients[connectionId] = model;
                }
            }
        }

        public static void Remove(string connectionId)
        {
            lock (_clients)
            {
                if (_clients.ContainsKey(connectionId))
                {
                    _clients.Remove(connectionId);
                }
            }
        }

        public static PlayerModel Get(string connectionId)
        {
            PlayerModel toReturn = new PlayerModel();

            lock (_clients)
            {
                if (_clients.ContainsKey(connectionId))
                {
                    toReturn = _clients[connectionId];
                }
            }

            return toReturn;
        }
    }
}