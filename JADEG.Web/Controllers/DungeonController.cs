using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using JADEG.Business;

namespace JADEG.Web.Controllers
{
    public class DungeonController : Controller
    {
        // GET: Dungeon
        public ActionResult Explore()
        {
           
            return View();
        }
    }
}