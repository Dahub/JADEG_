using JADEG.Model;
using System.Linq;
using System.Collections.Generic;
using System;

namespace JADEG.Web.Hubs
{
    public static class ClientStack
    {
        private readonly static IDictionary<string, IDictionary<string, PlayerModel>> _clients =
            new Dictionary<string, IDictionary<string, PlayerModel>>();

        public static void Add(string groupName, string connectionId, PlayerModel model)
        {
            lock (_clients)
            {
                if (!_clients.ContainsKey(groupName))
                {
                    _clients.Add(groupName, new Dictionary<string, PlayerModel>());
                }
                _clients[groupName].Add(connectionId, model);               
            }
        }

        public static void Update(string groupName, string connectionId, PlayerModel model)
        {
            lock (_clients)
            {
                if (!_clients.ContainsKey(groupName) || !_clients[groupName].ContainsKey(connectionId))
                {
                    Add(groupName, connectionId, model);
                }
                else
                {
                    _clients[groupName][connectionId] = model;
                }
            }
        }

        public static void Remove(string groupName, string connectionId)
        {
            lock (_clients)
            {
                if (_clients.ContainsKey(groupName) && _clients[groupName].ContainsKey(connectionId))
                {
                    _clients[groupName].Remove(connectionId);
                    if(_clients[groupName].Count == 0)
                    {
                        _clients.Remove(groupName);
                    }
                }
            }
        }

        public static PlayerModel Get(string groupName, string connectionId)
        {
            PlayerModel toReturn = new PlayerModel();

            lock (_clients)
            {
                if (_clients.ContainsKey(groupName) && _clients[groupName].ContainsKey(connectionId))
                {
                    toReturn = _clients[groupName][connectionId];
                }
            }

            return toReturn;
        }

        public static IDictionary<string, PlayerModel> Get(string groupName)
        {
            IDictionary<string, PlayerModel> toReturn = new Dictionary<string, PlayerModel>();

            if(_clients.ContainsKey(groupName))
            {
                toReturn = _clients[groupName];
            }

            return toReturn;
        }

        public static string GetGroupNameByClientId(string connectionId)
        {
            foreach(var c in _clients)
            {
                foreach(var id in c.Value)
                {
                    if (id.Key.Equals(connectionId))
                        return c.Key;
                }
            }
            return String.Empty;
        }
    }
}