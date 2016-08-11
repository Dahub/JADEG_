using Owin;
using Microsoft.Owin;

[assembly: OwinStartup(typeof(JADEG.Web.Startup))]
namespace JADEG.Web
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            app.MapSignalR();
        }
    }
}