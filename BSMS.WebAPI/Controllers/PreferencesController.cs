using BSMS.BusinessLayer.Queries;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BSMS.WebAPI.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/customers/preferences")]
    public class PreferencesController : ControllerBase
    {
        private readonly IMediator _mediator;

        public PreferencesController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpGet]
        public async Task<IActionResult> GetPreferences()
        {
            return Ok(await _mediator.Send(new GetAllPreferencesQuery {}));
        }
    }
}
