using JADEG.Business;
using JADEG.Model;
using System.Web.Mvc;

namespace JADEG.Web.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View(new PlayerModel());
        }

        [HttpPost]
        public ActionResult Index(PlayerModel model)
        {
            model = new PlayerManager().GetPlayer(model.Name);
            Session.Add("player", model);
            return RedirectToAction("Explore", "Dungeon");
        }
    }
}